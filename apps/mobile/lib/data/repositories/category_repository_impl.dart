import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:woupassv2/core/errors/failures.dart';
import 'package:woupassv2/data/datasources/local/database/app_database.dart' as db;
import 'package:woupassv2/domain/entities/category.dart' as domain;
import 'package:woupassv2/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final db.AppDatabase _db;

  CategoryRepositoryImpl(this._db);

  @override
  Future<Either<Failure, List<domain.Category>>> getAllCategories() async {
    try {
      final rows = await _db.getAllCategories();
      return Right(rows.map(_toEntity).toList());
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to get categories: $e', st));
    }
  }

  @override
  Future<Either<Failure, int>> createCategory(domain.Category category) async {
    try {
      final id = await _db.insertCategory(db.CategoriesCompanion.insert(
        name: category.name,
        icon: Value(category.icon),
        colorHex: Value(category.colorHex),
        isDefault: const Value(false),
        sortOrder: Value(category.sortOrder),
        createdAt: DateTime.now(),
      ));
      return Right(id);
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to create category: $e', st));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(domain.Category category) async {
    try {
      if (category.id == null) return const Left(DatabaseFailure('Category has no id'));
      await _db.updateCategory(db.CategoriesCompanion(
        id: Value(category.id!),
        name: Value(category.name),
        icon: Value(category.icon),
        colorHex: Value(category.colorHex),
        isDefault: Value(category.isDefault),
        sortOrder: Value(category.sortOrder),
        createdAt: Value(category.createdAt),
      ));
      return const Right(null);
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to update category: $e', st));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await _db.deleteCategory(id);
      return const Right(null);
    } catch (e, st) {
      return Left(DatabaseFailure('Failed to delete category: $e', st));
    }
  }

  domain.Category _toEntity(db.Category row) {
    return domain.Category(
      id: row.id,
      name: row.name,
      icon: row.icon,
      colorHex: row.colorHex,
      isDefault: row.isDefault,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
    );
  }
}
