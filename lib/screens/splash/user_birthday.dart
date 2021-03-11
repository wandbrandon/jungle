import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jungle/screens/splash/user_gender.dart';
import 'package:jungle/models/models.dart' as models;

class UserBirthday extends StatefulWidget {
  final models.UserModel tempUser;

  const UserBirthday({Key key, this.tempUser}) : super(key: key);

  @override
  _UserBirthdayState createState() => _UserBirthdayState();
}

class _UserBirthdayState extends State<UserBirthday> {
  DateTime birthday = DateTime.now();
  bool validate = false;
  bool isTapped = false;
  String errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "When's your birthday?",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.5),
              Text(
                "Can't change this later either!",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 8),
              Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .40,
                  ),
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                        primaryColor: Theme.of(context).accentColor,
                        primaryContrastingColor: Theme.of(context).accentColor,
                        barBackgroundColor: Theme.of(context).accentColor),
                    child: CupertinoDatePicker(
                        backgroundColor: Theme.of(context).primaryColor,
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        maximumYear: 2021,
                        onDateTimeChanged: (time) {
                          if (DateTime.now().difference(time) >
                              Duration(days: 365 * 18)) {
                            setState(() {
                              birthday = time;
                              validate = true;
                            });
                          } else {
                            setState(() {
                              validate = false;
                            });
                          }
                        }),
                  )),
              Spacer(),
              GestureDetector(
                  onTap: validate
                      ? () {
                          setState(() {
                            isTapped = false;
                          });
                          widget.tempUser.birthday = birthday;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserGender(tempUser: widget.tempUser)));
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
          )),
    );
  }
}
