sealed class Failure {
  final String message;
  final StackTrace? stackTrace;
  const Failure(this.message, [this.stackTrace]);

  @override
  String toString() => '$runtimeType: $message';
}

final class CryptoFailure extends Failure {
  const CryptoFailure(super.message, [super.stackTrace]);
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.stackTrace]);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.stackTrace]);
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message, [super.stackTrace]);
}
