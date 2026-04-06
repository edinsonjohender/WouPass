import 'dart:typed_data';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthFirstTime extends AuthState {
  const AuthFirstTime();
}

final class AuthLocked extends AuthState {
  const AuthLocked();
}

final class AuthUnlocked extends AuthState {
  final Uint8List derivedKey;
  const AuthUnlocked(this.derivedKey);
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
