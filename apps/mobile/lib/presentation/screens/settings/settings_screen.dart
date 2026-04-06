import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:woupassv2/presentation/providers/auth/auth_provider.dart';
import 'package:woupassv2/presentation/providers/totp/totp_provider.dart';
import 'package:woupassv2/presentation/providers/vault/vault_provider.dart';
import 'package:woupassv2/presentation/screens/auth/login_screen.dart';
import 'package:woupassv2/presentation/screens/desktop_sync/desktop_sync_screen.dart';
import 'package:woupassv2/presentation/screens/transfer/export_screen.dart';
import 'package:woupassv2/presentation/screens/transfer/import_screen.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader(context, 'Security'),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Iconsax.lock),
                title: const Text('Change Master Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showChangeMasterPasswordDialog(context, ref),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Iconsax.timer_1),
                title: const Text('Auto-lock Timeout'),
                subtitle: const Text('60 seconds'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Iconsax.copy),
                title: const Text('Clipboard Auto-clear'),
                subtitle: const Text('30 seconds'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Iconsax.monitor),
                title: const Text('Devices'),
                subtitle: const Text('Manage paired desktops'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DesktopSyncScreen()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _sectionHeader(context, 'Data'),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Iconsax.export_1),
                title: const Text('Export Vault'),
                subtitle: const Text('Create encrypted backup'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ExportScreen()),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Iconsax.import_1),
                title: const Text('Import Vault'),
                subtitle: const Text('Restore from backup'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ImportScreen()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _sectionHeader(context, 'About'),
        Card(
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Iconsax.info_circle),
                title: Text('WouPass'),
                subtitle: Text('v1.0.0 — Zero-knowledge password manager'),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Iconsax.shield_tick),
                title: Text('Encryption'),
                subtitle: Text('AES-256-GCM + Argon2id'),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Iconsax.cloud_cross),
                title: Text('Privacy'),
                subtitle: Text('All data stored locally. No cloud. No tracking.'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).lock();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
            icon: const Icon(Iconsax.lock, size: 18),
            label: const Text('Lock Vault'),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showChangeMasterPasswordDialog(BuildContext context, WidgetRef ref) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Master Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Current Password'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'New Password'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Confirm New Password'),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }
              if (newController.text.length < 8) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('At least 8 characters')),
                );
                return;
              }

              Navigator.pop(ctx);

              try {
                // 1. Capture all decrypted entries before changing the key
                final vaultNotifier = ref.read(vaultEntriesNotifierProvider.notifier);
                final totpNotifier = ref.read(totpEntriesNotifierProvider.notifier);

                final currentVaultEntries = ref.read(vaultEntriesNotifierProvider).valueOrNull ?? [];
                final currentTotpEntries = ref.read(totpEntriesNotifierProvider).valueOrNull ?? [];

                // 2. Change master password (updates salt, verification hash, and derived key)
                final authRepo = ref.read(authRepositoryProvider);
                final result = await authRepo.changeMasterPassword(
                  currentController.text,
                  newController.text,
                );

                final errorMessage = result.fold(
                  (failure) => failure.message,
                  (_) => null,
                );

                if (errorMessage != null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }
                  return;
                }

                // 3. Delete and re-insert all vault entries (re-encrypted with new key)
                for (final entry in currentVaultEntries) {
                  if (entry.id != null) {
                    await ref.read(vaultEntryRepositoryProvider).deleteEntry(entry.id!);
                  }
                }
                for (final entry in currentVaultEntries) {
                  await ref.read(vaultEntryRepositoryProvider).createEntry(
                    entry.copyWith(id: null),
                  );
                }

                // 4. Delete and re-insert all TOTP entries (re-encrypted with new key)
                for (final entry in currentTotpEntries) {
                  if (entry.id != null) {
                    await ref.read(totpRepositoryProvider).deleteEntry(entry.id!);
                  }
                }
                for (final entry in currentTotpEntries) {
                  await ref.read(totpRepositoryProvider).createEntry(
                    entry.copyWith(id: null),
                  );
                }

                // 5. Refresh providers
                await vaultNotifier.refresh();
                await totpNotifier.refresh();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Master password changed successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error changing password: $e')),
                  );
                }
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}
