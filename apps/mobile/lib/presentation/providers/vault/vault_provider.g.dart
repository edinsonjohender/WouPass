// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vaultEntryRepositoryHash() =>
    r'5cfa9f431d9178876c25c36b93580ab3838d6cad';

/// See also [vaultEntryRepository].
@ProviderFor(vaultEntryRepository)
final vaultEntryRepositoryProvider = Provider<VaultEntryRepository>.internal(
  vaultEntryRepository,
  name: r'vaultEntryRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$vaultEntryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VaultEntryRepositoryRef = ProviderRef<VaultEntryRepository>;
String _$vaultEntriesNotifierHash() =>
    r'51b2fb1cd489b88f172a9f60c40da96b04dfee62';

/// See also [VaultEntriesNotifier].
@ProviderFor(VaultEntriesNotifier)
final vaultEntriesNotifierProvider = AutoDisposeAsyncNotifierProvider<
  VaultEntriesNotifier,
  List<VaultEntry>
>.internal(
  VaultEntriesNotifier.new,
  name: r'vaultEntriesNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$vaultEntriesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VaultEntriesNotifier = AutoDisposeAsyncNotifier<List<VaultEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
