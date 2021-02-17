import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/user_model.dart';
import 'package:jungle/screens/home/chats_page/chat_room_page.dart';
import 'package:jungle/screens/home/chats_page/message_card.dart';
import 'package:provider/provider.dart';

class MessageQueue extends StatelessWidget {
  final UserModel currentUser;

  const MessageQueue({Key key, this.currentUser}) : super(key: key);

  UserModel getOppositeUser(Map<String, dynamic> users) {
    UserModel user;
    users.forEach((key, value) {
      if (key.compareTo(currentUser.uid) != 0) {
        user = UserModel.fromJson(Map<String, dynamic>.from(value));
      }
    });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final chatRooms = context.watch<QuerySnapshot>().docs;
    return Column(children: [
      Flexible(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Matches",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).accentColor),
                ),
                Icon(Ionicons.ellipsis_horizontal)
              ],
            )),
      ),
      Expanded(
        child: Scrollbar(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
            itemCount: chatRooms.length,
            itemBuilder: (BuildContext context, int index) {
              return Provider<QueryDocumentSnapshot>.value(
                value: chatRooms[index],
                builder: (context, child) => MessageCard(
                  user: getOppositeUser(chatRooms[index].data()['users']),
                ),
              );
            },
          ),
        ),
      ),
    ]);
  }
}
