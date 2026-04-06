import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woupassv2/core/networking/tcp_client.dart';
import 'package:woupassv2/data/datasources/local/database/app_database.dart';
import 'package:woupassv2/presentation/providers/core/database_provider.dart';

part 'desktop_sync_provider.g.dart';

class DesktopSyncState {
  final List<PairedDevice> devices;
  final bool isSending;
  final bool isPairing;
  final String? lastSentTo;
  final String? error;

  const DesktopSyncState({
    this.devices = const [],
    this.isSending = false,
    this.isPairing = false,
    this.lastSentTo,
    this.error,
  });

  DesktopSyncState copyWith({
    List<PairedDevice>? devices,
    bool? isSending,
    bool? isPairing,
    String? lastSentTo,
    String? error,
    bool clearLastSentTo = false,
    bool clearError = false,
  }) {
    return DesktopSyncState(
      devices: devices ?? this.devices,
      isSending: isSending ?? this.isSending,
      isPairing: isPairing ?? this.isPairing,
      lastSentTo: clearLastSentTo ? null : (lastSentTo ?? this.lastSentTo),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

@Riverpod(keepAlive: true)
class DesktopSyncNotifier extends _$DesktopSyncNotifier {
  @override
  DesktopSyncState build() {
    _loadDevices();
    return const DesktopSyncState();
  }

  AppDatabase get _db => ref.read(appDatabaseProvider);

  Future<void> _loadDevices() async {
    final devices = await _db.getAllPairedDevices();
    state = state.copyWith(devices: devices);
  }

  Future<void> loadDevices() => _loadDevices();

  /// Parse QR JSON, pair with desktop, save to DB.
  /// Expected QR JSON: {"ip": "...", "port": 9847, "desktop_id": "...", "desktop_name": "..."}
  Future<bool> pairNewDevice(String qrData) async {
    state = state.copyWith(isPairing: true, clearError: true);

    try {
      final data = jsonDecode(qrData) as Map<String, dynamic>;
      final ip = data['ip'] as String;
      final port = (data['port'] as num?)?.toInt() ?? 9847;
      final desktopId = data['desktop_id'] as String? ?? '';
      final desktopName = data['desktop_name'] as String? ?? 'Desktop';

      final result = await CredentialSender.pairWithDesktop(
        ip: ip,
        port: port,
        desktopId: desktopId,
        desktopName: desktopName,
      );

      if (result == null) {
        state = state.copyWith(isPairing: false, error: 'Pairing failed');
        return false;
      }

      // Check if device already exists
      final existing = await _db.getPairedDeviceByDeviceId(result.deviceId);
      if (existing != null) {
        // Remove old entry first
        await _db.deletePairedDevice(existing.id);
      }

      // Save to DB (including pairing secret for PSK-encrypted reconnect)
      final now = DateTime.now();
      await _db.insertPairedDevice(PairedDevicesCompanion.insert(
        deviceId: result.deviceId,
        deviceName: result.deviceName,
        ip: Value(result.ip),
        port: Value(result.port),
        pairingSecret: Value(result.pairingSecret),
        pairedAt: now,
        lastSeen: now,
      ));

      await _loadDevices();
      state = state.copyWith(isPairing: false);
      return true;
    } catch (e) {
      state = state.copyWith(isPairing: false, error: 'Pairing failed: $e');
      return false;
    }
  }

  /// Send a credential to a previously paired desktop. Ephemeral connection.
  Future<bool> sendCredential({
    required String deviceId,
    required String title,
    required String username,
    required String password,
    required String uri,
  }) async {
    state = state.copyWith(isSending: true, clearError: true, clearLastSentTo: true);

    try {
      final device = state.devices.firstWhere(
        (d) => d.deviceId == deviceId,
      );

      final success = await CredentialSender.sendCredential(
        ip: device.ip,
        port: device.port,
        deviceId: device.deviceId,
        pairingSecret: device.pairingSecret,
        title: title,
        username: username,
        password: password,
        uri: uri,
      );

      if (success) {
        state = state.copyWith(isSending: false, lastSentTo: device.deviceName);
      } else {
        state = state.copyWith(isSending: false, error: 'Failed to send credential');
      }

      return success;
    } catch (e) {
      state = state.copyWith(isSending: false, error: 'Send failed: $e');
      return false;
    }
  }

  /// Remove a paired device from DB.
  Future<void> removeDevice(int id) async {
    await _db.deletePairedDevice(id);
    await _loadDevices();
  }
}
