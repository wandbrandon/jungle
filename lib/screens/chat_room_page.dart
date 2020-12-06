import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/models/user_model.dart';
import 'package:flutter_chat_ui/widgets/contact_item.dart';
import 'package:flutter_chat_ui/widgets/message_text_field.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChatRoomPage extends StatefulWidget {
  final User user;

  const ChatRoomPage({Key key, this.user}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(children: [
                  ContactItem(user: widget.user, radius: 30),
                  SizedBox(width: 12,),
                  Text(widget.user.name,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      )),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.call_rounded, color: Colors.white,),
              )
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(17.5),
                  topLeft: Radius.circular(17.5),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                        child: Container(
                            height: 6,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17.5)),
                            ))),
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.separated(
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        controller: ModalScrollController.of(context),
                        separatorBuilder: (BuildContext context, int index) =>
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 7.5)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 7.5),
                        itemCount: widget.user.messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Bubble(
                              elevation: 0,
                              radius: Radius.circular(20),
                              padding: BubbleEdges.symmetric(
                                  horizontal: 15, vertical: 10),
                              margin: widget.user.messages[index].id == 0
                                  ? BubbleEdges.only(
                                      bottom: 0,
                                      top: 0,
                                      left: MediaQuery.of(context).size.width *
                                          .15)
                                  : BubbleEdges.only(
                                      bottom: 0,
                                      top: 0,
                                      right: MediaQuery.of(context).size.width *
                                          .15),
                              alignment: widget.user.messages[index].id == 0
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              color: widget.user.messages[index].id == 0
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).backgroundColor,
                              child: Text(
                                widget.user.messages[index].text,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: MessageTextField(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
