import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF141414),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.primary, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.error, width: 1),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: TextStyle(color: AppColors.textMuted),
      labelStyle: TextStyle(color: AppColors.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: AppColors.border),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),
    dividerTheme: DividerThemeData(color: AppColors.border, thickness: 1),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primary.withValues(alpha: 0.15),
      elevation: 0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceLight,
      side: BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected) ? AppColors.primary : AppColors.textMuted,
      ),
      trackColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected) ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.border,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withValues(alpha: 0.12),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.background,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      contentTextStyle: TextStyle(color: AppColors.textPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    iconTheme: IconThemeData(
      color: AppColors.textSecondary,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: AppColors.textSecondary,
    ),
  );
}
