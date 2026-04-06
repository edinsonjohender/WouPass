import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woupassv2/l10n/app_localizations.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:woupassv2/core/constants/app_constants.dart';
import 'package:woupassv2/domain/entities/auth_state.dart';
import 'package:woupassv2/presentation/providers/auth/auth_provider.dart';
import 'package:woupassv2/presentation/screens/home/home_screen.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class SetupMasterPasswordScreen extends ConsumerStatefulWidget {
  const SetupMasterPasswordScreen({super.key});

  @override
  ConsumerState<SetupMasterPasswordScreen> createState() =>
      _SetupMasterPasswordScreenState();
}

class _SetupMasterPasswordScreenState
    extends ConsumerState<SetupMasterPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    await ref.read(authNotifierProvider.notifier).setupMasterPassword(
          _passwordController.text,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    final authState = ref.read(authNotifierProvider);
    if (authState is AuthUnlocked) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (authState is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(authState.message),
            backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Icon(Iconsax.shield_tick, size: 64, color: AppColors.primary),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.createMasterPassword,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'This is the only password you need to remember. It encrypts all your data.',
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.masterPassword,
                    prefixIcon: const Icon(Iconsax.lock, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < AppConstants.minMasterPasswordLength) {
                      return 'At least ${AppConstants.minMasterPasswordLength} characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.confirmPassword,
                    prefixIcon: const Icon(Iconsax.lock, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Iconsax.eye_slash : Iconsax.eye,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.background),
                        )
                      : Text(AppLocalizations.of(context)!.createVault,
                          style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                Card(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Iconsax.warning_2,
                            color: AppColors.warning, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'If you forget this password, your data cannot be recovered.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
