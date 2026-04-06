import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class SessionCrypto {
  SimpleKeyPair? _keyPair;
  Uint8List? _sessionKey;
  int _sendSeq = 0;
  int _lastReceivedSeq = -1;
  Uint8List? _sessionNoncePrefix; // 4 random bytes fixed per session

  final _x25519 = X25519();
  final _aesGcm = AesGcm.with256bits();
  final _hkdf = Hkdf(hmac: Hmac(Sha256()), outputLength: 32);

  /// Generate ephemeral X25519 keypair
  Future<Uint8List> generateKeyPair() async {
    final pair = await _x25519.newKeyPair();
    _keyPair = pair;
    final pub = await pair.extractPublicKey();
    return Uint8List.fromList(pub.bytes);
  }

  /// Derive session key from ECDH shared secret + pairing code
  Future<void> deriveSessionKey(
      Uint8List remotePublicKeyBytes, String pairingCode) async {
    if (_keyPair == null) throw StateError('Key pair not generated');

    final remotePublicKey =
        SimplePublicKey(remotePublicKeyBytes, type: KeyPairType.x25519);
    final sharedSecret = await _x25519.sharedSecretKey(
      keyPair: _keyPair!,
      remotePublicKey: remotePublicKey,
    );

    // salt = SHA256("woupass" || code)
    final saltInput = utf8.encode('woupass$pairingCode');
    final saltHash = await Sha256().hash(saltInput);

    final derived = await _hkdf.deriveKey(
      secretKey: sharedSecret,
      nonce: saltHash.bytes,
      info: utf8.encode('woupass-session-v1'),
    );

    _sessionKey = Uint8List.fromList(await derived.extractBytes());
    _sendSeq = 0;
    _lastReceivedSeq = -1;

    // Derive nonce prefix from session key so both sides have the same one
    final prefixHash = await Sha256().hash([..._sessionKey!, ...utf8.encode('nonce-prefix')]);
    _sessionNoncePrefix = Uint8List.fromList(prefixHash.bytes.sublist(0, 4));
  }

  /// Create HMAC-SHA256 for pairing verification
  Future<String> createVerification(String label) async {
    if (_sessionKey == null) throw StateError('Session key not derived');
    final hmac = Hmac(Sha256());
    final mac = await hmac.calculateMac(
      utf8.encode(label),
      secretKey: SecretKey(_sessionKey!),
    );
    return base64Encode(mac.bytes);
  }

  /// Verify HMAC from remote side
  Future<bool> verifyHmac(String label, String receivedHmac) async {
    final expected = await createVerification(label);
    return expected == receivedHmac;
  }

  /// Encrypt a message string with AES-256-GCM using session key
  Future<String> encryptMessage(String plaintext) async {
    if (_sessionKey == null || _sessionNoncePrefix == null) {
      throw StateError('Session not established');
    }

    final seq = _sendSeq++;
    // nonce = seq (8 bytes BE) + session prefix (4 bytes) = 12 bytes
    final nonce = Uint8List(12);
    ByteData.sublistView(nonce).setInt64(0, seq, Endian.big);
    nonce.setRange(8, 12, _sessionNoncePrefix!);

    final secretBox = await _aesGcm.encrypt(
      utf8.encode(plaintext),
      secretKey: SecretKey(_sessionKey!),
      nonce: nonce,
    );

    // Encode as: seq (8 bytes) + ciphertext + mac (16 bytes)
    final result = <int>[
      ...nonce.sublist(0, 8), // seq bytes
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ];
    return base64Encode(Uint8List.fromList(result));
  }

  /// Decrypt a message string
  Future<String?> decryptMessage(String encrypted) async {
    if (_sessionKey == null || _sessionNoncePrefix == null) {
      return null;
    }

    final data = base64Decode(encrypted);
    if (data.length < 24) return null; // 8 seq + 16 mac minimum

    final seqBytes = data.sublist(0, 8);
    final seq = ByteData.sublistView(Uint8List.fromList(seqBytes))
        .getInt64(0, Endian.big);

    // Replay protection
    if (seq <= _lastReceivedSeq) return null;
    _lastReceivedSeq = seq;

    // Reconstruct nonce
    final nonce = Uint8List(12);
    nonce.setRange(0, 8, seqBytes);
    nonce.setRange(8, 12, _sessionNoncePrefix!);

    final ciphertext = data.sublist(8, data.length - 16);
    final mac = Mac(data.sublist(data.length - 16));

    try {
      final decrypted = await _aesGcm.decrypt(
        SecretBox(ciphertext, nonce: nonce, mac: mac),
        secretKey: SecretKey(_sessionKey!),
      );
      return utf8.decode(decrypted);
    } catch (_) {
      return null;
    }
  }

  /// Set a pre-shared key derived from a pairing secret.
  /// Used to encrypt the ECDH key exchange during reconnect.
  Future<void> setPreSharedKey(String secret) async {
    final hash = await Sha256().hash(utf8.encode(secret));
    _sessionKey = Uint8List.fromList(hash.bytes);
    // Derive nonce prefix same way as normal session key derivation
    final prefixHash =
        await Sha256().hash([..._sessionKey!, ...utf8.encode('nonce-prefix')]);
    _sessionNoncePrefix = Uint8List.fromList(prefixHash.bytes.sublist(0, 4));
    _sendSeq = 0;
    _lastReceivedSeq = -1;
  }

  bool get isEstablished => _sessionKey != null;

  void dispose() {
    _sessionKey = null;
    _keyPair = null;
    _sessionNoncePrefix = null;
  }
}
