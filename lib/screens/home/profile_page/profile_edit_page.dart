import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/widgets/image_picker_widget.dart';
import 'package:provider/provider.dart';

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
                  images: ['dog', null, null],
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

  Color handleState(String state) {
    if (state == gender) {
      return Theme.of(context).accentColor;
    }
    return Theme.of(context).backgroundColor;
  }

  Future<void> _askedToLead() async {
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select your gender'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'male');
                },
                child: const Text('Male'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'female');
                },
                child: const Text('Female'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'other');
                },
                child: const Text('Other'),
              ),
            ],
          );
        })) {
      case 'male':
        setState(() {
          gender = 'male';
        });
        context.read<_ProfileEditPageState>().changeValue('gender', gender);

        break;
      case 'female':
        setState(() {
          gender = 'female';
        });
        context.read<_ProfileEditPageState>().changeValue('gender', gender);
        break;
      case 'other':
        setState(() {
          gender = 'other';
        });
        context.read<_ProfileEditPageState>().changeValue('gender', gender);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _askedToLead,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  gender[0].toUpperCase() + gender.substring(1),
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Icon(Icons.keyboard_arrow_right_rounded)
              ],
            ),
          )),
    );
  }
}

// class ImageSetting extends StatefulWidget {
//   final List<dynamic> images;

//   const ImageSetting({Key key, this.images}) : super(key: key);

//   @override
//   _ImageSettingState createState() => _ImageSettingState();
// }

// class _ImageSettingState extends State<ImageSetting> {
//   bool listChecker(int index) {
//     if (widget.images.length - 1 < index) {
//       return false;
//     } else if (widget.images[index] == null) {
//       return false;
//     }
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//             color: Theme.of(context).backgroundColor,
//             borderRadius: BorderRadius.all(Radius.circular(15))),
//         child: GridView.builder(
//           shrinkWrap: true,
//           padding: EdgeInsets.all(8),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 8.0,
//             mainAxisSpacing: 8.0,
//             childAspectRatio: 3 / 4,
//           ),
//           itemCount: 3,
//           itemBuilder: (context, int index) {
//             return Container(
//                 child: listChecker(index)
//                     ? Icon(Icons.check_circle,
//                         color: Theme.of(context)
//                             .textTheme
//                             .bodyText1
//                             .color
//                             .withOpacity(.125))
//                     : Icon(Icons.add_circle,
//                         color: Theme.of(context)
//                             .textTheme
//                             .bodyText1
//                             .color
//                             .withOpacity(.125)),
//                 decoration: BoxDecoration(
//                     color: Theme.of(context)
//                         .textTheme
//                         .bodyText1
//                         .color
//                         .withOpacity(.125),
//                     borderRadius: BorderRadius.all(Radius.circular(15))));
//           },
//         ));
//   }
// }
