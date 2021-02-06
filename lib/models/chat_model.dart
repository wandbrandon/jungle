import 'package:flutter/material.dart';

class Message {
  final String fromUID;
  final String message;
  final DateTime timestamp;

  const Message({
    @required this.fromUID,
    @required this.message,
    @required this.timestamp,
  });

  Map<String, dynamic> toJson() =>
      {'fromUID': fromUID, 'message': message, 'timestamp': timestamp};
}
