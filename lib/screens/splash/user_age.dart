import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/main.dart';
import 'package:jungle/screens/splash/user_gender.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';

class UserAge extends StatefulWidget{
  final models.User tempUser;

  const UserAge({Key key, this.tempUser}) : super(key: key);

  @override
  _UserAgeState createState() => _UserAgeState();
}

class _UserAgeState extends State<UserAge> {
  TextEditingController textController = TextEditingController();
  bool validate = false;
  bool isTapped = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Container(
          padding: EdgeInsets.all(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How old are you?",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 12.5),
                  TextField(
                    style: TextStyle(fontSize: 24),
                    autofocus: true,
                    controller: textController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        textController.text.length == 2
                            ? validate = true
                            : validate = false;
                      });
                    },
                  ),
                ],
              ),
              GestureDetector(
                  onTap: validate
                      ? () {
                          setState(() {
                            isTapped = false;
                          });
                          widget.tempUser.age = int.parse(textController.text.trim());
                          context.read<FirestoreService>().createUser(context.read<User>().uid, widget.tempUser);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthenticationWrapper()));
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
