import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/screens/splash/user_age.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:jungle/models/models.dart' as models;

class UserName extends StatefulWidget {
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  TextEditingController textController = TextEditingController();
  bool validate = false;
  bool isTapped = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                'Exiting the app will stop user creation, and return you to the main screen.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(("/splash"), (route) => false);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: _onWillPop,
              icon: Icon(
                Icons.close_rounded,
                size: 35,
              ),
            )),
        body: Container(
            padding: EdgeInsets.all(35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What's your First Name?",
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12.5),
                    Text(
                      "This cannot be changed later.",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 25),
                    TextField(
                      style: TextStyle(fontSize: 24),
                      autofocus: true,
                      controller: textController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        LengthLimitingTextInputFormatter(20)
                      ],
                      keyboardType: TextInputType.text,
                      cursorColor: Theme.of(context).accentColor,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        setState(() {
                          textController.text.isEmpty
                              ? validate = false
                              : validate = true;
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
                            models.UserModel tempUser = models.UserModel(
                                uid: context.read<User>().uid,
                                name: textController.text.trim());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserAge(tempUser: tempUser)));
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
      ),
    );
  }
}
