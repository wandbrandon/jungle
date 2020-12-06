import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/models/models.dart';
import 'package:flutter_chat_ui/screens/chat_room_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'contact_item.dart';

class MessageCard extends StatefulWidget {
  final User user;

  const MessageCard({Key key, this.user}) : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        showMaterialModalBottomSheet(
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black.withOpacity(.95),
          context: context,
          builder: (context) => ChatRoomPage(user: widget.user)),},
      child: Container(
        color: Colors.transparent,
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
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
                Text(
                  '${widget.user.messages.first.text}',
                  style: TextStyle(
                    fontSize: 14,
                    //fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
