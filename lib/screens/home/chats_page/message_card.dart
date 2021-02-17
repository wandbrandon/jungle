import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';
import '../../../widgets/contact_item.dart';
import 'chat_room_page.dart';

class MessageCard extends StatefulWidget {
  final UserModel user;
  const MessageCard({Key key, this.user}) : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  QueryDocumentSnapshot chatRoom;
  UserModel currentUser;

  bool dateSet() {
    return (chatRoom['dateUsersAccepted']['${widget.user.uid}'] &&
        (chatRoom['dateUsersAccepted']['${currentUser.uid}']));
  }

  bool timeRanOut() {
    final value = (1 -
        DateTime.now().difference(chatRoom['created'].toDate()).inHours / 48);
    return value <= 0;
  }

  bool isUnread() {
    final lastMessageUID = chatRoom['lastMessageSentBy'];
    final lastMessageRead = chatRoom['lastMessageRead'];
    if (lastMessageUID == widget.user) {
      return !lastMessageRead;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    chatRoom = context.watch<QueryDocumentSnapshot>();
    currentUser = UserModel.fromJson(context.watch<DocumentSnapshot>().data());
    return ColorFiltered(
      colorFilter: timeRanOut()
          ? ColorFilter.mode(
              Theme.of(context).primaryColor, BlendMode.saturation)
          : ColorFilter.mode(Colors.white, BlendMode.dst),
      child: AbsorbPointer(
        absorbing: timeRanOut(),
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Provider<QueryDocumentSnapshot>.value(
                            value: chatRoom,
                            child: ChatRoomPage(
                                currentUser: UserModel.fromJson(
                                    context.watch<DocumentSnapshot>().data()),
                                user: widget.user),
                          )));

              if (chatRoom['lastMessageRead'] != true) {
                context.read<FirestoreService>().updateChatRoom(
                    chatRoom.data()['chatID'], 'lastMessageRead', true);
              }
            },
            child: Container(
              color: Colors.transparent,
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ContactItem(user: widget.user, radius: 35),
                      isUnread()
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
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
                      chatRoom['lastMessage'] != ''
                          ? Text(
                              '${chatRoom['lastMessage']}',
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
                                  color: Theme.of(context).accentColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                            ),
                    ],
                  ),
                ),
                !(timeRanOut() || dateSet())
                    ? Container(
                        child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).errorColor),
                              value: 1 -
                                  DateTime.now()
                                          .difference(
                                              chatRoom['created'].toDate())
                                          .inHours /
                                      48),
                          Text(
                            "${48 - DateTime.now().difference(chatRoom['created'].toDate()).inHours}",
                            style: TextStyle(
                                color: Theme.of(context).errorColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ))
                    : SizedBox()
              ]),
            )),
      ),
    );
  }
}
