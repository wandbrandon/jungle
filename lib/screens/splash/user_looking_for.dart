import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart' as models;
class UserLookingFor extends StatefulWidget {
  final models.User tempUser;
  const UserLookingFor({Key key, this.tempUser}) : super(key: key);


  @override
  _UserLookingForState createState() => _UserLookingForState();
}

class _UserLookingForState extends State<UserLookingFor> {
  bool isTapped1 = false;
  bool isTapped2 = false;
  bool isTapped3 = false;
  bool chosen1 = false;
  bool chosen2 = false;
  bool chosen3 = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Container(
          padding: EdgeInsets.all(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "What are you looking for?",
                style:
                    TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 25),
              GestureDetector(
                  onTap: () {
                          setState(() {
                            isTapped1 = false;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserLookingFor()));
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
                            child: Text('Males',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColor))
                                )),
                  )),
                  SizedBox(height: 8),
                  GestureDetector(
                  onTap: () {
                          setState(() {
                            isTapped2 = false;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserLookingFor()));
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
                            child: Text('Females',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColor))
                                )),
                  )),
                  SizedBox(height: 8),
                  GestureDetector(
                  onTap: () {
                          setState(() {
                            isTapped3 = false;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserLookingFor()));
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
                            child: Text('Others',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColor))
                                )),
                  ))
            ],
          )),
    );
  }
}
