import 'package:flutter/material.dart';

class Message {
  final String fromUID;
  final String toUID;
  final String message;
  final DateTime timestamp;

  const Message({
    @required this.fromUID,
    @required this.toUID,
    @required this.message,
    @required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'fromUID': fromUID,
        'toUID': toUID,
        'message': message,
        'timestamp': timestamp,
      };

  Message.fromJson(Map<String, dynamic> data)
      : fromUID = data['fromUID'] ?? "",
        toUID = data['toUID'] ?? "",
        message = data['message'] ?? "",
        timestamp = data['timestamp'].toDate() ?? "";
}
