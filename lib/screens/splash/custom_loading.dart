import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/activity_model.dart';
import 'package:jungle/screens/home/home_screen.dart';
import 'package:jungle/screens/splash/user_name.dart';
import 'package:provider/provider.dart';

class CustomLoading extends StatefulWidget {
  @override
  _CustomLoadingState createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading> {
  bool _isPlaying = false;
  DocumentSnapshot dbUser;
  Map<String, List<Activity>> activityMap;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dbUser = context.watch<DocumentSnapshot>();
    activityMap = context.watch<Map<String, List<Activity>>>();

    return Scaffold(
      body: Center(
          child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
              color: _isPlaying ? Colors.red : Colors.blue)),
    );
  }
}
