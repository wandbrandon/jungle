import 'package:flutter/material.dart';
import 'package:jungle/models/user_model.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel user;

  const ChatRoomPage({Key key, this.user}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [Text(widget.user.name)],
          ),
        ),
        body: Center(child: Text('chat')));
  }
}
