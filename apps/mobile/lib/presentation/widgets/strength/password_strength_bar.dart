import 'package:flutter/material.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class PasswordStrengthBar extends StatelessWidget {
  final String password;

  const PasswordStrengthBar({super.key, required this.password});

  double get _strength {
    if (password.isEmpty) return 0;
    double s = 0;
    if (password.length >= 8) s += 0.15;
    if (password.length >= 12) s += 0.15;
    if (password.length >= 20) s += 0.1;
    if (RegExp(r'[a-z]').hasMatch(password)) s += 0.15;
    if (RegExp(r'[A-Z]').hasMatch(password)) s += 0.15;
    if (RegExp(r'[0-9]').hasMatch(password)) s += 0.15;
    if (RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]').hasMatch(password)) {
      s += 0.15;
    }
    return s.clamp(0.0, 1.0);
  }

  Color get _color {
    if (_strength < 0.3) return AppColors.strengthWeak;
    if (_strength < 0.5) return AppColors.strengthFair;
    if (_strength < 0.75) return AppColors.strengthGood;
    return AppColors.strengthStrong;
  }

  String get _label {
    if (password.isEmpty) return '';
    if (_strength < 0.3) return 'Weak';
    if (_strength < 0.5) return 'Fair';
    if (_strength < 0.75) return 'Good';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _strength,
            color: _color,
            backgroundColor: AppColors.border,
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _label,
          style: TextStyle(
              color: _color, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
