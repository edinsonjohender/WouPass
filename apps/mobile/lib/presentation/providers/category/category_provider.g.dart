// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryRepositoryHash() =>
    r'bb1993e822ae5c44773241b68bf5118ca74185c8';

/// See also [categoryRepository].
@ProviderFor(categoryRepository)
final categoryRepositoryProvider = Provider<CategoryRepository>.internal(
  categoryRepository,
  name: r'categoryRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryRepositoryRef = ProviderRef<CategoryRepository>;
String _$categoriesNotifierHash() =>
    r'ded7e7b28318457cf8d200c0c7aac82364000ee1';

/// See also [CategoriesNotifier].
@ProviderFor(CategoriesNotifier)
final categoriesNotifierProvider = AutoDisposeAsyncNotifierProvider<
  CategoriesNotifier,
  List<Category>
>.internal(
  CategoriesNotifier.new,
  name: r'categoriesNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoriesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CategoriesNotifier = AutoDisposeAsyncNotifier<List<Category>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
