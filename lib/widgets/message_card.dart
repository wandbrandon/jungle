import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/chat_room_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tap_builder/tap_builder.dart';
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
    return AnimatedTapBuilder(
        onTap: () => {
              showMaterialModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  barrierColor: Colors.black.withOpacity(.95),
                  context: context,
                  builder: (context) => ChatRoomPage(user: widget.user)),
            },
        builder: (context, state, cursorLocation, cursorAlignment) {
          cursorAlignment = state == TapState.pressed
              ? Alignment(-cursorAlignment.x, -cursorAlignment.y)
              : Alignment.center;
          return Container(
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: ContactItem(user: widget.user, radius: 35),
              ),
              Expanded(
                child: AnimatedContainer(
                  transform: Matrix4.rotationX(-cursorAlignment.y * 0.2)
                    ..rotateY(cursorAlignment.x * 0.2)
                    ..scale(
                      state == TapState.pressed ? 0.94 : 1.0,
                  ),
                  transformAlignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
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
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        });
  }
}

// Container(
//         color: Colors.transparent,
//         child: Row(children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 15),
//             child: ContactItem(user: widget.user, radius: 35),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('${widget.user.name}',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     )),
//                 SizedBox(height: 5),
//                 Text(
//                   '${widget.user.messages.first.text}',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 2,
//                   softWrap: true,
//                 ),
//               ],
//             ),
//           ),
//         ]),
//       ),
