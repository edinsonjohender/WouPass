import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:otp/otp.dart';
import 'package:woupassv2/core/utils/clipboard_manager.dart';
import 'package:woupassv2/domain/entities/totp_entry.dart';
import 'package:woupassv2/presentation/providers/totp/totp_provider.dart';
import 'package:woupassv2/presentation/screens/totp/totp_form_screen.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class TotpListScreen extends ConsumerStatefulWidget {
  const TotpListScreen({super.key});

  @override
  ConsumerState<TotpListScreen> createState() => _TotpListScreenState();
}

class _TotpListScreenState extends ConsumerState<TotpListScreen> {
  final _clipboard = ClipboardManager();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _clipboard.dispose();
    super.dispose();
  }

  String _generateCode(TotpEntry entry) {
    try {
      final algorithm = switch (entry.algorithm.toUpperCase()) {
        'SHA256' => Algorithm.SHA256,
        'SHA512' => Algorithm.SHA512,
        _ => Algorithm.SHA1,
      };
      final code = OTP.generateTOTPCodeString(
        entry.secret,
        DateTime.now().millisecondsSinceEpoch,
        length: entry.digits,
        interval: entry.period,
        algorithm: algorithm,
        isGoogle: true,
      );
      return code;
    } catch (_) {
      return '------';
    }
  }

  int _secondsRemaining(int period) {
    return period - (DateTime.now().second % period);
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(totpEntriesNotifierProvider);

    return Scaffold(
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.shield_tick, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Text('No 2FA entries yet', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text('Tap + to add a TOTP authenticator', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final code = _generateCode(entry);
              final remaining = _secondsRemaining(entry.period);
              final progress = remaining / entry.period;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _clipboard.copyAndClear(code);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code copied (clears in 30s)'), duration: Duration(seconds: 2)),
                      );
                    },
                    onLongPress: () => _confirmDelete(context, entry),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 3,
                                  color: remaining <= 5 ? AppColors.error : AppColors.primary,
                                  backgroundColor: AppColors.border,
                                ),
                                Center(
                                  child: Text(
                                    '$remaining',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: remaining <= 5 ? AppColors.error : AppColors.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(entry.issuer, style: const TextStyle(fontWeight: FontWeight.w600)),
                                if (entry.accountName.isNotEmpty)
                                  Text(entry.accountName, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          Text(
                            '${code.substring(0, code.length ~/ 2)} ${code.substring(code.length ~/ 2)}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'monospace', letterSpacing: 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const TotpFormScreen()),
          );
          if (result == true) {
            ref.read(totpEntriesNotifierProvider.notifier).refresh();
          }
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TotpEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete 2FA Entry'),
        content: Text('Delete "${entry.issuer}"? This cannot be undone.'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () async {
              await ref.read(totpEntriesNotifierProvider.notifier).deleteEntry(entry.id!);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
