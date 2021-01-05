import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/screens/splash/congrats_page.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/widgets/image_picker_widget.dart';
import 'package:provider/provider.dart';

class UserPictures extends StatefulWidget {
  final models.User tempUser;
  UserPictures({Key key, this.tempUser}) : super(key: key);

  @override
  _UserPicturesState createState() => _UserPicturesState();
}

class _UserPicturesState extends State<UserPictures> {
  List<dynamic> images;
  bool validate = false;
  bool isTapped = false;

  @override
  void initState() {
    images = [null, null, null];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lastly, who's that behind the screen?",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 12.5),
                  Text(
                    "Here at Jungle we believe three pictures is just enough information so you can spend more time meeting and less time swiping. Make those pictures count!",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 25),
                  ImageSetting(images: images)
                ],
              ),
              GestureDetector(
                  onTap: validate
                      ? () {
                          setState(() {
                            isTapped = false;
                          });
                          widget.tempUser.images = images;
                          context.read<FirestoreService>().createUser(
                              context.read<User>().uid, widget.tempUser);
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CongratsPage()));
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
