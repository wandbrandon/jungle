import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CongratsPage extends StatefulWidget {
  @override
  _CongratsPageState createState() => _CongratsPageState();
}

class _CongratsPageState extends State<CongratsPage> {
  ConfettiController confettiController;

  @override
  void initState() {
    confettiController = ConfettiController(duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: ConfettiWidget(
        confettiController: confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: true,
        colors: [
          Theme.of(context).accentColor,
          Theme.of(context).highlightColor,
          Colors.purple,
        ],
      )),
    );
  }
}
