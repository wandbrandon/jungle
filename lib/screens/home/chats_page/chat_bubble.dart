import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFirst;
  final bool isLast;
  final String text;

  const ChatBubble({Key key, this.isCurrentUser, this.text, this.isFirst, this.isLast})
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
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(2.5),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .75),
            decoration: BoxDecoration(
                color: isCurrentUser
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context).accentColor,
                borderRadius: isCurrentUser
                    ? isFirst
                        ? borderRadius.subtract(BorderRadius.only(
                              bottomRight: radius - radiusdelta))
                        : isLast 
                          ? borderRadius.subtract(BorderRadius.only(
                              topRight: radius - radiusdelta))
                          : borderRadius.subtract(BorderRadius.only(
                            bottomRight: radius - radiusdelta,
                            topRight: radius - radiusdelta))
                    : isFirst
                        ? borderRadius.subtract(BorderRadius.only(
                              bottomLeft: radius - radiusdelta))
                        : isLast 
                          ? borderRadius.subtract(BorderRadius.only(
                              topLeft: radius - radiusdelta))
                          : borderRadius.subtract(BorderRadius.only(
                            bottomLeft: radius - radiusdelta,
                            topLeft: radius - radiusdelta))

            ),
            child: Text(text))
      ],
    );
  }
}

