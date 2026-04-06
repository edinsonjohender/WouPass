// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'totp_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$totpRepositoryHash() => r'dee59801a4a8137c6dd5670b0d442b996ad6fa1c';

/// See also [totpRepository].
@ProviderFor(totpRepository)
final totpRepositoryProvider = Provider<TotpRepository>.internal(
  totpRepository,
  name: r'totpRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$totpRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotpRepositoryRef = ProviderRef<TotpRepository>;
String _$totpEntriesNotifierHash() =>
    r'3b817df19e58293911b5a354fdf16a80b50431fb';

/// See also [TotpEntriesNotifier].
@ProviderFor(TotpEntriesNotifier)
final totpEntriesNotifierProvider = AutoDisposeAsyncNotifierProvider<
  TotpEntriesNotifier,
  List<TotpEntry>
>.internal(
  TotpEntriesNotifier.new,
  name: r'totpEntriesNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$totpEntriesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TotpEntriesNotifier = AutoDisposeAsyncNotifier<List<TotpEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
