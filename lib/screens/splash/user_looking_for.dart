import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jungle/main.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/screens/home/home_screen.dart';
import 'package:jungle/screens/splash/user_pictures.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';

class UserLookingFor extends StatefulWidget {
  final models.UserModel tempUser;
  const UserLookingFor({Key key, this.tempUser}) : super(key: key);

  @override
  _UserLookingForState createState() => _UserLookingForState();
}

class _UserLookingForState extends State<UserLookingFor> {
  bool isTapped1 = false;
  bool isTapped2 = false;
  bool isTapped3 = false;
  bool isTapped4 = false;
  bool chosen1 = false;
  bool chosen2 = false;
  bool chosen3 = false;

  bool validate() {
    if (chosen1 || chosen2 || chosen3) {
      return true;
    }
    return false;
  }

  List<String> lookingForCreator() {
    List<String> temp = [];
    if (chosen1) {
      temp.add('male');
    }
    if (chosen2) {
      temp.add('female');
    }
    if (chosen3) {
      temp.add('other');
    }
    return temp;
  }

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
                "What are you looking for?",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.5),
              Text(
                "Tap one of the options to select it. You can choose more than one. This can always be changed as well!",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 25),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isTapped1 = false;
                      chosen1 = !chosen1;
                    });
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
                          color: chosen1
                              ? Theme.of(context).highlightColor
                              : Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Center(
                            child: Text('Males',
                                style: TextStyle(
                                  color: !chosen1
                                      ? Theme.of(context).highlightColor
                                      : Theme.of(context).primaryColor,
                                )))),
                  )),
              SizedBox(height: 8),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isTapped2 = false;
                      chosen2 = !chosen2;
                    });
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
                          color: chosen2
                              ? Theme.of(context).highlightColor
                              : Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Center(
                            child: Text('Females',
                                style: TextStyle(
                                  color: !chosen2
                                      ? Theme.of(context).highlightColor
                                      : Theme.of(context).primaryColor,
                                )))),
                  )),
              SizedBox(height: 8),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isTapped3 = false;
                      chosen3 = !chosen3;
                    });
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
                          color: chosen3
                              ? Theme.of(context).highlightColor
                              : Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Center(
                            child: Text('Others',
                                style: TextStyle(
                                  color: !chosen3
                                      ? Theme.of(context).highlightColor
                                      : Theme.of(context).primaryColor,
                                )))),
                  )),
              SizedBox(
                height: 40,
              ),
              Spacer(),
              GestureDetector(
                  onTap: validate()
                      ? () {
                          setState(() {
                            isTapped4 = false;
                          });
                          widget.tempUser.lookingFor = lookingForCreator();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserPictures(
                                        tempUser: widget.tempUser,
                                      )));
                        }
                      : null,
                  onTapCancel: validate()
                      ? () {
                          setState(() {
                            isTapped4 = false;
                          });
                        }
                      : null,
                  onTapDown: validate()
                      ? (details) {
                          setState(() {
                            isTapped4 = true;
                          });
                        }
                      : null,
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: isTapped4 ? .93 : 1,
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        height: MediaQuery.of(context).size.height * .065,
                        decoration: BoxDecoration(
                          color: !validate()
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
          )),
    );
  }
}
