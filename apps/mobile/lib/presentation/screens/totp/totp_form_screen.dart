import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:woupassv2/domain/entities/totp_entry.dart';
import 'package:woupassv2/presentation/providers/totp/totp_provider.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class TotpFormScreen extends ConsumerStatefulWidget {
  const TotpFormScreen({super.key});

  @override
  ConsumerState<TotpFormScreen> createState() => _TotpFormScreenState();
}

class _TotpFormScreenState extends ConsumerState<TotpFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _issuerController = TextEditingController();
  final _accountController = TextEditingController();
  final _secretController = TextEditingController();
  int _digits = 6;
  int _period = 30;
  String _algorithm = 'SHA1';
  bool _isLoading = false;

  @override
  void dispose() {
    _issuerController.dispose();
    _accountController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final entry = TotpEntry(
      issuer: _issuerController.text.trim(),
      accountName: _accountController.text.trim(),
      secret: _secretController.text.trim().replaceAll(' ', '').toUpperCase(),
      digits: _digits,
      period: _period,
      algorithm: _algorithm,
      createdAt: DateTime.now(),
    );

    final success = await ref.read(totpEntriesNotifierProvider.notifier).addEntry(entry);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add 2FA')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _issuerController,
                decoration: const InputDecoration(
                  hintText: 'Service name (e.g. Google)',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _accountController,
                decoration: const InputDecoration(
                  hintText: 'Account (e.g. user@email.com)',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _secretController,
                decoration: const InputDecoration(
                  hintText: 'Base32 secret key',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final clean = v.trim().replaceAll(' ', '').toUpperCase();
                  if (!RegExp(r'^[A-Z2-7]+=*$').hasMatch(clean)) {
                    return 'Invalid Base32 format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _digits,
                      decoration: const InputDecoration(labelText: 'Digits'),
                      items: [6, 8].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(),
                      onChanged: (v) => setState(() => _digits = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _period,
                      decoration: const InputDecoration(labelText: 'Period (s)'),
                      items: [30, 60, 90].map((p) => DropdownMenuItem(value: p, child: Text('$p'))).toList(),
                      onChanged: (v) => setState(() => _period = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _algorithm,
                decoration: const InputDecoration(labelText: 'Algorithm'),
                items: ['SHA1', 'SHA256', 'SHA512'].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                onChanged: (v) => setState(() => _algorithm = v!),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _save,
                  icon: _isLoading
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background))
                      : const Icon(Iconsax.tick_circle, size: 18),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
