import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:woupassv2/domain/entities/category.dart';
import 'package:woupassv2/presentation/providers/category/category_provider.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesNotifierProvider);

    return Scaffold(
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (categories) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final color = _parseColor(cat.colorHex);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(_getIcon(cat.icon), color: color, size: 20),
                  ),
                  title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: cat.isDefault
                      ? Chip(
                          label: const Text('Default', style: TextStyle(fontSize: 11)),
                          backgroundColor: AppColors.surfaceLight,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        )
                      : IconButton(
                          icon: const Icon(Iconsax.trash, size: 20),
                          onPressed: () => _confirmDelete(context, ref, cat),
                        ),
                  onTap: cat.isDefault ? null : () => _showEditDialog(context, ref, cat),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Iconsax.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Category name'),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              await ref.read(categoriesNotifierProvider.notifier).addCategory(
                Category(name: controller.text.trim(), createdAt: DateTime.now()),
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Category cat) {
    final controller = TextEditingController(text: cat.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Category name'),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              await ref.read(categoriesNotifierProvider.notifier).updateCategory(
                cat.copyWith(name: controller.text.trim()),
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Category cat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Delete "${cat.name}"?'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () async {
              await ref.read(categoriesNotifierProvider.notifier).deleteCategory(cat.id!);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('FF');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  IconData _getIcon(String name) {
    const icons = {
      'globe': Iconsax.global,
      'users': Iconsax.people,
      'credit-card': Iconsax.card,
      'mail': Iconsax.sms,
      'briefcase': Iconsax.briefcase,
      'folder': Iconsax.folder_2,
      'gamepad': Iconsax.game,
      'shopping': Iconsax.shopping_bag,
      'health': Iconsax.health,
      'education': Iconsax.teacher,
    };
    return icons[name] ?? Iconsax.folder_2;
  }
}
