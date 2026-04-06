import 'package:fpdart/fpdart.dart';
import 'package:woupassv2/core/errors/failures.dart';
import 'package:woupassv2/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getAllCategories();
  Future<Either<Failure, int>> createCategory(Category category);
  Future<Either<Failure, void>> updateCategory(Category category);
  Future<Either<Failure, void>> deleteCategory(int id);
}
