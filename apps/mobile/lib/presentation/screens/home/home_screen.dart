import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';
import 'package:woupassv2/presentation/providers/auth/auth_provider.dart';
import 'package:woupassv2/presentation/screens/auth/login_screen.dart';
import 'package:woupassv2/presentation/screens/categories/categories_screen.dart';
import 'package:woupassv2/presentation/screens/generator/password_generator_screen.dart';
import 'package:woupassv2/presentation/screens/totp/totp_list_screen.dart';
import 'package:woupassv2/presentation/screens/transfer/export_screen.dart';
import 'package:woupassv2/presentation/screens/transfer/import_screen.dart';
import 'package:woupassv2/presentation/screens/transfer/qr_scan_screen.dart';
import 'package:woupassv2/presentation/screens/settings/settings_screen.dart';
import 'package:woupassv2/presentation/screens/vault/vault_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WouPass'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.magic_star),
            tooltip: 'Password Generator',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PasswordGeneratorScreen()),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Iconsax.more),
            onSelected: (value) {
              switch (value) {
                case 'export':
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ExportScreen()));
                case 'import':
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ImportScreen()));
                case 'scan':
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QrScanScreen()));
                case 'lock':
                  ref.read(authNotifierProvider.notifier).lock().then((_) {
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  });
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'export', child: ListTile(leading: Icon(Iconsax.export_1), title: Text('Export Vault'), dense: true)),
              PopupMenuItem(value: 'import', child: ListTile(leading: Icon(Iconsax.import_1), title: Text('Import Vault'), dense: true)),
              PopupMenuItem(value: 'scan', child: ListTile(leading: Icon(Iconsax.scan_barcode), title: Text('Scan QR'), dense: true)),
              PopupMenuDivider(),
              PopupMenuItem(value: 'lock', child: ListTile(leading: Icon(Iconsax.lock), title: Text('Lock'), dense: true)),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          VaultListScreen(),
          CategoriesScreen(),
          TotpListScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 22,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.key), label: ''),
          BottomNavigationBarItem(icon: Icon(Iconsax.folder_2), label: ''),
          BottomNavigationBarItem(icon: Icon(Iconsax.shield_tick), label: ''),
          BottomNavigationBarItem(icon: Icon(Iconsax.setting_2), label: ''),
        ],
      ),
    );
  }
}
