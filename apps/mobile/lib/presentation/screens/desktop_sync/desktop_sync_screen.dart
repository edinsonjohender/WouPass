import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:woupassv2/data/datasources/local/database/app_database.dart';
import 'package:woupassv2/presentation/providers/desktop_sync/desktop_sync_provider.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class DesktopSyncScreen extends ConsumerStatefulWidget {
  const DesktopSyncScreen({super.key});

  @override
  ConsumerState<DesktopSyncScreen> createState() => _DesktopSyncScreenState();
}

class _DesktopSyncScreenState extends ConsumerState<DesktopSyncScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(desktopSyncNotifierProvider.notifier).loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(desktopSyncNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Devices')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: syncState.isPairing ? null : _openQrScanner,
        icon: const Icon(Iconsax.scan),
        label: const Text('Pair new device'),
      ),
      body: syncState.isPairing
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Pairing with desktop...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This should only take a moment.',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (syncState.devices.isEmpty) ...[
                  _buildEmptyCard(),
                ] else ...[
                  ...syncState.devices.map((device) => _buildDeviceCard(device)),
                ],
                const SizedBox(height: 24),
                _buildInfoCard(),
                const SizedBox(height: 80), // space for FAB
              ],
            ),
    );
  }

  Widget _buildEmptyCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
        child: Column(
          children: [
            const Icon(Iconsax.monitor, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            const Text(
              'No paired devices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan the QR code shown on your desktop to pair.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(PairedDevice device) {
    return Card(
      child: ListTile(
        leading: const Icon(Iconsax.monitor, color: AppColors.primary),
        title: Text(
          device.deviceName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${device.ip}:${device.port}',
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        trailing: IconButton(
          icon: const Icon(Iconsax.trash, color: AppColors.error, size: 20),
          tooltip: 'Remove device',
          onPressed: () => _confirmRemoveDevice(device),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Iconsax.shield_tick, size: 16, color: AppColors.primary),
                SizedBox(width: 8),
                Text('How it works',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Open WouPass on your desktop and scan the QR code\n'
              '2. Your phone pairs with the desktop\n'
              '3. From any password, tap "Send to..." to push it to the desktop\n'
              '4. No passwords are stored on the desktop',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmRemoveDevice(PairedDevice device) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Device'),
        content: Text('Remove "${device.deviceName}"? You will need to re-pair to send credentials.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(desktopSyncNotifierProvider.notifier).removeDevice(device.id);
    }
  }

  Future<void> _openQrScanner() async {
    final qrData = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const _DesktopQrScanScreen()),
    );

    if (qrData == null || !mounted) return;

    final success = await ref
        .read(desktopSyncNotifierProvider.notifier)
        .pairNewDevice(qrData);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Device paired successfully!'
              : 'Failed to pair with desktop. Please try again.'),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }
}

/// Internal QR scanner screen for desktop pairing
class _DesktopQrScanScreen extends StatefulWidget {
  const _DesktopQrScanScreen();

  @override
  State<_DesktopQrScanScreen> createState() => _DesktopQrScanScreenState();
}

class _DesktopQrScanScreenState extends State<_DesktopQrScanScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    final data = barcode!.rawValue!;

    // Basic validation: must look like JSON with expected fields
    if (!data.contains('"ip"') || !data.contains('"port"')) return;

    setState(() => _scanned = true);
    _controller.stop();
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Desktop QR')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Point camera at the QR code shown on your desktop',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
