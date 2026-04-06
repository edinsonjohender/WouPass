import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:woupassv2/core/networking/message.dart';
import 'package:woupassv2/core/networking/protocol_constants.dart';
import 'package:woupassv2/core/networking/session_crypto.dart';

class PairResult {
  final String deviceId;
  final String deviceName;
  final String ip;
  final int port;
  final String pairingSecret;

  PairResult({
    required this.deviceId,
    required this.deviceName,
    required this.ip,
    required this.port,
    required this.pairingSecret,
  });
}

class CredentialSender {
  /// Pair with a new desktop by scanning QR code data.
  /// Ephemeral connection: connect, pair, close.
  static Future<PairResult?> pairWithDesktop({
    required String ip,
    required int port,
    required String desktopId,
    required String desktopName,
  }) async {
    Socket? socket;
    try {
      socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(seconds: ProtocolConstants.connectionTimeoutSeconds),
      );

      final crypto = SessionCrypto();

      // 1. Generate X25519 keypair
      final ourPublicKey = await crypto.generateKeyPair();

      // 2. Send PAIR_REQUEST
      final pairRequest = ProtocolMessage(
        type: MessageType.pairRequest,
        id: DateTime.now().microsecondsSinceEpoch.toRadixString(36),
        seq: 0,
        payload: {
          'phone_name': 'WouPass Phone',
          'phone_id': DateTime.now().millisecondsSinceEpoch.toString(),
          'ecdh_public_key': base64Encode(ourPublicKey),
        },
      );
      _send(socket, pairRequest.toJsonString());

      // 3. Receive PAIR_RESPONSE
      final responseStr = await _readOne(socket);
      final response = ProtocolMessage.fromJsonString(responseStr);

      if (response.type != MessageType.pairResponse) {
        return null;
      }

      final accepted = response.payload['accepted'] as bool? ?? false;
      if (!accepted) {
        return null;
      }

      final desktopPubBase64 = response.payload['ecdh_public_key'] as String?;
      if (desktopPubBase64 == null) {
        return null;
      }

      final resolvedDesktopName =
          response.payload['desktop_name'] as String? ?? desktopName;
      final resolvedDesktopId =
          response.payload['desktop_id'] as String? ?? desktopId;

      // 4. Derive session key
      final desktopPubBytes = base64Decode(desktopPubBase64);
      await crypto.deriveSessionKey(
        Uint8List.fromList(desktopPubBytes),
        'qr_verified',
      );

      // 5. Send PAIR_CONFIRM (encrypted)
      final verification = await crypto.createVerification('PAIR_CONFIRM');
      final confirm = ProtocolMessage(
        type: MessageType.pairConfirm,
        id: DateTime.now().microsecondsSinceEpoch.toRadixString(36),
        seq: 0,
        payload: {'verification': verification},
      );
      final encrypted = await crypto.encryptMessage(confirm.toJsonString());
      _send(socket, encrypted);

      // 6. Receive PAIR_CONFIRMED
      final confirmedStr = await _readOne(socket);
      // May be encrypted or plaintext
      String confirmedJson;
      if (crypto.isEstablished) {
        final decrypted = await crypto.decryptMessage(confirmedStr);
        confirmedJson = decrypted ?? confirmedStr;
      } else {
        confirmedJson = confirmedStr;
      }
      final confirmed = ProtocolMessage.fromJsonString(confirmedJson);

      if (confirmed.type != MessageType.pairConfirmed) {
        return null;
      }

      // Derive pairing secret for encrypting future reconnect ECDH exchanges
      final pairingSecret =
          await crypto.createVerification('pairing-secret-v1');

      crypto.dispose();

      return PairResult(
        deviceId: resolvedDesktopId,
        deviceName: resolvedDesktopName,
        ip: ip,
        port: port,
        pairingSecret: pairingSecret,
      );
    } catch (e) {
      return null;
    } finally {
      _activeReader?.dispose();
      _activeReader = null;
      socket?.destroy();
    }
  }

  /// Send a credential to a previously paired desktop.
  /// Ephemeral connection: connect, authenticate via PSK, send, close.
  static Future<bool> sendCredential({
    required String ip,
    required int port,
    required String deviceId,
    required String pairingSecret,
    required String title,
    required String username,
    required String password,
    required String uri,
  }) async {
    Socket? socket;
    try {
      socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(seconds: ProtocolConstants.connectionTimeoutSeconds),
      );

      // Phase 1: Send plaintext RECONNECT with only device_id (no keys)
      final reconnect = ProtocolMessage(
        type: MessageType.reconnect,
        id: DateTime.now().microsecondsSinceEpoch.toRadixString(36),
        seq: 0,
        payload: {
          'device_id': deviceId,
        },
      );
      _send(socket, reconnect.toJsonString());

      // Phase 2: Set up PSK crypto for encrypted ECDH exchange
      final pskCrypto = SessionCrypto();
      await pskCrypto.setPreSharedKey(pairingSecret);

      final ephemeralCrypto = SessionCrypto();
      final ourPublicKey = await ephemeralCrypto.generateKeyPair();

      // Send RECONNECT_AUTH encrypted with PSK (contains our ECDH public key)
      final reconnectAuth = ProtocolMessage(
        type: MessageType.reconnectAuth,
        id: DateTime.now().microsecondsSinceEpoch.toRadixString(36),
        seq: 0,
        payload: {
          'ecdh_public_key': base64Encode(ourPublicKey),
        },
      );
      final encAuth =
          await pskCrypto.encryptMessage(reconnectAuth.toJsonString());
      _send(socket, encAuth);

      // Receive RECONNECT_OK encrypted with PSK
      final responseEnc = await _readOne(socket);
      final responseJson = await pskCrypto.decryptMessage(responseEnc);
      if (responseJson == null) {
        return false;
      }
      final response = ProtocolMessage.fromJsonString(responseJson);

      if (response.type != MessageType.reconnectOk) {
        return false;
      }

      final desktopPubBase64 = response.payload['ecdh_public_key'] as String?;
      if (desktopPubBase64 == null) {
        return false;
      }

      // Phase 3: Derive ephemeral session key from ECDH
      final desktopPubBytes = base64Decode(desktopPubBase64);
      await ephemeralCrypto.deriveSessionKey(
        Uint8List.fromList(desktopPubBytes),
        'qr_verified',
      );

      // Phase 4: Send PUSH_CREDENTIAL encrypted with ephemeral session key
      final push = ProtocolMessage(
        type: MessageType.pushCredential,
        id: DateTime.now().microsecondsSinceEpoch.toRadixString(36),
        seq: 0,
        payload: {
          'title': title,
          'username': username,
          'password': password,
          'uri': uri,
        },
      );
      final encrypted =
          await ephemeralCrypto.encryptMessage(push.toJsonString());
      _send(socket, encrypted);

      pskCrypto.dispose();
      ephemeralCrypto.dispose();
      return true;
    } catch (e) {
      return false;
    } finally {
      _activeReader?.dispose();
      _activeReader = null;
      socket?.destroy();
    }
  }

  /// Send a length-prefixed message over the socket.
  static void _send(Socket socket, String message) {
    final payload = utf8.encode(message);
    final header = Uint8List(4);
    ByteData.sublistView(header).setUint32(0, payload.length, Endian.big);
    socket.add(header);
    socket.add(payload);
  }

  /// Helper class that manages a persistent socket subscription
  /// and allows reading multiple messages sequentially.
  static _SocketReader? _activeReader;

  static _SocketReader _getReader(Socket socket) {
    _activeReader?.dispose();
    _activeReader = _SocketReader(socket);
    return _activeReader!;
  }

  /// Read one length-prefixed message from the socket.
  static Future<String> _readOne(Socket socket) async {
    // Reuse existing reader or create new one
    if (_activeReader == null || _activeReader!._socket != socket) {
      _activeReader = _SocketReader(socket);
    }
    return _activeReader!.readMessage();
  }
}

/// Manages a persistent socket subscription for reading multiple messages.
class _SocketReader {
  final Socket _socket;
  final _buffer = BytesBuilder();
  final _messageQueue = <Completer<String>>[];
  StreamSubscription<Uint8List>? _sub;
  bool _disposed = false;

  _SocketReader(this._socket) {
    _sub = _socket.listen(
      (data) {
        _buffer.add(data);
        _processBuffer();
      },
      onDone: () {
        for (final c in _messageQueue) {
          if (!c.isCompleted) c.completeError('Connection closed');
        }
        _messageQueue.clear();
      },
      onError: (e) {
        for (final c in _messageQueue) {
          if (!c.isCompleted) c.completeError(e);
        }
        _messageQueue.clear();
      },
    );
  }

  Future<String> readMessage() {
    final completer = Completer<String>();
    _messageQueue.add(completer);
    _processBuffer(); // Check if data already in buffer
    return completer.future.timeout(
      const Duration(seconds: ProtocolConstants.connectionTimeoutSeconds),
      onTimeout: () {
        _messageQueue.remove(completer);
        throw TimeoutException('Timed out waiting for response');
      },
    );
  }

  void _processBuffer() {
    while (_messageQueue.isNotEmpty) {
      final bytes = _buffer.toBytes();

      if (bytes.length < 4) return;

      final length = ByteData.sublistView(
        Uint8List.fromList(bytes.sublist(0, 4)),
      ).getUint32(0, Endian.big);

      if (bytes.length < 4 + length) return;

      final payload = utf8.decode(bytes.sublist(4, 4 + length));

      _buffer.clear();
      if (bytes.length > 4 + length) {
        _buffer.add(bytes.sublist(4 + length));
      }

      final completer = _messageQueue.removeAt(0);
      if (!completer.isCompleted) completer.complete(payload);
    }
  }

  void dispose() {
    _disposed = true;
    _sub?.cancel();
    _sub = null;
  }
}
