class CryptoException implements Exception {
  final String message;
  const CryptoException(this.message);

  @override
  String toString() => 'CryptoException: $message';
}

class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}
