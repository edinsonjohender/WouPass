import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:woupassv2/presentation/providers/category/category_provider.dart';
import 'package:woupassv2/presentation/providers/vault/vault_provider.dart';
import 'package:woupassv2/presentation/screens/vault/vault_detail_screen.dart';
import 'package:woupassv2/presentation/screens/vault/vault_form_screen.dart';
import 'package:woupassv2/presentation/theme/app_colors.dart';

class VaultListScreen extends ConsumerStatefulWidget {
  const VaultListScreen({super.key});

  @override
  ConsumerState<VaultListScreen> createState() => _VaultListScreenState();
}

class _VaultListScreenState extends ConsumerState<VaultListScreen> {
  final _searchController = TextEditingController();
  int? _selectedCategoryId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(vaultEntriesNotifierProvider);
    final categoriesAsync = ref.watch(categoriesNotifierProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search passwords...',
                prefixIcon: const Icon(Iconsax.search_normal),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Iconsax.close_circle),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(vaultEntriesNotifierProvider.notifier).refresh();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (query) {
                ref.read(vaultEntriesNotifierProvider.notifier).search(query);
                setState(() {});
              },
            ),
          ),
          // Category filter chips
          categoriesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (categories) {
              if (categories.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedCategoryId == null,
                        onSelected: (_) {
                          setState(() => _selectedCategoryId = null);
                        },
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    ...categories.map((cat) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: _selectedCategoryId == cat.id,
                        onSelected: (_) {
                          setState(() => _selectedCategoryId = cat.id);
                        },
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    )),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (entries) {
                // Apply category filter
                final filtered = _selectedCategoryId == null
                    ? entries
                    : entries.where((e) => e.categoryId == _selectedCategoryId).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.lock_slash, size: 64, color: AppColors.textMuted),
                        const SizedBox(height: 16),
                        Text(
                          'No passwords yet',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add your first password',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.read(vaultEntriesNotifierProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final entry = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                              child: Icon(Iconsax.key, color: AppColors.primary),
                            ),
                            title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: entry.username.isNotEmpty ? Text(entry.username) : null,
                            trailing: entry.favorite
                                ? Icon(Iconsax.star_1, color: AppColors.warning, size: 20)
                                : null,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => VaultDetailScreen(entry: entry),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const VaultFormScreen()),
          );
          if (result == true) {
            ref.read(vaultEntriesNotifierProvider.notifier).refresh();
          }
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }
}
