import 'package:flutter/material.dart';
import 'package:jungle/models/user_model.dart';
import 'message_card.dart';

class MessageQueue extends StatelessWidget {
  final List<User> users;

  const MessageQueue({Key key, this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Padding(
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
        Expanded(
          child: Container(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) =>
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return MessageCard(user: users[index]);
              },
            ),
          ),
        ),
      ]),
    );
  }
}
