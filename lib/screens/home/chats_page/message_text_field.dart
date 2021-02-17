import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class MessageTextField extends StatefulWidget {
  final String idUser;
  final UserModel user;
  const MessageTextField({
    Key key,
    @required this.idUser,
    this.user,
  }) : super(key: key);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final tController = TextEditingController();
  String message = '';
  QueryDocumentSnapshot chatRoom;
  UserModel user;
  UserModel currentUser;

  onLoveTap() {
    HapticFeedback.mediumImpact();
    showDialog(
        context: context,
        builder: (context) => DateDialog(
              user: widget.user,
              chatRoom: chatRoom,
              currentUser: currentUser,
            ));
  }

  void sendMessage() async {
    HapticFeedback.mediumImpact();
    await context.read<FirestoreService>().sendMessage(
        chatRoom.data()['chatID'],
        Message(
            fromUID: widget.idUser,
            toUID: widget.user.uid,
            message: message,
            timestamp: DateTime.now()));
    tController.clear();
  }

  @override
  Widget build(BuildContext context) {
    chatRoom = context.watch<QueryDocumentSnapshot>();
    currentUser = UserModel.fromJson(context.watch<DocumentSnapshot>().data());
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: tController,
                    onEditingComplete:
                        message.trim().isEmpty ? null : sendMessage,
                    onChanged: (value) => setState(() {
                      message = value;
                    }),
                    cursorColor: Theme.of(context).accentColor,
                    maxLines: 5,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration.collapsed(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .color
                              .withOpacity(.33),
                        ),
                        border: InputBorder.none),
                  ),
                )),
          ),
          SizedBox(width: 10),
          Center(
            child: GestureDetector(
              onTap: onLoveTap,
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Theme.of(context).errorColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    Ionicons.checkmark_circle_outline,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  )),
            ),
          ),
          SizedBox(width: 10),
          AbsorbPointer(
            absorbing: message.trim().isEmpty,
            child: InkWell(
              onTap: () => sendMessage(),
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: message.trim().isNotEmpty
                          ? Theme.of(context).accentColor
                          : Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    Ionicons.arrow_forward_circle_outline,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class DateDialog extends StatefulWidget {
  final QueryDocumentSnapshot chatRoom;
  final UserModel currentUser;
  final UserModel user;

  const DateDialog({Key key, this.chatRoom, this.currentUser, this.user})
      : super(key: key);

  @override
  _DateDialogState createState() => _DateDialogState();
}

class _DateDialogState extends State<DateDialog> {
  bool agreed = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: new PageStorageKey(widget.user.uid),
      backgroundColor: Theme.of(context).errorColor,
      actions: [
        !(widget.chatRoom['dateUsersAccepted']['${widget.currentUser.uid}'] ||
                agreed)
            ? TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    agreed = true;
                  });
                  context.read<FirestoreService>().updateChatRoom(
                      widget.chatRoom.data()['chatID'],
                      'dateUsersAccepted.${widget.currentUser.uid}',
                      true);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Agree',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
              )
            : SizedBox(),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close',
              style: TextStyle(color: Theme.of(context).primaryColor)),
        )
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                widget.chatRoom.data()['dateUsersAccepted']
                            ['${widget.currentUser.uid}'] ||
                        agreed
                    ? Ionicons.hand_right
                    : Ionicons.hand_right_outline,
                size: 90,
                color: Theme.of(context).primaryColor.withOpacity(
                    widget.chatRoom.data()['dateUsersAccepted']
                                ['${widget.currentUser.uid}'] ||
                            agreed
                        ? 1
                        : .3),
              ),
              Icon(
                widget.chatRoom['dateUsersAccepted']['${widget.user.uid}']
                    ? Ionicons.hand_right
                    : Ionicons.hand_right_outline,
                size: 90,
                color: Theme.of(context).primaryColor.withOpacity(
                    widget.chatRoom['dateUsersAccepted']['${widget.user.uid}']
                        ? 1
                        : .3),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          widget.chatRoom['dateUsersAccepted']['${widget.user.uid}'] &&
                  (widget.chatRoom.data()['dateUsersAccepted']
                          ['${widget.currentUser.uid}'] ||
                      agreed)
              ? Text(
                  'Congrats! Time limit is now lifted.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              : Text(
                  "Once you have set a time and place, tap agree. \n\nWhen ${widget.user.name} agrees, your date will be set and your timer will stop. \n\nDon't worry! You'll still be able to chat.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  )),
        ],
      ),
    );
  }
}
