import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:woupassv2/l10n/app_localizations.dart';
import 'package:woupassv2/presentation/theme/app_theme.dart';
import 'package:woupassv2/presentation/screens/splash/splash_screen.dart';

class WouPassApp extends StatelessWidget {
  const WouPassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WouPass',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
      home: const SplashScreen(),
    );
  }
}
