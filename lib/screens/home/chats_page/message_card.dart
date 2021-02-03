import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../widgets/contact_item.dart';

class MessageCard extends StatefulWidget {
  final UserModel user;
  final String lastMessage;

  const MessageCard({Key key, this.user, this.lastMessage}) : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {},
        child: Container(
          color: Colors.transparent,
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: ContactItem(user: widget.user, radius: 35),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.user.name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 5),
                  widget.lastMessage != null
                      ? Text(
                          '${widget.lastMessage}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        )
                      : Text(
                          'New Match',
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).highlightColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        ),
                ],
              ),
            ),
          ]),
        ));
  }
}
