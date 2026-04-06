import 'dart:convert';
import 'package:woupassv2/core/networking/protocol_constants.dart';

class ProtocolMessage {
  final MessageType type;
  final String id;
  final int seq;
  final int timestamp;
  final Map<String, dynamic> payload;

  ProtocolMessage({
    required this.type,
    required this.id,
    required this.seq,
    required this.payload,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  factory ProtocolMessage.fromJson(Map<String, dynamic> json) {
    return ProtocolMessage(
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.error,
      ),
      id: json['id'] as String,
      seq: json['seq'] as int,
      timestamp: json['timestamp'] as int,
      payload: json['payload'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'id': id,
    'seq': seq,
    'timestamp': timestamp,
    'payload': payload,
  };

  String toJsonString() => jsonEncode(toJson());

  static ProtocolMessage fromJsonString(String jsonStr) =>
      ProtocolMessage.fromJson(jsonDecode(jsonStr));
}
