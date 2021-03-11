import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isCurrentUser;
  final bool isLast;
  final String text;

  const ChatBubble({Key key, this.isCurrentUser, this.text, this.isLast})
      : super(key: key);

  bool emojiHandler(String text) {
    final RegExp REGEXEMOJI = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    print(text.length < 12 && REGEXEMOJI.hasMatch(text));
    return text.length < 12 && REGEXEMOJI.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(20);
    final radiusdelta = Radius.circular(3);
    final borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                    style: TextStyle(fontSize: emojiHandler(text) ? 40 : 15),
                    softWrap: true,
                    textWidthBasis: TextWidthBasis.longestLine,
                  )
                : Text(text,
                    softWrap: true,
                    textWidthBasis: TextWidthBasis.longestLine,
                    style: TextStyle(
                        fontSize: emojiHandler(text) ? 40 : 15,
                        color: Theme.of(context).primaryColor)))
      ],
    );
  }
}
