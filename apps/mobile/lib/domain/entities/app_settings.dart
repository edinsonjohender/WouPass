class AppSettings {
  final int autoLockSeconds;
  final int clipboardClearSeconds;
  final String themeMode;
  final String locale;
  final bool biometricsEnabled;
  final int passwordGeneratorLength;

  const AppSettings({
    this.autoLockSeconds = 60,
    this.clipboardClearSeconds = 30,
    this.themeMode = 'system',
    this.locale = 'en',
    this.biometricsEnabled = false,
    this.passwordGeneratorLength = 20,
  });
}
