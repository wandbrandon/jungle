import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/widgets/match_queue.dart';
import 'package:jungle/widgets/message_queue.dart';

class ChatPage extends StatefulWidget {
  final User user;

  ChatPage({this.user});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final List<int> items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          brightness: Theme.of(context).brightness,
          elevation: 0,
          title: Text('Chats'),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.search),
            ),
          ],
        ),
        body: Column(
          children: [
            MatchQueue(),
            MessageQueue()
          ],
        ));
  }
}
