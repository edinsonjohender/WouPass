import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:woupassv2/core/utils/password_generator.dart';
import 'package:woupassv2/domain/entities/vault_entry.dart';
import 'package:woupassv2/presentation/providers/category/category_provider.dart';
import 'package:woupassv2/presentation/providers/vault/vault_provider.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';
import 'package:woupassv2/presentation/widgets/strength/password_strength_bar.dart';

class VaultFormScreen extends ConsumerStatefulWidget {
  final VaultEntry? entry;

  const VaultFormScreen({super.key, this.entry});

  bool get isEditing => entry != null;

  @override
  ConsumerState<VaultFormScreen> createState() => _VaultFormScreenState();
}

class _VaultFormScreenState extends ConsumerState<VaultFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _uriController;
  late final TextEditingController _notesController;
  int? _selectedCategoryId;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _usernameController = TextEditingController(text: widget.entry?.username ?? '');
    _passwordController = TextEditingController(text: widget.entry?.password ?? '');
    _uriController = TextEditingController(text: widget.entry?.uri ?? '');
    _notesController = TextEditingController(text: widget.entry?.notes ?? '');
    _selectedCategoryId = widget.entry?.categoryId;
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _uriController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    final password = PasswordGenerator.generate(length: 20);
    _passwordController.text = password;
    setState(() => _obscurePassword = false);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final entry = VaultEntry(
      id: widget.entry?.id,
      title: _titleController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      uri: _uriController.text.trim(),
      notes: _notesController.text.trim(),
      categoryId: _selectedCategoryId,
      icon: widget.entry?.icon ?? 'key',
      favorite: widget.entry?.favorite ?? false,
      passwordRenewalDays: widget.entry?.passwordRenewalDays ?? 0,
      lastPasswordChange: widget.entry?.lastPasswordChange ?? now,
      createdAt: widget.entry?.createdAt ?? now,
      updatedAt: now,
    );

    final notifier = ref.read(vaultEntriesNotifierProvider.notifier);
    final success = widget.isEditing
        ? await notifier.updateEntry(entry)
        : await notifier.addEntry(entry);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Password' : 'Add Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: 'Username / Email',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Iconsax.lock),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(_obscurePassword ? Iconsax.eye_slash : Iconsax.eye),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.magic_star),
                        tooltip: 'Generate password',
                        onPressed: _generatePassword,
                      ),
                    ],
                  ),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              PasswordStrengthBar(password: _passwordController.text),
              const SizedBox(height: 12),
              TextFormField(
                controller: _uriController,
                decoration: const InputDecoration(
                  hintText: 'Website / URL',
                ),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              Consumer(
                builder: (context, ref, _) {
                  final categoriesAsync = ref.watch(categoriesNotifierProvider);
                  return categoriesAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (categories) => DropdownButtonFormField<int?>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Iconsax.folder_2),
                      ),
                      items: [
                        const DropdownMenuItem<int?>(value: null, child: Text('None')),
                        ...categories.map((c) => DropdownMenuItem<int?>(
                          value: c.id,
                          child: Text(c.name),
                        )),
                      ],
                      onChanged: (v) => setState(() => _selectedCategoryId = v),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Notes',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _save,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 18, width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                        )
                      : const Icon(Iconsax.tick_circle, size: 18),
                  label: Text(widget.isEditing ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
