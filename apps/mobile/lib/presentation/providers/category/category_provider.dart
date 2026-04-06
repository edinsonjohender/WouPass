import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woupassv2/data/repositories/category_repository_impl.dart';
import 'package:woupassv2/domain/entities/category.dart';
import 'package:woupassv2/domain/repositories/category_repository.dart';
import 'package:woupassv2/presentation/providers/core/database_provider.dart';

part 'category_provider.g.dart';

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  return CategoryRepositoryImpl(ref.watch(appDatabaseProvider));
}

@riverpod
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  Future<List<Category>> build() async {
    final repo = ref.read(categoryRepositoryProvider);
    final result = await repo.getAllCategories();
    return result.getOrElse((_) => []);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repo = ref.read(categoryRepositoryProvider);
    final result = await repo.getAllCategories();
    state = AsyncValue.data(result.getOrElse((_) => []));
  }

  Future<bool> addCategory(Category category) async {
    final repo = ref.read(categoryRepositoryProvider);
    final result = await repo.createCategory(category);
    return result.fold((_) => false, (_) { refresh(); return true; });
  }

  Future<bool> updateCategory(Category category) async {
    final repo = ref.read(categoryRepositoryProvider);
    final result = await repo.updateCategory(category);
    return result.fold((_) => false, (_) { refresh(); return true; });
  }

  Future<bool> deleteCategory(int id) async {
    final repo = ref.read(categoryRepositoryProvider);
    final result = await repo.deleteCategory(id);
    return result.fold((_) => false, (_) { refresh(); return true; });
  }
}
