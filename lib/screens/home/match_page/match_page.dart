import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/discover_page/activity_state.dart';
import 'package:jungle/screens/home/match_page/matched_dialog.dart';
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
  bool liked = true;
  UserModel userState;

  @override
  void initState() {
    super.initState();
  }

  Route _createRoute(UserModel currentUser) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MatchedDialog(
        user: userState,
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

  Future<void> swipeUser(UserModel currentUser) async {
    if (liked) {
      currentUser.likes.add(userState.uid);
      print('liked');
      if (userState.likes.contains(currentUser.uid)) {
        currentUser.matches.add(userState.uid);
        userState.matches.add(currentUser.uid);
        await context
            .read<FirestoreService>()
            .createChatRoom(currentUser, userState);
        Navigator.push(context, _createRoute(currentUser));
      }
      await context
          .read<FirestoreService>()
          .updateUserByAuth(context.read<User>(), currentUser);
      await context
          .read<FirestoreService>()
          .updateUserFieldByUID(userState.uid, 'matches', userState.matches);
    } else {
      currentUser.dislikes.add(userState.uid);
      print('disliked');
      await context
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
    final currentUserSnapshot = context.watch<DocumentSnapshot>();
    final currentUser = UserModel.fromJson(currentUserSnapshot.data());
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Icons.filter_alt_outlined),
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
              lazy: false,
              builder: (context, child) {
                final users = context.watch<List<Map<String, dynamic>>>();
                if (error != null) return buildError(error);
                if (users != null) {
                  if (users.isNotEmpty) {
                    return buildUsers(context, users, currentUser);
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

  Widget buildUsers(
      context, List<Map<String, dynamic>> users, UserModel currentUser) {
    return Container(
      child: KoSwipeCard(
        cardElevation: 0,
        cardWidth: MediaQuery.of(context).size.width * .95,
        cardHeight: MediaQuery.of(context).size.height * .72,
        cardDeltaHeight: 0,
        itemCount: users.length,
        indexedCardBuilder:
            (context, index, rotateFraction, translateFraction) {
          UserModel user = UserModel.fromJson(users[index]);
          userState = user;
          if (rotateFraction >= 1.0) {
            liked = true;
          } else if (rotateFraction <= -1.0) {
            liked = false;
          }
          return Stack(
            children: [
              _buildCard(user),
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
          setState(() {
            users.removeAt(0);
          });
          swipeUser(currentUser);
        },
      ),
    );
  }

  Widget _buildCard(UserModel user) {
    return ProfileCard(
      key: ValueKey('${user.uid}'),
      height: MediaQuery.of(context).size.height * .72,
      user: user,
      matches: getActivityMatches(
          context.read<ActivityState>().getCart, user.activities),
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
