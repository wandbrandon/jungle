import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/user_model.dart';
import 'package:jungle/widgets/contact_item.dart';
import 'package:provider/provider.dart';

class MessageQueue extends StatelessWidget {
  final List<UserModel> users;

  const MessageQueue({Key key, this.users}) : super(key: key);

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
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: ContactItem(user: users[index]),
                title: Text(users[index].name),
                subtitle: Text('Nothing yet!'),
              );
            },
          ),
        ),
      ),
    ]);
  }
}
