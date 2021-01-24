import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/models/models.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/widgets/profile_card.dart';
import 'package:provider/provider.dart';
import 'package:ko_swipe_card/ko_swipe_card.dart';

class MatchPage extends StatefulWidget {
  MatchPage({Key key}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  List<Widget> cards = [];
  int currentCardIndex = 0;
  String error;

  @override
  void initState() {
    error = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fireStoreService = context.watch<FirestoreService>();
    final currentUserSnapshot = context.watch<DocumentSnapshot>();
    final currentUser = models.UserModel.fromJson(currentUserSnapshot.data());
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Icons.filter_alt_outlined), onPressed: () {}),
            ],
            elevation: 0,
            title: Text(
              'Jungle',
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 25),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FutureProvider<List<Map<String, dynamic>>>(
              create: (_) => fireStoreService.getUnaffectedUsers(currentUser),
              catchError: (_, catchedError) {
                setState(() {
                  error = catchedError.toString();
                });
                return null;
              },
              builder: (context, child) {
                final users = context.watch<List<Map<String, dynamic>>>();
                if (error != null) return buildError(error);
                if (users != null) {
                  if (users.isNotEmpty) {
                    return buildUsers(context, users);
                  } else {
                    return Center(
                        child: Text(
                      'Nobody else around! \nTry changing your places!',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ));
                  }
                } else {
                  return buildLoading();
                }
              }),
        ),
      ],
    );
  }

  Widget buildError(String text) {
    return Center(
        child: Text(
      text,
      style: Theme.of(context).textTheme.subtitle1,
    ));
  }

  Widget buildDebugUsers(context, users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(users[index]['uid']),
      ),
    );
  }

  Widget buildUsers(context, List<Map<String, dynamic>> users) {
    return Container(
      child: KoSwipeCard(
        cardElevation: 0,
        cardWidth: MediaQuery.of(context).size.width * .95,
        cardHeight: MediaQuery.of(context).size.height * .72,
        cardDeltaHeight: 0,
        itemCount: users.length,
        indexedCardBuilder:
            (context, index, rotateFraction, translateFraction) =>
                _buildCard(UserModel.fromJson(users[index])),
        topCardDismissListener: () {
          setState(() {
            users.removeAt(0);
          });
        },
      ),
    );
  }

  Widget _buildCard(UserModel user) {
    return Container(
      child: ProfileCard(
          key: ValueKey('${user.uid}'),
          height: MediaQuery.of(context).size.height * .72,
          user: user),
    );
  }

  Widget buildLoading() {
    return Center(child: CircularProgressIndicator.adaptive());
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

// return GestureDetector(
//       onHorizontalDragEnd: (dragEndDetails) {
//         if (dragEndDetails.primaryVelocity < 0) {
//           // Page forwards
//           print('Left Swipe');
//         } else if (dragEndDetails.primaryVelocity > 0) {
//           // Page backwards
//           print('Right Swipe');
//         }
//       },
//       child: Container(
//         padding: EdgeInsets.all(8),
//         child: ProfileCard(
//             height: MediaQuery.of(context).size.height * .75,
//             user: UserModel.fromJson(users[0])),
//       ),
//     );
//   }




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
