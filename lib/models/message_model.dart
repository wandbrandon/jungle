import 'package:jungle/models/user_model.dart';

class Message {
  final int id;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.id,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}
