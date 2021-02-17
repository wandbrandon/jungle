import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFirst;
  final String text;

  const ChatBubble({Key key, this.isCurrentUser, this.text, this.isFirst})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(20);
    final radiusdelta = Radius.circular(5);
    final borderRadius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: isFirst
                ? EdgeInsets.only(top: 12.5, bottom: 2.5)
                : EdgeInsets.symmetric(vertical: 2.5),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .75),
            decoration: BoxDecoration(
                color: isCurrentUser
                    ? Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[850]
                        : Colors.grey[300]
                    : Theme.of(context).accentColor,
                borderRadius: isCurrentUser
                    ? isFirst
                        ? borderRadius.subtract(BorderRadius.only(
                            bottomRight: radius - radiusdelta))
                        : borderRadius.subtract(BorderRadius.only(
                            bottomRight: radius - radiusdelta,
                            topRight: radius - radiusdelta))
                    : isFirst
                        ? borderRadius.subtract(
                            BorderRadius.only(bottomLeft: radius - radiusdelta))
                        : borderRadius.subtract(BorderRadius.only(
                            bottomLeft: radius - radiusdelta,
                            topLeft: radius - radiusdelta))),
            child: isCurrentUser
                ? Text(text, style: TextStyle(fontSize: 15))
                : Text(text,
                    style: TextStyle(
                        fontSize: 15, color: Theme.of(context).primaryColor)))
      ],
    );
  }
}
