import 'package:flutter/material.dart';
import 'package:jungle/data/data.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'message_card.dart';

class MessageQueue extends StatelessWidget {
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
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Theme.of(context).accentColor),
                ),
                Icon(LineAwesomeIcons.ellipsis_h)
              ],
            )),
        Expanded(
          child: Container(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) =>
                  Padding(padding: EdgeInsets.symmetric(vertical: 7.5)),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
              itemCount: favorites.length,
              itemBuilder: (BuildContext context, int index) {
                return MessageCard(user: favorites[index]);
              },
            ),
          ),
        ),
      ]),
    );
  }
}
