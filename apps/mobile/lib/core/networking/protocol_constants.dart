abstract final class ProtocolConstants {
  static const int port = 9847;
  static const String serviceType = '_woupass._tcp';
  static const String serviceName = 'WouPass';
  static const String protocolVersion = '1.0';
  static const int maxPairingAttempts = 5;
  static const int connectionTimeoutSeconds = 10;
}

enum MessageType {
  pairRequest,
  pairResponse,
  pairConfirm,
  pairConfirmed,
  reconnect,
  reconnectAuth,
  reconnectOk,
  pushCredential,
  error,
}
