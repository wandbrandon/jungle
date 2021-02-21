import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isCurrentUser;
  final bool isLast;
  final String text;

  const ChatBubble({Key key, this.isCurrentUser, this.text, this.isLast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(18);
    final radiusdelta = Radius.circular(3);
    final borderRadius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .74),
            decoration: BoxDecoration(
                color: isCurrentUser
                    ? Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[850]
                        : Colors.grey[300]
                    : Theme.of(context).accentColor,
                borderRadius: isCurrentUser
                    ? isLast
                        ? borderRadius.subtract(BorderRadius.only(
                            bottomRight: radius - radiusdelta))
                        : borderRadius.subtract(BorderRadius.only(
                            bottomRight: radius - radiusdelta,
                            topRight: radius - radiusdelta))
                    : isLast
                        ? borderRadius.subtract(
                            BorderRadius.only(bottomLeft: radius - radiusdelta))
                        : borderRadius.subtract(BorderRadius.only(
                            bottomLeft: radius - radiusdelta,
                            topLeft: radius - radiusdelta))),
            child: isCurrentUser
                ? Text(
                    text,
                    style: TextStyle(fontSize: 15),
                    softWrap: true,
                    textWidthBasis: TextWidthBasis.longestLine,
                  )
                : Text(text,
                    style: TextStyle(
                        fontSize: 15, color: Theme.of(context).primaryColor)))
      ],
    );
  }
}
