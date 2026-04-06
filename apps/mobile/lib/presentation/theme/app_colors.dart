import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const primary = Color(0xFF3ECF8E);
  static const primaryDark = Color(0xFF2EA872);

  // Backgrounds
  static const background = Color(0xFF0D0D0D);
  static const surface = Color(0xFF171717);
  static const surfaceLight = Color(0xFF1C1C1C);
  static const card = Color(0xFF1C1C1C);

  // Borders
  static const border = Color(0xFF2A2A2A);
  static const borderLight = Color(0xFF333333);

  // Text
  static const textPrimary = Color(0xFFEDEDED);
  static const textSecondary = Color(0xFFA1A1A1);
  static const textMuted = Color(0xFF666666);

  // Semantic
  static const error = Color(0xFFEF4444);
  static const success = Color(0xFF3ECF8E);
  static const warning = Color(0xFFF59E0B);

  // Strength
  static const strengthWeak = Color(0xFFEF4444);
  static const strengthFair = Color(0xFFF59E0B);
  static const strengthGood = Color(0xFF3ECF8E);
  static const strengthStrong = Color(0xFF22C55E);
}
