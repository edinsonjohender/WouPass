import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woupassv2/core/utils/vault_file_handler.dart';
import 'package:woupassv2/presentation/providers/core/crypto_provider.dart';
import 'package:woupassv2/presentation/providers/vault/vault_provider.dart';
import 'package:woupassv2/presentation/providers/totp/totp_provider.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  String? _exportPath;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _export() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final handler = VaultFileHandler(ref.read(cryptoServiceProvider));

      // Gather all vault data
      final vaultEntries = ref.read(vaultEntriesNotifierProvider).valueOrNull ?? [];
      final totpEntries = ref.read(totpEntriesNotifierProvider).valueOrNull ?? [];

      final vaultData = {
        'passwords': vaultEntries.map((e) => {
          'title': e.title,
          'username': e.username,
          'password': e.password,
          'uri': e.uri,
          'notes': e.notes,
          'icon': e.icon,
          'favorite': e.favorite,
          'createdAt': e.createdAt.toIso8601String(),
        }).toList(),
        'totp': totpEntries.map((e) => {
          'issuer': e.issuer,
          'accountName': e.accountName,
          'secret': e.secret,
          'digits': e.digits,
          'period': e.period,
          'algorithm': e.algorithm,
        }).toList(),
        'exportedAt': DateTime.now().toIso8601String(),
      };

      final encrypted = await handler.exportVault(
        vaultData: vaultData,
        exportPassword: _passwordController.text,
      );

      // Save to file
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/woupass_backup_$timestamp.vault');
      await file.writeAsString(encrypted);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _exportPath = file.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vault exported successfully!'), backgroundColor: AppColors.success),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Vault')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Iconsax.export_1, size: 64, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Create an encrypted backup',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Set a password to protect the export file. You will need this password to import on another device.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Export Password',
                  prefixIcon: Icon(Iconsax.lock),
                ),
                validator: (v) => (v == null || v.length < 6) ? 'At least 6 characters' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                  prefixIcon: Icon(Iconsax.lock),
                ),
                validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _export,
                  icon: _isLoading
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background))
                      : const Icon(Iconsax.export_1, size: 18),
                  label: const Text('Export'),
                ),
              ),
              if (_exportPath != null) ...[
                const SizedBox(height: 16),
                Card(
                  color: AppColors.success.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Iconsax.tick_circle, color: AppColors.success),
                        const SizedBox(height: 8),
                        const Text('File saved:', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(_exportPath!, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
