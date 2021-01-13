import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              height: 300,
              width: 300,
              child: CircularProgressIndicator.adaptive())),
    );
  }
}
