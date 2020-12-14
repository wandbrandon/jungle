import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jungle/api/firebase_api.dart';

class MessageTextField extends StatefulWidget {
  final String idUser;
  const MessageTextField({Key key, @required this.idUser}) : super(key: key);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  final tController = TextEditingController();
  String message = '';
  bool isOn = false;

  @override
  void initState() {
    super.initState();
    animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  void _handleOnPressed() {
    setState(() {
      isOn = !isOn;
      isOn ? animController.forward() : animController.reverse();
    });
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    await FirebaseApi.uploadMessage(widget.idUser, message);
    tController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 9,
      child: Container(
        height: MediaQuery.of(context).size.height * .075,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          //borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30),)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 15),
            InkWell(
              splashColor: Colors.black,
              customBorder: CircleBorder(),
              onTap: () => _handleOnPressed(),
              child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor,
                  ),
                  child: Center(
                    child: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: animController,
                      semanticLabel: 'Show menu',
                      color: Colors.white,
                    ),
                  )),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Stack(
                children: [
                  Container(
                      height: 38,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: TextField(
                            controller: tController,
                            onEditingComplete:
                                message.trim().isEmpty ? null : sendMessage,
                            onChanged: (value) => setState(() {
                              message = value;
                            }),
                            cursorColor: Colors.white,
                            maxLines: 3,
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
                ],
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
