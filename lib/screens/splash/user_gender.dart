import 'package:flutter/material.dart';
import 'package:jungle/screens/splash/user_looking_for.dart';
import 'package:jungle/models/models.dart' as models;

class UserGender extends StatefulWidget {
  final models.UserModel tempUser;
  const UserGender({Key key, this.tempUser}) : super(key: key);

  @override
  _UserGenderState createState() => _UserGenderState();
}

class _UserGenderState extends State<UserGender> {
  bool isTapped1 = false;
  bool isTapped2 = false;
  bool isTapped3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "What do you identify as?",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.5),
              Text(
                "Tap one of the options to select it. Don't worry, this can be changed later.",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 25),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isTapped1 = false;
                    });
                    widget.tempUser.gender = "male";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserLookingFor(tempUser: widget.tempUser)));
                  },
                  onTapCancel: () {
                    setState(() {
                      isTapped1 = false;
                    });
                  },
                  onTapDown: (details) {
                    setState(() {
                      isTapped1 = true;
                    });
                  },
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: isTapped1 ? .93 : 1,
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        height: MediaQuery.of(context).size.height * .070,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Center(
                            child: Text('Male',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)))),
                  )),
              SizedBox(height: 8),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isTapped2 = false;
                    });
                    widget.tempUser.gender = 'female';
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserLookingFor(tempUser: widget.tempUser)));
                  },
                  onTapCancel: () {
                    setState(() {
                      isTapped2 = false;
                    });
                  },
                  onTapDown: (details) {
                    setState(() {
                      isTapped2 = true;
                    });
                  },
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: isTapped2 ? .93 : 1,
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        height: MediaQuery.of(context).size.height * .070,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Center(
                            child: Text('Female',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)))),
                  )),
              SizedBox(height: 8),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isTapped3 = false;
                    });
                    widget.tempUser.gender = 'other';

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserLookingFor(tempUser: widget.tempUser)));
                  },
                  onTapCancel: () {
                    setState(() {
                      isTapped3 = false;
                    });
                  },
                  onTapDown: (details) {
                    setState(() {
                      isTapped3 = true;
                    });
                  },
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: isTapped3 ? .93 : 1,
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        height: MediaQuery.of(context).size.height * .070,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Center(
                            child: Text('Other',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)))),
                  ))
            ],
          )),
    );
  }
}
