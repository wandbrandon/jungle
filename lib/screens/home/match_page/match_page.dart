import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/widgets/profile_card.dart';
import 'package:swipeable_card/swipeable_card.dart';
import 'package:provider/provider.dart';

class MatchPage extends StatefulWidget {
  MatchPage({Key key}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  List<Widget> cards = [];
  int currentCardIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fireStoreService = context.watch<FirestoreService>();
    final currentUserSnapshot = context.watch<DocumentSnapshot>();
    final currentUser = models.User.fromJson(currentUserSnapshot.data());
    return FutureProvider<List<QueryDocumentSnapshot>>(
        create: (_) => fireStoreService.getUsers(currentUser),
        builder: (context, child) {
          final users = context.watch<List<QueryDocumentSnapshot>>();
          return users != null ? buildUsers(context, users) : buildLoading();
        });
  }

  Widget buildUsers(context, users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(users[index].data()['uid']),
      ),
    );
  }

  Widget buildLoading() {
    return CircularProgressIndicator.adaptive();
  }

  void swipeLeft() {
    print("left");
    setState(() => currentCardIndex++);
  }

  void swipeRight() {
    print("right");
    setState(() => currentCardIndex++);
  }
}

// Center(
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           title: Text('Jungle'),
//         ),
//         body: SafeArea(
//             child: FutureBuilder(
//                 future: context
//                     .watch<FirestoreService>()
//                     .getUsers(context.watch<User>()),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     snapshot.data
//                         .forEach((element) => print(element.data().toString()));
//                     return Column(
//                       mainAxisSize: MainAxisSize.max,
//                       children: <Widget>[
//                         if (currentCardIndex < cards.length)
//                           SwipeableWidget(
//                             key: ObjectKey(currentCardIndex),
//                             child: cards[currentCardIndex],
//                             scrollSensitivity: 30,
//                             onLeftSwipe: () => swipeLeft(),
//                             onRightSwipe: () => swipeRight(),
//                             nextCards: <Widget>[
//                               show next card
//                               if there are no next cards, show nothing
//                               if (!(currentCardIndex + 1 >= cards.length))
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: cards[currentCardIndex + 1],
//                                 ),
//                             ],
//                           )
//                         else
//                           if the deck is complete, add a button to reset deck
//                           Center(
//                             child: FlatButton(
//                               child: Text("Reset deck"),
//                               onPressed: () =>
//                                   setState(() => currentCardIndex = 0),
//                             ),
//                           ),

//                         only show the card controlling buttons when there are cards
//                         otherwise, just hide it
//                       ],
//                     );
//                   }
//                   return CircularProgressIndicator.adaptive();
//                 })),
//       ),
//     );
