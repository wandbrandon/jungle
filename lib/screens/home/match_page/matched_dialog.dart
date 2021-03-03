import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jungle/models/user_model.dart';
import 'package:jungle/screens/home/chats_page/chat_page.dart';
import 'package:tap_builder/tap_builder.dart';

class MatchedDialog extends StatefulWidget {
  final UserModel user;
  final UserModel currentUser;

  const MatchedDialog({Key key, this.user, this.currentUser}) : super(key: key);

  @override
  _MatchedDialogState createState() => _MatchedDialogState();
}

class _MatchedDialogState extends State<MatchedDialog> {
  ConfettiController confettiController;

  @override
  void initState() {
    confettiController = ConfettiController(duration: Duration(seconds: 5));
    confettiController.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Stack(
        children: [
          Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).accentColor,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              ),
              backgroundColor: Theme.of(context).accentColor,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * .15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('You Matched!',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor)),
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        fit: StackFit.loose,
                        children: [
                          Container(
                            height: 200,
                            width: 250,
                          ),
                          Positioned(
                            right: 20,
                            bottom: 5,
                            child: Container(
                              height: 125,
                              width: 125,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context).primaryColor),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      widget.user.images[0],
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 5,
                            child: Container(
                              height: 125,
                              width: 125,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context).primaryColor),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      widget.currentUser.images[0],
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Keep Swiping',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage()),
                              (route) => route.isFirst);
                        },
                        child: Text(
                          'Go to Chats',
                        ),
                      )
                    ],
                  ),
                ),
              )),
          Container(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: .01, // apply drag to the confetti
                emissionFrequency: 0, // how often it should emit
                numberOfParticles: 1000, // number of particles to emit
                gravity: 0.005,
                shouldLoop: false,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(.8),
                  Theme.of(context).errorColor
                  //Colors.blue.withOpacity(.6)
                ],
              )),
        ],
      ),
    );
  }
}
