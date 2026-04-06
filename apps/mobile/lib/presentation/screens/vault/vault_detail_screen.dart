import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:woupassv2/core/utils/clipboard_manager.dart';
import 'package:woupassv2/data/datasources/local/database/app_database.dart' hide VaultEntry;
import 'package:woupassv2/domain/entities/vault_entry.dart';
import 'package:woupassv2/presentation/providers/desktop_sync/desktop_sync_provider.dart';
import 'package:woupassv2/presentation/providers/vault/vault_provider.dart';
import 'package:woupassv2/presentation/screens/vault/vault_form_screen.dart';
import 'package:woupassv2/presentation/screens/transfer/qr_display_screen.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class VaultDetailScreen extends ConsumerStatefulWidget {
  final VaultEntry entry;

  const VaultDetailScreen({super.key, required this.entry});

  @override
  ConsumerState<VaultDetailScreen> createState() => _VaultDetailScreenState();
}

class _VaultDetailScreenState extends ConsumerState<VaultDetailScreen> {
  final _clipboard = ClipboardManager();
  bool _showPassword = false;
  late VaultEntry _entry;

  @override
  void initState() {
    super.initState();
    _entry = widget.entry;
  }

  @override
  void dispose() {
    _clipboard.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    _clipboard.copyAndClear(text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied (clears in 30s)'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Password'),
        content: Text('Delete "${_entry.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final success = await ref.read(vaultEntriesNotifierProvider.notifier).deleteEntry(_entry.id!);
    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _showSendToSheet() {
    final syncState = ref.read(desktopSyncNotifierProvider);
    final devices = syncState.devices;

    if (devices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No paired devices. Go to Settings > Devices to pair one.'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Send to...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            ...devices.map((device) => _buildDeviceTile(ctx, device)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceTile(BuildContext sheetContext, PairedDevice device) {
    return ListTile(
      leading: const Icon(Iconsax.monitor, color: AppColors.primary),
      title: Text(device.deviceName),
      subtitle: Text(
        '${device.ip}:${device.port}',
        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        Navigator.of(sheetContext).pop();
        await _sendToDevice(device);
      },
    );
  }

  Future<void> _sendToDevice(PairedDevice device) async {
    // Show loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary),
            ),
            const SizedBox(width: 12),
            Text('Sending to ${device.deviceName}...'),
          ],
        ),
        duration: const Duration(seconds: 10),
      ),
    );

    final success = await ref.read(desktopSyncNotifierProvider.notifier).sendCredential(
      deviceId: device.deviceId,
      title: _entry.title,
      username: _entry.username,
      password: _entry.password,
      uri: _entry.uri,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Sent to ${device.deviceName}'
              : 'Failed to send to ${device.deviceName}',
        ),
        backgroundColor: success ? AppColors.success : AppColors.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_entry.title),
        actions: [
          IconButton(
            icon: Icon(
              _entry.favorite ? Iconsax.star_1 : Iconsax.star,
              color: _entry.favorite ? AppColors.warning : null,
            ),
            tooltip: _entry.favorite ? 'Remove from favorites' : 'Add to favorites',
            onPressed: () async {
              final updated = _entry.copyWith(
                favorite: !_entry.favorite,
                updatedAt: DateTime.now(),
              );
              final success = await ref
                  .read(vaultEntriesNotifierProvider.notifier)
                  .updateEntry(updated);
              if (success && mounted) {
                setState(() => _entry = updated);
              }
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.scan_barcode),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => QrDisplayScreen(entry: _entry)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.send_2),
            tooltip: 'Send to desktop',
            onPressed: _showSendToSheet,
          ),
          IconButton(
            icon: const Icon(Iconsax.edit_2),
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(builder: (_) => VaultFormScreen(entry: _entry)),
              );
              if (result == true) {
                Navigator.of(context).pop(true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.trash),
            onPressed: _delete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_entry.username.isNotEmpty)
            _buildField(
              icon: Iconsax.user,
              label: 'Username',
              value: _entry.username,
              onCopy: () => _copyToClipboard(_entry.username, 'Username'),
            ),
          _buildPasswordField(),
          if (_entry.uri.isNotEmpty)
            _buildField(
              icon: Iconsax.global,
              label: 'Website',
              value: _entry.uri,
              onCopy: () => _copyToClipboard(_entry.uri, 'URL'),
            ),
          if (_entry.notes.isNotEmpty)
            _buildField(
              icon: Iconsax.note_text,
              label: 'Notes',
              value: _entry.notes,
            ),
          const SizedBox(height: 16),
          Text(
            'Created: ${_entry.createdAt.toLocal().toString().substring(0, 16)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            'Updated: ${_entry.updatedAt.toLocal().toString().substring(0, 16)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onCopy,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          subtitle: Text(value, style: const TextStyle(fontSize: 15)),
          trailing: onCopy != null
              ? IconButton(icon: const Icon(Iconsax.copy, size: 20), onPressed: onCopy)
              : null,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: Icon(Iconsax.lock, color: AppColors.primary),
          title: const Text('Password', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          subtitle: Text(
            _showPassword ? _entry.password : '\u2022' * _entry.password.length.clamp(8, 20),
            style: TextStyle(
              fontSize: 15,
              fontFamily: _showPassword ? null : null,
              letterSpacing: _showPassword ? 0 : 2,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(_showPassword ? Iconsax.eye_slash : Iconsax.eye, size: 20),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
              IconButton(
                icon: const Icon(Iconsax.copy, size: 20),
                onPressed: () => _copyToClipboard(_entry.password, 'Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
