import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/discover_page/activity_state.dart';
import 'package:jungle/screens/home/match_page/matched_dialog.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/widgets/profile_card.dart';
import 'package:ko_swipe_card/ko_swipe_card.dart';

import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

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
  Stream<List<UserModel>> _stream;

  @override
  void initState() {
    super.initState();
    currentCart = context.read<ActivityState>().getCart;
    final currentUserSnapshot = context.read<DocumentSnapshot>();
    currentUser = UserModel.fromJson(currentUserSnapshot.data());
    _stream = context
        .read<FirestoreService>()
        .getUnseenUsers(currentUser)
        .map((event) => event.map((e) => UserModel.fromJson(e.data())).toList())
        .distinct(listChecker);
  }

  bool listChecker(List<UserModel> list1, List<UserModel> list2) {
    Function deepEq = const DeepCollectionEquality().equals;
    bool test = deepEq(list1, list2);
    print(test);
    return test;
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
    if (users.length == 1) {
      currentUser.startAtUID = userState.uid;
      context
          .read<FirestoreService>()
          .updateUserByUID(currentUser.uid, currentUser);
      _stream = context
          .read<FirestoreService>()
          .getUnseenUsers(currentUser)
          .map((event) =>
              event.map((e) => UserModel.fromJson(e.data())).toList())
          .distinct(listChecker);
    }
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          Navigator.pop(context);
                        },
                        iconSize: 30,
                        icon: Icon(Ionicons.chevron_back)),
                    Text('Jungle',
                        style: GoogleFonts.lobsterTwo(
                            textStyle: TextStyle(
                                color: Theme.of(context).accentColor,
                                //fontWeight: FontWeight.w100,
                                fontSize: 34))),
                    IconButton(
                        icon: Icon(Ionicons.reorder_three),
                        iconSize: 30,
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Center(
                                  child: Text('User filters coming soon!')));
                        }),
                  ]),
            ),
            SizedBox(height: 10),
            StreamBuilder<List<UserModel>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print('here!');
                    return Expanded(
                        child: buildError(snapshot.error.toString()));
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Expanded(child: buildLoading());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        users = snapshot.data;
                        if (users.isNotEmpty) {
                          return buildUsers(context, currentUser);
                        }
                        return lastCard(context);
                      default:
                        return buildLoading();
                    }
                  }
                  // if (error != null) {
                  //   return buildError(error);
                  // } else if (users == null) {
                  //   return buildLoading();
                  // } else {
                  //   return buildUsers(context, currentUser);
                  // }
                }),
          ],
        ),
      ),
    );
  }

  Widget buildError(String text) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subtitle1,
      )),
    );
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
      return lastCard(context);
    }

    return KoSwipeCard(
      cardElevation: 0,
      cardCount: 4,
      dismissDuration: 200,
      recoverDuration: 400,
      cardWidth: MediaQuery.of(context).size.width * .95,
      cardHeight: MediaQuery.of(context).size.height * .75,
      cardDeltaHeight: 0,
      itemCount: users.length,
      cardRadiusBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      indexedCardBuilder: (context, index, rotateFraction, translateFraction) {
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
                                color: Colors.white.withOpacity(rotateFraction),
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
      },
    );
  }

  Container lastCard(context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width * .95,
      height: MediaQuery.of(context).size.height * .75,
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 4,
            child: Roulette(
              animate: true,
              infinite: true,
              spins: 1,
              duration: Duration(milliseconds: 3000),
              child: Icon(
                Ionicons.compass,
                size: 48,
              ),
            ),
          ),
          Spacer(flex: 1),
          Flexible(
            flex: 12,
            child: Text("That's everybody!",
                style: TextStyle(
                  fontSize: 22,
                )),
          ),
          Spacer(flex: 1),
          Flexible(
            flex: 4,
            child: Text(
              'Looks like you went through everyone. Time to try out some new places!',
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(
            flex: 4,
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context);
            },
            child: Text('Go back to Explore'),
          )
        ],
      ),
    );
  }

  Widget _buildCard(UserModel user) {
    return ProfileCard(
      key: ValueKey('${user.uid}'),
      height: MediaQuery.of(context).size.height * .75,
      user: user,
      matches: getActivityMatches(currentCart, user.activities),
    );
  }

  Widget buildLoading() {
    return Center(child: CircularProgressIndicator.adaptive());
  }
}
