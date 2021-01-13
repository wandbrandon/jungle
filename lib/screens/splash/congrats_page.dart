import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:jungle/main.dart';

class CongratsPage extends StatefulWidget {
  @override
  _CongratsPageState createState() => _CongratsPageState();
}

class _CongratsPageState extends State<CongratsPage> {
  ConfettiController confettiController;
  bool isTapped = false;
  bool validate = true;

  @override
  void initState() {
    confettiController = ConfettiController(duration: Duration(seconds: 5));
    confettiController.play();
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Jungle!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(height: 45),
                Text(
                  "We are currently in our testing phases so if you see any crazy bugs, be sure to leave a review. \n\nIf you're interested in working with us, please contact us through the app store. Your help is greatly appreciated! \n\nGood luck!",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 45),
                GestureDetector(
                    onTap: validate
                        ? () async {
                            setState(() {
                              isTapped = false;
                            });

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AuthenticationWrapper()));
                          }
                        : null,
                    onTapCancel: validate
                        ? () {
                            setState(() {
                              isTapped = false;
                            });
                          }
                        : null,
                    onTapDown: validate
                        ? (details) {
                            setState(() {
                              isTapped = true;
                            });
                          }
                        : null,
                    child: Transform.scale(
                      alignment: Alignment.center,
                      scale: isTapped ? .93 : 1,
                      child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          height: MediaQuery.of(context).size.height * .065,
                          decoration: BoxDecoration(
                            color: !validate
                                ? Theme.of(context).backgroundColor
                                : Theme.of(context).accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Center(
                              child: Text('CONTINUE',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor)))),
                    ))
              ],
            ),
          ),
          Positioned(
            top: -200,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.directional,
              blastDirection: pi / 2,
              particleDrag: .01, // apply drag to the confetti
              emissionFrequency: 0, // how often it should emit
              numberOfParticles: 700, // number of particles to emit
              gravity: 0.005,
              shouldLoop: false,
              colors: [
                Theme.of(context).accentColor.withOpacity(.95),
                Theme.of(context).highlightColor.withOpacity(.95),
                //Colors.blue.withOpacity(.6)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
