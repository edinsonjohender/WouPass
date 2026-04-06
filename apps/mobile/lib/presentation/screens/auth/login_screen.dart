import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woupassv2/l10n/app_localizations.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:woupassv2/domain/entities/auth_state.dart';
import 'package:woupassv2/presentation/providers/auth/auth_provider.dart';
import 'package:woupassv2/presentation/screens/home/home_screen.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _localAuth = LocalAuthentication();
  bool _obscure = true;
  bool _isLoading = false;
  String? _errorMessage;
  bool _biometricsAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!mounted) return;

      if (canCheck && isDeviceSupported) {
        setState(() => _biometricsAvailable = true);

        // Auto-trigger biometric auth if vault is initialized (not first time)
        final repo = ref.read(authRepositoryProvider);
        final hasCachedKey = await repo.hasCachedKey();
        if (hasCachedKey) {
          _authenticateWithBiometrics();
        }
      }
    } catch (_) {
      // Biometrics not available
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Unlock WouPass',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (!authenticated || !mounted) return;

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await ref.read(authNotifierProvider.notifier).unlockWithBiometrics();

      if (!mounted) return;
      setState(() => _isLoading = false);

      final authState = ref.read(authNotifierProvider);
      if (authState is AuthUnlocked) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (authState is AuthError) {
        setState(() => _errorMessage = authState.message);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Biometric auth failed: $e');
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await ref.read(authNotifierProvider.notifier).unlock(
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
      setState(() => _errorMessage = authState.message);
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
                const SizedBox(height: 80),
                Icon(Iconsax.lock, size: 64, color: AppColors.primary),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.enterMasterPassword,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                if (_errorMessage != null) ...[
                  Card(
                    color: AppColors.error.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Iconsax.info_circle,
                              color: AppColors.error, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                  color: AppColors.error, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscure,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.masterPassword,
                    prefixIcon: const Icon(Iconsax.lock, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Iconsax.eye_slash : Iconsax.eye,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.background),
                        )
                      : Text(AppLocalizations.of(context)!.unlock,
                          style: const TextStyle(fontSize: 16)),
                ),
                if (_biometricsAvailable) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: IconButton(
                      iconSize: 48,
                      icon: Icon(Iconsax.finger_scan,
                          color: AppColors.primary),
                      tooltip: 'Unlock with biometrics',
                      onPressed: _isLoading
                          ? null
                          : _authenticateWithBiometrics,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
