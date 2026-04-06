import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:woupassv2/core/utils/clipboard_manager.dart';
import 'package:woupassv2/core/utils/password_generator.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  final _clipboard = ClipboardManager();
  String _password = '';
  double _length = 20;
  bool _lowercase = true;
  bool _uppercase = true;
  bool _digits = true;
  bool _symbols = true;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  @override
  void dispose() {
    _clipboard.dispose();
    super.dispose();
  }

  void _generate() {
    setState(() {
      _password = PasswordGenerator.generate(
        length: _length.toInt(),
        useLowercase: _lowercase,
        useUppercase: _uppercase,
        useDigits: _digits,
        useSymbols: _symbols,
      );
    });
  }

  double get _strength {
    if (_password.isEmpty) return 0;
    double s = 0;
    if (_password.length >= 8) s += 0.2;
    if (_password.length >= 16) s += 0.2;
    if (_password.length >= 24) s += 0.1;
    if (RegExp(r'[a-z]').hasMatch(_password)) s += 0.1;
    if (RegExp(r'[A-Z]').hasMatch(_password)) s += 0.1;
    if (RegExp(r'[0-9]').hasMatch(_password)) s += 0.1;
    if (RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]').hasMatch(_password)) s += 0.2;
    return s.clamp(0.0, 1.0);
  }

  Color get _strengthColor {
    if (_strength < 0.3) return AppColors.strengthWeak;
    if (_strength < 0.6) return AppColors.strengthFair;
    if (_strength < 0.8) return AppColors.strengthGood;
    return AppColors.strengthStrong;
  }

  String get _strengthLabel {
    if (_strength < 0.3) return 'Weak';
    if (_strength < 0.6) return 'Fair';
    if (_strength < 0.8) return 'Good';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SelectableText(
                      _password,
                      style: const TextStyle(fontSize: 18, fontFamily: 'monospace', letterSpacing: 1),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: _strength,
                      color: _strengthColor,
                      backgroundColor: AppColors.border,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 4),
                    Text(_strengthLabel, style: TextStyle(color: _strengthColor, fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Iconsax.refresh, size: 18),
                    label: const Text('Generate'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _clipboard.copyAndClear(_password);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied (clears in 30s)'), duration: Duration(seconds: 2)),
                      );
                    },
                    icon: const Icon(Iconsax.copy, size: 18),
                    label: const Text('Copy'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Length: ${_length.toInt()}', style: const TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: _length,
              min: 8,
              max: 64,
              divisions: 56,
              label: _length.toInt().toString(),
              onChanged: (v) { _length = v; _generate(); },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Lowercase (a-z)', style: TextStyle(fontSize: 15)),
              value: _lowercase,
              onChanged: (v) => setState(() { _lowercase = v; _generate(); }),
            ),
            SwitchListTile(
              title: const Text('Uppercase (A-Z)', style: TextStyle(fontSize: 15)),
              value: _uppercase,
              onChanged: (v) => setState(() { _uppercase = v; _generate(); }),
            ),
            SwitchListTile(
              title: const Text('Digits (0-9)', style: TextStyle(fontSize: 15)),
              value: _digits,
              onChanged: (v) => setState(() { _digits = v; _generate(); }),
            ),
            SwitchListTile(
              title: const Text('Symbols (!@#\$...)', style: TextStyle(fontSize: 15)),
              value: _symbols,
              onChanged: (v) => setState(() { _symbols = v; _generate(); }),
            ),
          ],
        ),
      ),
    );
  }
}
