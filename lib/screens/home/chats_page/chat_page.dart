import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/chats_page/match_queue.dart';
import 'package:jungle/screens/home/chats_page/message_queue.dart';

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
        body: StreamBuilder<List<User>>(
            stream: null,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text('Yikes, Jungle is acting up, try again later.'));
                  } else {
                    final users = snapshot.data;
                    if (users.isEmpty) {
                      return Center(
                        child: Text(
                            'No chats just yet'),
                      );
                    }
                    return Column(
                      children: [
                        //MatchQueue(),
                        MessageQueue(users: users)
                      ],
                    );
                  }
              }
            }));
  }
}
