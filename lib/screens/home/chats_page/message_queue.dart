import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/user_model.dart';
import 'package:jungle/screens/home/chats_page/chat_room_page.dart';
import 'package:jungle/widgets/contact_item.dart';
import 'package:provider/provider.dart';

class MessageQueue extends StatelessWidget {
  final List<QueryDocumentSnapshot> chatRooms;
  final String currentUserUID;

  const MessageQueue({Key key, this.chatRooms, this.currentUserUID})
      : super(key: key);

  UserModel getOppositeUser(List<dynamic> users) {
    UserModel user;
    users.forEach((element) {
      print('${element['uid']}, $currentUserUID');
      if (element['uid'].toString().compareTo(currentUserUID) != 0) {
        user = UserModel.fromJson(Map<String, dynamic>.from(element));
      }
    });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
        flex: 1,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Conversations",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).accentColor),
                ),
                Icon(Icons.more_horiz_rounded)
              ],
            )),
      ),
      Flexible(
        flex: 5,
        child: Scrollbar(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
            itemCount: chatRooms.length,
            itemBuilder: (BuildContext context, int index) {
              UserModel oppoUser =
                  getOppositeUser(chatRooms[index].data()['users']);
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatRoomPage(user: oppoUser)));
                },
                leading: ContactItem(user: oppoUser),
                title: Text(oppoUser.name),
                subtitle: Text('Nothing yet!'),
              );
            },
          ),
        ),
      ),
    ]);
  }
}
