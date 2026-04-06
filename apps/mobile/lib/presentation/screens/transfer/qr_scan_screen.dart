import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:woupassv2/core/utils/vault_file_handler.dart';
import 'package:woupassv2/domain/entities/vault_entry.dart';
import 'package:woupassv2/presentation/providers/core/crypto_provider.dart';
import 'package:woupassv2/presentation/providers/vault/vault_provider.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class QrScanScreen extends ConsumerStatefulWidget {
  const QrScanScreen({super.key});

  @override
  ConsumerState<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends ConsumerState<QrScanScreen> {
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

    setState(() => _scanned = true);
    _controller.stop();
    _showPasswordDialog(barcode!.rawValue!);
  }

  void _showPasswordDialog(String qrData) {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Password'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Temporary password',
            prefixIcon: Icon(Iconsax.lock),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _scanned = false);
              _controller.start();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _importFromQr(qrData, passwordController.text);
            },
            child: const Text('Decrypt'),
          ),
        ],
      ),
    );
  }

  Future<void> _importFromQr(String qrData, String password) async {
    try {
      final handler = VaultFileHandler(ref.read(cryptoServiceProvider));
      final data = await handler.importVault(
        fileContent: qrData,
        importPassword: password,
      );

      if (data == null) {
        _showResult('Wrong password or invalid QR code', false);
        return;
      }

      if (data['type'] == 'woupass_entry') {
        final now = DateTime.now();
        await ref.read(vaultEntriesNotifierProvider.notifier).addEntry(VaultEntry(
          title: data['title'] ?? '',
          username: data['username'] ?? '',
          password: data['password'] ?? '',
          uri: data['uri'] ?? '',
          notes: data['notes'] ?? '',
          lastPasswordChange: now,
          createdAt: now,
          updatedAt: now,
        ));
        _showResult('Password imported successfully!', true);
      } else {
        _showResult('Unknown QR format', false);
      }
    } catch (e) {
      _showResult('Import failed: $e', false);
    }
  }

  void _showResult(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? AppColors.success : AppColors.error,
      ),
    );
    if (success) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _scanned = false);
      _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
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
              'Point camera at a WouPass QR code',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
