import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:woupassv2/core/utils/vault_file_handler.dart';
import 'package:woupassv2/domain/entities/vault_entry.dart';
import 'package:woupassv2/domain/entities/totp_entry.dart';
import 'package:woupassv2/presentation/providers/core/crypto_provider.dart';
import 'package:woupassv2/presentation/providers/vault/vault_provider.dart';
import 'package:woupassv2/presentation/providers/totp/totp_provider.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  List<FileSystemEntity>? _vaultFiles;
  String? _selectedFile;
  String? _result;

  @override
  void initState() {
    super.initState();
    _loadVaultFiles();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadVaultFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = dir.listSync().where((f) => f.path.endsWith('.vault')).toList();
    files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    setState(() => _vaultFiles = files);
  }

  Future<void> _import() async {
    if (_selectedFile == null || _passwordController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final handler = VaultFileHandler(ref.read(cryptoServiceProvider));
      final fileContent = await File(_selectedFile!).readAsString();
      final data = await handler.importVault(
        fileContent: fileContent,
        importPassword: _passwordController.text,
      );

      if (data == null) {
        setState(() {
          _isLoading = false;
          _result = 'Wrong password or corrupted file';
        });
        return;
      }

      int imported = 0;

      // Import passwords
      final passwords = data['passwords'] as List? ?? [];
      for (final p in passwords) {
        final now = DateTime.now();
        await ref.read(vaultEntriesNotifierProvider.notifier).addEntry(VaultEntry(
          title: p['title'] ?? '',
          username: p['username'] ?? '',
          password: p['password'] ?? '',
          uri: p['uri'] ?? '',
          notes: p['notes'] ?? '',
          icon: p['icon'] ?? 'key',
          favorite: p['favorite'] ?? false,
          lastPasswordChange: now,
          createdAt: DateTime.tryParse(p['createdAt'] ?? '') ?? now,
          updatedAt: now,
        ));
        imported++;
      }

      // Import TOTP
      final totps = data['totp'] as List? ?? [];
      for (final t in totps) {
        await ref.read(totpEntriesNotifierProvider.notifier).addEntry(TotpEntry(
          issuer: t['issuer'] ?? '',
          accountName: t['accountName'] ?? '',
          secret: t['secret'] ?? '',
          digits: t['digits'] ?? 6,
          period: t['period'] ?? 30,
          algorithm: t['algorithm'] ?? 'SHA1',
          createdAt: DateTime.now(),
        ));
        imported++;
      }

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _result = 'Imported $imported entries successfully!';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _result = 'Import failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Vault')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Iconsax.import_1, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text('Import from backup', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            if (_vaultFiles == null)
              const Center(child: CircularProgressIndicator())
            else if (_vaultFiles!.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('No .vault files found', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
                ),
              )
            else ...[
              Text('Select a backup file:', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...(_vaultFiles!.map((f) {
                final name = f.path.split('/').last.split('\\').last;
                final modified = f.statSync().modified;
                return RadioListTile<String>(
                  value: f.path,
                  groupValue: _selectedFile,
                  title: Text(name, style: const TextStyle(fontSize: 13)),
                  subtitle: Text('${modified.toLocal().toString().substring(0, 16)}', style: const TextStyle(fontSize: 11)),
                  onChanged: (v) => setState(() => _selectedFile = v),
                );
              })),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Export Password',
                  prefixIcon: Icon(Iconsax.lock),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: (_isLoading || _selectedFile == null) ? null : _import,
                  icon: _isLoading
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background))
                      : const Icon(Iconsax.import_1, size: 18),
                  label: const Text('Import'),
                ),
              ),
            ],
            if (_result != null) ...[
              const SizedBox(height: 16),
              Card(
                color: _result!.contains('successfully') ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_result!, textAlign: TextAlign.center),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
