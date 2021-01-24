import 'package:flutter/material.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/chats_page/chat_bubble.dart';
import 'package:jungle/widgets/contact_item.dart';
import 'package:jungle/screens/home/chats_page/message_text_field.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:jungle/data/data.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel user;

  const ChatRoomPage({Key key, this.user}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.name}'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<List<Message>>(
              stream: null,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator.adaptive());
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Something Went Wrong, Try Again Later'));
                    } else {
                      final messages = snapshot.data;
                      return messages.isEmpty
                          ? Center(child: Text('Chat them up!'))
                          : Expanded(
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  reverse: true,
                                  controller: ModalScrollController.of(context),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 7.5),
                                  itemCount: messages.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    bool isCurrentUser =
                                        messages[index].idUser == null;
                                    bool isFirst = true;
                                    bool isLast = false;
                                    try {
                                      isFirst = messages[index].idUser !=
                                          messages[index + 1].idUser;
                                      isLast = messages[index].idUser !=
                                          messages[index - 1].idUser;
                                    } catch (e) {
                                      print("oops checked the edges");
                                      isLast = true;
                                    }
                                    return ChatBubble(
                                        isLast: isLast,
                                        isFirst: isFirst,
                                        isCurrentUser: isCurrentUser,
                                        text: '${messages[index].message}');
                                  }),
                            );
                    }
                }
              }),
          MessageTextField(idUser: widget.user.uid)
        ],
      ),
    ));
  }
}

// SafeArea(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 8.0),
//                 child: Row(children: [
//                   ContactItem(user: widget.user, radius: 30),
//                   SizedBox(
//                     width: 12,
//                   ),
//                   Text(widget.user.name,
//                       style: TextStyle(
//                           fontSize: 20, color: Colors.white)),
//                 ]),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 8.0),
//                 child: Icon(
//                   Icons.call_rounded,
//                   color: Colors.white,
//                 ),
//               )
//             ],
//           ),
//           SizedBox(height: 10),
//           Expanded(
//             child: Container(
//               clipBehavior: Clip.antiAlias,
//               padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context)
//                       .viewInsets
//                       .bottom),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor,
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(25),
//                   topLeft: Radius.circular(25),
//                 ),
//               ),
//               child: StreamBuilder<List<Message>>(
//                 stream: FirebaseApi.getMessages(widget.user.idUser),
//                 builder: (context, snapshot) {
//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting:
//                       return Center(child: CircularProgressIndicator.adaptive());
//                     default:
//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text('Something Went Wrong, Try Again Later'));
//                       } else {
//                         final messages = snapshot.data;
//                         return messages.isEmpty
//                               ? Center(child: Text('Chat them up!'))
//              : Column(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       child: ListView.builder(
//                         reverse: true,
//                         physics: BouncingScrollPhysics(),
//                         controller:
//                             ModalScrollController.of(context),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 5, vertical: 7.5),
//                         itemCount: messages.length,
//                         itemBuilder: (BuildContext context,
//                             int index) {
//                           bool isCurrentUser =
//                               messages[index].idUser == myId;
