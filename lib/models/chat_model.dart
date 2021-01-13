import 'package:flutter/material.dart';
import '../utils.dart';

class Message {
  final String idUser;
  final String username;
  final String message;
  final DateTime createdAt;

  const Message({
    @required this.idUser,
    @required this.username,
    @required this.message,
    @required this.createdAt,
  });
}
