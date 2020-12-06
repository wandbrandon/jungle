import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageTextField extends StatefulWidget {
  const MessageTextField({Key key}) : super(key: key);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .075,
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(.75),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10),
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
                  ),
                )),
          ),
          SizedBox(width: 10),
          
          Expanded(
            child: Stack(
              children: [
                Container(
                    clipBehavior: Clip.hardEdge,
                    height: 38,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: TextField(
                          cursorColor: Colors.white,
                          decoration: InputDecoration.collapsed(
                              hintText: "Message",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(.25),
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
    );
  }
}
