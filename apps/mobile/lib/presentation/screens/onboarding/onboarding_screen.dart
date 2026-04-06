import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:woupassv2/presentation/screens/auth/setup_master_password_screen.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      icon: Iconsax.shield_tick,
      title: 'Your Passwords,\nYour Rules',
      description:
          'Zero-knowledge encryption. Nobody can see your data, not even us.',
    ),
    _OnboardingPage(
      icon: Iconsax.key,
      title: 'Military-Grade\nSecurity',
      description:
          'AES-256-GCM encryption with Argon2id key derivation. The same standards used by governments.',
    ),
    _OnboardingPage(
      icon: Iconsax.cloud_cross,
      title: 'No Cloud.\nNo Tracking.',
      description:
          'Everything stays on your device. Sync between devices using encrypted QR codes.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_pages[i].icon,
                            size: 56, color: AppColors.primary),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        _pages[i].title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _pages[i].description,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.primary
                              : AppColors.textMuted,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _currentPage == _pages.length - 1
                        ? ElevatedButton(
                            onPressed: () =>
                                Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const SetupMasterPasswordScreen()),
                            ),
                            child: const Text('Get Started',
                                style: TextStyle(fontSize: 16)),
                          )
                        : OutlinedButton(
                            onPressed: () => _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                            child: const Text('Next',
                                style: TextStyle(fontSize: 16)),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}
