import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/screens/home/profile_page/image_settings.dart';

import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:tap_builder/tap_builder.dart';

class ProfileEditPage extends StatefulWidget {
  final DocumentSnapshot currentUser;

  const ProfileEditPage({Key key, this.currentUser}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  Map<String, dynamic> tempUser;

  @override
  initState() {
    tempUser = widget.currentUser.data();
    super.initState();
  }

  void changeValue(String identifier, String value) {
    setState(() {
      tempUser[identifier] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<DocumentSnapshot>.value(
        value: widget.currentUser,
        child: Provider.value(
          value: this,
          builder: (context, child) => Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
              actions: [
                FlatButton(
                    textColor: Theme.of(context).accentColor,
                    textTheme: ButtonTextTheme.normal,
                    onPressed: () {
                      context.read<FirestoreService>().updateUserByAuth(
                          context.read<User>(), models.User.fromJson(tempUser));
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text('Save', style: TextStyle(fontSize: 16)),
                    ))
              ],
              elevation: 0,
            ),
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              children: [
                ImageSetting(
                  images: ['dog', null],
                ),
                SizedBox(height: 15),
                EditorItem(
                  identifier: 'bio',
                  maxlines: 6,
                  about: 'About me',
                  hint: "A little bit about you...",
                ),
                SizedBox(height: 8),
                EditorItem(
                  identifier: 'work',
                  maxlines: 1,
                  about: 'My work & education',
                  hint: "Add job",
                ),
                SizedBox(height: 8),
                EditorItem(
                  identifier: 'edu',
                  maxlines: 1,
                  about: null,
                  hint: "Add education",
                ),
                SizedBox(height: 8),
                EditorItem(
                  identifier: 'live',
                  maxlines: 1,
                  about: 'Basic Info',
                  hint: "Add where I live",
                ),
                SizedBox(height: 8),
                EditorItem(
                  identifier: 'from',
                  maxlines: 1,
                  about: null,
                  hint: "Add where I'm from",
                ),
                SizedBox(height: 8),
                GenderPicker()
              ],
            ),
          ),
        ));
  }
}

class EditorItem extends StatefulWidget {
  final int maxlines;
  final String about;
  final String hint;
  final String identifier;

  const EditorItem({
    Key key,
    this.maxlines,
    this.about,
    this.hint,
    this.identifier,
  }) : super(key: key);

  @override
  _EditorItemState createState() => _EditorItemState();
}

class _EditorItemState extends State<EditorItem> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(
        text: context.read<DocumentSnapshot>().data()[widget.identifier]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.about != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(widget.about,
                    style: Theme.of(context).textTheme.caption),
              )
            : SizedBox(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: TextField(
            controller: _controller,
            inputFormatters: [LengthLimitingTextInputFormatter(150)],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
            ),
            maxLines: widget.maxlines,
            minLines: (widget.maxlines / 2).round(),
            onChanged: (value) {
              print(value);
              context
                  .read<_ProfileEditPageState>()
                  .changeValue(widget.identifier, value);
            },
          ),
        ),
      ],
    );
  }
}

class GenderPicker extends StatefulWidget {
  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  String gender;

  @override
  void initState() {
    gender = context.read<DocumentSnapshot>().data()['gender'];
    super.initState();
  }

  Alignment handleAlignment() {
    print(gender);
    if (gender == 'male') return Alignment.centerLeft;
    if (gender == 'female') return Alignment.center;
    return Alignment.centerRight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInExpo,
              alignment: handleAlignment(),
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          gender = 'male';
                        });
                        context
                            .read<_ProfileEditPageState>()
                            .changeValue('gender', 'male');
                      },
                      child: Text('Male')),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          gender = 'female';
                        });
                        context
                            .read<_ProfileEditPageState>()
                            .changeValue('gender', 'female');
                      },
                      child: Text('Female')),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          gender = 'other';
                        });
                        context
                            .read<_ProfileEditPageState>()
                            .changeValue('gender', 'other');
                      },
                      child: Text('Other')),
                ],
              ),
            ),
          ],
        ));
  }
}
