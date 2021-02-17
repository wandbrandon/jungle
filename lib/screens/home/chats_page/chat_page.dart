import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jungle/screens/home/chats_page/message_queue.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/models/models.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String error = "";

  @override
  Widget build(BuildContext context) {
    UserModel currentUser =
        UserModel.fromJson(context.watch<DocumentSnapshot>().data());
    final firestore = context.watch<FirestoreService>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Messages'),
      ),
      body: StreamProvider<QuerySnapshot>(
          updateShouldNotify: (_, __) => true,
          create: (context) => firestore.getChatRoomsByUID(currentUser.uid),
          catchError: (context, object) {
            print(object.toString());
            setState(() {
              error = object.toString();
            });
            return null;
          },
          builder: (context, child) {
            final querySnaps = context.watch<QuerySnapshot>();
            if (querySnaps == null) {
              return Center(child: CircularProgressIndicator.adaptive());
            } else if (error != '') {
              return Center(
                  child:
                      Text('Something went wrong, try again later. \n$error'));
            } else if (querySnaps.docs.isEmpty) {
              return Center(
                child: Text(
                  "You haven't matched with anyone yet. \nKeep swiping!",
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return MessageQueue(
                currentUser: currentUser,
              );
            }
          }),
    );
  }
}
