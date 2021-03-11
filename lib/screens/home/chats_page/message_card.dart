import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/discover_page/activity_state.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';
import '../../../widgets/contact_item.dart';
import 'chat_room_page.dart';

class MessageCard extends StatefulWidget {
  final UserModel user;
  final QueryDocumentSnapshot chatRoom;
  final int chatRoomIndex;
  const MessageCard({Key key, this.user, this.chatRoom, this.chatRoomIndex})
      : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  UserModel currentUser;

  bool timeRanOut() {
    final value = 48 -
        DateTime.now().difference(widget.chatRoom['created'].toDate()).inHours;

    Map<String, dynamic> acc = widget.chatRoom['dateUsersAccepted'];
    if (acc.values.every((element) => element)) {
      return false;
    }
    return value <= 0;
  }

  bool isUnread() {
    final lastMessageUID = widget.chatRoom['lastMessageSentBy'];
    final lastMessageRead = widget.chatRoom['lastMessageRead'];
    if (lastMessageUID != currentUser.uid) {
      return !lastMessageRead;
    }
    return false;
  }

  List<Activity> getActivityMatches(
      List<Activity> cart, List<dynamic> otherUserActivities) {
    List<Activity> tempActivities = [];
    cart.forEach((element) {
      if (otherUserActivities.contains(element.aid)) {
        tempActivities.add(element);
      }
    });
    return tempActivities;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> acc = widget.chatRoom['dateUsersAccepted'];
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
              HapticFeedback.selectionClick();
              if (widget.chatRoom['lastMessageRead'] != true) {
                if (widget.chatRoom['lastMessageSentBy'] != currentUser.uid) {
                  context.read<FirestoreService>().updateChatRoom(
                      widget.chatRoom.data()['chatID'],
                      'lastMessageRead',
                      true);
                }
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoomPage(
                        chatRoomIndex: widget.chatRoomIndex,
                        currentUser: UserModel.fromJson(
                            context.watch<DocumentSnapshot>().data()),
                        user: widget.user),
                  ));
            },
            child: Container(
              color: Colors.transparent,
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ContactItem(
                          user: widget.user,
                          radius: 35,
                          matches: getActivityMatches(
                              context.watch<ActivityState>().getCart,
                              widget.user.activities)),
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
                      widget.chatRoom['lastMessage'] != ''
                          ? Text(
                              '${widget.chatRoom['lastMessage']}',
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
                SizedBox(width: 15),
                !(timeRanOut() || acc.values.every((element) => element))
                    ? Container(
                        child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            "${48 - DateTime.now().difference(widget.chatRoom['created'].toDate()).inHours}",
                            style: TextStyle(
                                color: Theme.of(context).errorColor,
                                fontWeight: FontWeight.bold),
                          ),
                          CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).errorColor),
                              value: 1 -
                                  DateTime.now()
                                          .difference(widget.chatRoom['created']
                                              .toDate())
                                          .inHours /
                                      48),
                        ],
                      ))
                    : SizedBox()
              ]),
            )),
      ),
    );
  }
}
