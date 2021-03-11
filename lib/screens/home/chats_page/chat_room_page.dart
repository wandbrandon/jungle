import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/models/user_model.dart';
import 'package:jungle/screens/home/chats_page/chat_page.dart';
import 'package:jungle/screens/home/chats_page/message_text_field.dart';
import 'package:jungle/screens/home/discover_page/activity_state.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/widgets/contact_item.dart';
import 'package:provider/provider.dart';
import 'chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel user;
  final int chatRoomIndex;
  final UserModel currentUser;

  const ChatRoomPage({Key key, this.user, this.currentUser, this.chatRoomIndex})
      : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  QueryDocumentSnapshot chatRoom;

  String timestamp(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final aDate = DateTime(time.year, time.month, time.day);
    if (aDate == today) {
      return "Today, ${DateFormat.jm().format(time)}";
    } else if (aDate == yesterday) {
      return "Yesterday, ${DateFormat.jm().format(time)}";
    } else {
      return '${DateFormat.MMMEd('en_US').format(time)}, ${DateFormat.jm().format(time)}';
    }
  }

  @override
  void initState() {
    super.initState();
    final chatRooms = context.read<QuerySnapshot>().docs;
    chatRoom = chatRooms[widget.chatRoomIndex];
  }

  List<Activity> getActivityMatches(
      List<Activity> cart, List<dynamic> otherUserActivities) {
    List<Activity> tempActivities = [];
    cart.forEach((element) {
      if (otherUserActivities.contains(element.aid)) {
        tempActivities.add(element);
      }
    });
    return tempActivities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            ContactItem(
              radius: 19,
              user: widget.user,
              matches: getActivityMatches(
                  context.watch<ActivityState>().getCart,
                  widget.user.activities),
            ),
            SizedBox(width: 10),
            Text(widget.user.name),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(
                Ionicons.person,
              ),
              color: Colors.red,
              onPressed: () {
                HapticFeedback.mediumImpact();
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
                  return FooterLayout(
                    footer: KeyboardAttachable(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: MessageTextField(
                            chatRoom: chatRoom,
                            idUser: widget.currentUser.uid,
                            user: widget.user)),
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Container(
                          color: Theme.of(context).primaryColor,
                          alignment: Alignment.center,
                          child: Text(
                            "Say Hi!\n You've only got ${48 - DateTime.now().difference(chatRoom['created'].toDate()).inHours} hours left!",
                            textAlign: TextAlign.center,
                          )),
                    ),
                  );
                } else {
                  return FooterLayout(
                    footer: KeyboardAttachable(
                        backgroundColor: Colors.transparent,
                        child: MessageTextField(
                            chatRoom: chatRoom,
                            idUser: widget.currentUser.uid,
                            user: widget.user)),
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: CustomScrollView(
                        reverse: true,
                        primary: true,
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: true,
                            child: Container(
                              alignment: Alignment.topCenter,
                              color: Theme.of(context).primaryColor,
                              child: SingleChildScrollView(
                                reverse: true,
                                child: ImplicitlyAnimatedList<Message>(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    insertDuration: Duration(milliseconds: 600),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    items: snapshot.data,
                                    areItemsTheSame: (item1, item2) =>
                                        item1.timestamp == item2.timestamp,
                                    itemBuilder:
                                        (context, animation, item, index) {
                                      bool isCurrentUser = item.fromUID ==
                                          widget.currentUser.uid;
                                      bool isLast = true;
                                      bool isPast = false;
                                      try {
                                        isLast = item.fromUID !=
                                            snapshot.data[index - 1].fromUID;
                                        isPast = item.timestamp.difference(
                                                snapshot.data[index - 1]
                                                    .timestamp) >
                                            Duration(hours: 8);
                                      } catch (e) {
                                        print(e);
                                      }
                                      if (index == 0 || isPast) {
                                        return SizeFadeTransition(
                                          curve: Curves.ease,
                                          animation: animation,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Text(
                                                  timestamp(item.timestamp),
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .color
                                                          .withOpacity(.6)),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.5),
                                                child: ChatBubble(
                                                  key: ValueKey(
                                                      '${item.timestamp}'),
                                                  text: item.message,
                                                  isLast: true,
                                                  isCurrentUser: isCurrentUser,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return SizeFadeTransition(
                                        curve: Curves.ease,
                                        animation: animation,
                                        child: Padding(
                                          padding: isLast
                                              ? EdgeInsets.only(
                                                  top: 12.5, bottom: 2.5)
                                              : EdgeInsets.symmetric(
                                                  vertical: 2.5),
                                          child: ChatBubble(
                                            text: item.message,
                                            isLast: isLast,
                                            isCurrentUser: isCurrentUser,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            }),
      ),
    );
  }
}
