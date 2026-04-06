import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:woupassv2/domain/entities/auth_state.dart';
import 'package:woupassv2/presentation/providers/auth/auth_provider.dart';
import 'package:woupassv2/presentation/screens/auth/login_screen.dart';
import 'package:woupassv2/presentation/screens/home/home_screen.dart';
import 'package:woupassv2/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Small delay for splash visibility
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // Listen for auth state changes
    ref.listenManual(authNotifierProvider, (prev, next) {
      if (!mounted) return;
      _handleAuthState(next);
    }, fireImmediately: true);
  }

  void _handleAuthState(AuthState state) {
    Widget screen;

    switch (state) {
      case AuthFirstTime():
        screen = const OnboardingScreen();
      case AuthLocked():
        screen = const LoginScreen();
      case AuthUnlocked():
        screen = const HomeScreen();
      case AuthError():
        screen = const LoginScreen();
      case AuthInitial():
        return; // Still loading, wait
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.lock, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              'WouPass',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Zero-knowledge password manager',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
