import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';

class MessageTextField extends StatefulWidget {
  final String idUser;
  final UserModel user;
  final QueryDocumentSnapshot chatRoom;
  const MessageTextField({
    Key key,
    @required this.idUser,
    this.user,
    this.chatRoom,
  }) : super(key: key);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField>
    with SingleTickerProviderStateMixin {
  final tController = TextEditingController();
  String message = '';
  UserModel currentUser;

  onLoveTap() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => DateDialog(
        chatRoom: widget.chatRoom,
        user: widget.user,
        currentUser: currentUser,
      ),
    );
  }

  @override
  void dispose() {
    tController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    HapticFeedback.mediumImpact();
    context.read<FirestoreService>().sendMessage(
        widget.chatRoom.data()['chatID'],
        Message(
            fromUID: widget.idUser,
            toUID: widget.user.uid,
            message: message,
            timestamp: DateTime.now()));
    tController.clear();
    setState(() {
      message = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    currentUser = UserModel.fromJson(context.watch<DocumentSnapshot>().data());
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedSize(
                    alignment: Alignment.topCenter,
                    duration: Duration(milliseconds: 600),
                    curve: Curves.ease,
                    vsync: this,
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
                    Ionicons.people_circle_outline,
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
  final UserModel currentUser;
  final UserModel user;
  final QueryDocumentSnapshot chatRoom;

  const DateDialog({Key key, this.currentUser, this.user, this.chatRoom})
      : super(key: key);

  @override
  _DateDialogState createState() => _DateDialogState();
}

class _DateDialogState extends State<DateDialog> {
  QueryDocumentSnapshot chatRoom;

  @override
  Widget build(BuildContext context) {
    final chatRooms = context.watch<QuerySnapshot>().docs;
    chatRoom = chatRooms.firstWhere(
        (element) => element.data()['chatID'] == widget.chatRoom['chatID']);
    return AlertDialog(
      backgroundColor: Theme.of(context).errorColor,
      actions: [
        !(chatRoom['dateUsersAccepted']['${widget.currentUser.uid}'])
            ? TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.read<FirestoreService>().updateChatRoom(
                      chatRoom.data()['chatID'],
                      'dateUsersAccepted.${widget.currentUser.uid}',
                      true);
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
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  chatRoom.data()['dateUsersAccepted']
                          ['${widget.currentUser.uid}']
                      ? Ionicons.hand_right
                      : Ionicons.hand_right_outline,
                  size: 90,
                  color: Theme.of(context).primaryColor.withOpacity(
                      chatRoom.data()['dateUsersAccepted']
                              ['${widget.currentUser.uid}']
                          ? 1
                          : .3),
                ),
                Icon(
                  chatRoom['dateUsersAccepted']['${widget.user.uid}']
                      ? Ionicons.hand_right
                      : Ionicons.hand_right_outline,
                  size: 90,
                  color: Theme.of(context).primaryColor.withOpacity(
                      chatRoom['dateUsersAccepted']['${widget.user.uid}']
                          ? 1
                          : .3),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            chatRoom['dateUsersAccepted']['${widget.user.uid}'] &&
                    (chatRoom.data()['dateUsersAccepted']
                        ['${widget.currentUser.uid}'])
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
      ),
    );
  }
}
