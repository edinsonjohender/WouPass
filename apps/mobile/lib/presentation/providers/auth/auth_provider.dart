import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:woupassv2/data/repositories/auth_repository_impl.dart';
import 'package:woupassv2/domain/entities/auth_state.dart';
import 'package:woupassv2/domain/repositories/auth_repository.dart';
import 'package:woupassv2/presentation/providers/core/crypto_provider.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    ref.watch(cryptoServiceProvider),
    ref.watch(secureKeyStorageProvider),
  );
}

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _checkInitialState();
    return const AuthInitial();
  }

  Future<void> _checkInitialState() async {
    final repo = ref.read(authRepositoryProvider);
    final isInitialized = await repo.isVaultInitialized();

    if (!isInitialized) {
      state = const AuthFirstTime();
    } else {
      final hasCached = await repo.hasCachedKey();
      if (hasCached) {
        final keyStorage = ref.read(secureKeyStorageProvider);
        final key = await keyStorage.getDerivedKey();
        if (key != null) {
          state = AuthUnlocked(key);
        } else {
          state = const AuthLocked();
        }
      } else {
        state = const AuthLocked();
      }
    }
  }

  Future<void> setupMasterPassword(String masterPassword) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.setupMasterPassword(masterPassword);

    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      state = AuthError(failure.message);
      return;
    }

    final keyStorage = ref.read(secureKeyStorageProvider);
    final key = await keyStorage.getDerivedKey();
    if (key != null) {
      state = AuthUnlocked(key);
    }
  }

  Future<void> unlock(String masterPassword) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.verifyMasterPassword(masterPassword);

    result.fold(
      (failure) => state = AuthError(failure.message),
      (key) => state = AuthUnlocked(key),
    );
  }

  Future<void> lock() async {
    // Clear clipboard on lock
    Clipboard.setData(const ClipboardData(text: ''));
    final repo = ref.read(authRepositoryProvider);
    await repo.lock();
    state = const AuthLocked();
  }

  Future<void> unlockWithBiometrics() async {
    final keyStorage = ref.read(secureKeyStorageProvider);
    final key = await keyStorage.getDerivedKey();
    if (key != null) {
      state = AuthUnlocked(key);
    } else {
      state = const AuthError('No cached key. Enter master password.');
    }
  }
}
