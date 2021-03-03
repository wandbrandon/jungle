import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/discover_page/activity_state.dart';
import 'package:jungle/screens/home/match_page/matched_dialog.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/widgets/profile_card.dart';
import 'package:ko_swipe_card/ko_swipe_card.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:hop_swipe_cards/hop_swipe_cards.dart';

class MatchPage extends StatefulWidget {
  MatchPage({Key key}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  String error;
  bool liked = true;
  UserModel otherUser;
  UserModel currentUser;
  List<UserModel> users;
  List<Activity> currentCart;
  //PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    currentCart = context.read<ActivityState>().getCart;
    final currentUserSnapshot = context.read<DocumentSnapshot>();
    currentUser = UserModel.fromJson(currentUserSnapshot.data());
  }

  Route _createRoute(UserModel currentUser, UserModel otherUser) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MatchedDialog(
        user: otherUser,
        currentUser: currentUser,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = 0.0;
        var end = 1.0;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(
          curve: curve,
        ));
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Future<void> swipeUser(UserModel currentUser, UserModel userState) async {
    if (liked) {
      currentUser.likes.add(userState.uid);
      print('liked');
      if (userState.likes.contains(currentUser.uid)) {
        context.read<FirestoreService>().createChatRoom(currentUser, userState);
        Navigator.push(context, _createRoute(currentUser, userState));
      }
      context
          .read<FirestoreService>()
          .updateUserByUID(currentUser.uid, currentUser);
    } else {
      currentUser.dislikes.add(userState.uid);
      print('disliked');
      context
          .read<FirestoreService>()
          .updateUserByAuth(context.read<User>(), currentUser);
    }
    return;
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
    final fireStoreService = context.watch<FirestoreService>();
    return Material(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Ionicons.filter_outline),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          Center(child: Text('User filters coming soon!')));
                }),
          ],
          elevation: 0,
          title: Text(
            'Jungle',
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.w400,
                fontSize: 26),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: StreamProvider<List<UserModel>>(
                create: (context) =>
                    fireStoreService.getUnseenUsers(currentUser),
                catchError: (context, object) {
                  error = object.toString();
                  return null;
                },
                builder: (context, child) {
                  users = context.watch<List<UserModel>>();
                  if (error != null) {
                    return buildError(error);
                  } else if (users == null) {
                    return buildLoading();
                  } else {
                    return buildUsers(context, currentUser);
                  }
                }),
          ),
        ),
      ),
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

  Widget buildUsers(context, UserModel currentUser) {
    if (users.isEmpty) {
      return Center(
          child: Text(
        'No more users in your area! Try changing your activities.',
        textAlign: TextAlign.center,
      ));
    }
    return Container(
      child: KoSwipeCard(
        cardElevation: 0,
        cardWidth: MediaQuery.of(context).size.width * .95,
        cardHeight: MediaQuery.of(context).size.height * .72,
        cardDeltaHeight: 0,
        itemCount: users.length,
        cardRadiusBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        indexedCardBuilder:
            (context, index, rotateFraction, translateFraction) {
          if (rotateFraction >= 1.0) {
            liked = true;
          } else if (rotateFraction <= -1.0) {
            liked = false;
          }
          return Stack(
            children: [
              _buildCard(users[index]),
              index == 0
                  ? IgnorePointer(
                      ignoring: true,
                      child: Container(
                          color: rotateFraction > 0
                              ? Theme.of(context)
                                  .accentColor
                                  .withOpacity(rotateFraction)
                              : Colors.red.withOpacity(rotateFraction.abs())),
                    )
                  : SizedBox(),
              index == 0
                  ? IgnorePointer(
                      ignoring: true,
                      child: Container(
                          alignment: Alignment.center,
                          child: rotateFraction > 0
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 120,
                                  color:
                                      Colors.white.withOpacity(rotateFraction),
                                )
                              : Icon(Icons.clear_rounded,
                                  size: 120,
                                  color: Colors.white
                                      .withOpacity(rotateFraction.abs()))),
                    )
                  : SizedBox(),
            ],
          );
        },
        topCardDismissListener: () {
          otherUser = users[0];
          setState(() {
            users.removeAt(0);
          });
          swipeUser(currentUser, otherUser);
          //swipeUser(currentUser, otherUser);
        },
      ),
    );
  }

  Widget _buildCard(UserModel user) {
    return ProfileCard(
      key: ValueKey('${user.uid}'),
      height: MediaQuery.of(context).size.height * .72,
      user: user,
      matches: getActivityMatches(currentCart, user.activities),
    );
  }

  Widget buildLoading() {
    return Center(child: CircularProgressIndicator.adaptive());
  }
}
