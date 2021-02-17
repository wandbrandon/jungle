import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/models/user_model.dart';
import 'package:jungle/screens/home/chats_page/chat_bubble.dart';
import 'package:jungle/screens/home/chats_page/chat_page.dart';
import 'package:jungle/screens/home/chats_page/message_text_field.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/widgets/contact_item.dart';
import 'package:provider/provider.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel user;
  final UserModel currentUser;

  const ChatRoomPage({Key key, this.user, this.currentUser}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  QueryDocumentSnapshot chatRoom;

  @override
  Widget build(BuildContext context) {
    chatRoom = context.watch<QueryDocumentSnapshot>();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            children: [
              ContactItem(
                radius: 19,
                user: widget.user,
              ),
              SizedBox(width: 10),
              Text(widget.user.name),
            ],
          ),
          actions: [
            IconButton(
                icon: Icon(Ionicons.close_circle_outline),
                color: Colors.red,
                onPressed: () {
                  HapticFeedback.vibrate();
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: Colors.red,
                            title: Text(
                              'Unmatch?',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    context
                                        .read<FirestoreService>()
                                        .unmatch(chatRoom.data()['chatID']);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage()),
                                        (route) => route.isFirst);
                                  },
                                  child: Text('Yes',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor))),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor))),
                            ],
                            content: Text(
                                'Are you sure you want to unmatch with ${widget.user.name}?',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                )),
                          ));
                }),
          ],
        ),
        body: SafeArea(
          child: StreamBuilder<List<Message>>(
              stream: context
                  .watch<FirestoreService>()
                  .getMessagesStream(chatRoom.data()['chatID']),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('Loading...'));
                } else {
                  if (snapshot.data.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                              child: Text(
                            "Say Hi!\n You've only got ${48 - DateTime.now().difference(chatRoom['created'].toDate()).inHours} hours left!",
                            textAlign: TextAlign.center,
                          )),
                        ),
                        MessageTextField(
                            idUser: widget.currentUser.uid, user: widget.user),
                      ],
                    );
                  } else {
                    List<Message> messages = snapshot.data;
                    return Column(children: [
                      Expanded(
                          child: ListView.builder(
                              reverse: true,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                bool isCurrentUser = messages[index].fromUID ==
                                    widget.currentUser.uid;
                                bool isFirst = true;
                                try {
                                  isFirst = messages[index].fromUID !=
                                      messages[index + 1].fromUID;
                                } catch (e) {
                                  print("oops checked the edges");
                                }
                                return ChatBubble(
                                  text: messages[index].message,
                                  isFirst: isFirst,
                                  isCurrentUser: isCurrentUser,
                                );
                              })),
                      MessageTextField(
                          idUser: widget.currentUser.uid, user: widget.user)
                    ]);
                  }
                }
              }),
        ));
  }
}
