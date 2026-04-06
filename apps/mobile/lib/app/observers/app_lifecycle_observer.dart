import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woupassv2/presentation/providers/auth/auth_provider.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final WidgetRef ref;
  DateTime? _pausedAt;

  AppLifecycleObserver(this.ref);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _pausedAt = DateTime.now();
      case AppLifecycleState.resumed:
        if (_pausedAt != null) {
          final elapsed = DateTime.now().difference(_pausedAt!).inSeconds;
          // Auto-lock after 60 seconds in background (configurable in Phase 7)
          if (elapsed >= 60) {
            ref.read(authNotifierProvider.notifier).lock();
          }
          _pausedAt = null;
        }
      default:
        break;
    }
  }
}
