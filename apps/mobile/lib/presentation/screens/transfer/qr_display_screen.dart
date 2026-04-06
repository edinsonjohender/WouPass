import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:woupassv2/core/utils/vault_file_handler.dart';
import 'package:woupassv2/domain/entities/vault_entry.dart';
import 'package:woupassv2/presentation/providers/core/crypto_provider.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class QrDisplayScreen extends ConsumerStatefulWidget {
  final VaultEntry entry;

  const QrDisplayScreen({super.key, required this.entry});

  @override
  ConsumerState<QrDisplayScreen> createState() => _QrDisplayScreenState();
}

class _QrDisplayScreenState extends ConsumerState<QrDisplayScreen> {
  final _passwordController = TextEditingController();
  String? _qrData;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_passwordController.text.length < 4) return;

    setState(() => _isLoading = true);

    final handler = VaultFileHandler(ref.read(cryptoServiceProvider));
    final data = {
      'type': 'woupass_entry',
      'title': widget.entry.title,
      'username': widget.entry.username,
      'password': widget.entry.password,
      'uri': widget.entry.uri,
      'notes': widget.entry.notes,
    };

    final encrypted = await handler.exportVault(
      vaultData: data,
      exportPassword: _passwordController.text,
    );

    setState(() {
      _isLoading = false;
      _qrData = encrypted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share via QR')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_qrData == null) ...[
              Text(
                'Share "${widget.entry.title}"',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Set a temporary password. The receiver will need it to scan.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Temporary Password',
                  prefixIcon: Icon(Iconsax.lock),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _generate,
                child: _isLoading
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background))
                    : const Text('Generate QR'),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      QrImageView(
                        data: _qrData!,
                        version: QrVersions.auto,
                        size: 250,
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Scan this with WouPass on another device',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => setState(() => _qrData = null),
                child: const Text('Generate New'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
