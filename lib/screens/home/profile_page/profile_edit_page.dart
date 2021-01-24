import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key key}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  Map<String, dynamic> tempUser;

  @override
  initState() {
    tempUser = context.read<DocumentSnapshot>().data();
    super.initState();
  }

  void changeValue(String identifier, dynamic value) {
    setState(() {
      tempUser[identifier] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<DocumentSnapshot>.value(
        value: context.watch<DocumentSnapshot>(),
        child: Provider.value(
          value: this,
          builder: (context, child) => Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
              backgroundColor: Theme.of(context).backgroundColor,
              actions: [
                FlatButton(
                    textColor: Theme.of(context).accentColor,
                    textTheme: ButtonTextTheme.normal,
                    onPressed: () async {
                      await context.read<FirestoreService>().updateUserByAuth(
                          context.read<User>(),
                          models.UserModel.fromJson(tempUser));
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
                ImageSetting(),
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

class ImageSetting extends StatefulWidget {
  const ImageSetting({Key key}) : super(key: key);

  @override
  _ImageSettingState createState() => _ImageSettingState();
}

class _ImageSettingState extends State<ImageSetting> {
  final picker = ImagePicker();
  bool isLoading = false;
  List<dynamic> urls;

  @override
  void initState() {
    urls = context.read<DocumentSnapshot>().data()['images'];
    super.initState();
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: CircularProgressIndicator.adaptive(),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future replaceImage(int index) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 15);
    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
      await context
          .read<FirestoreService>()
          .storage
          .refFromURL(urls[index])
          .delete();
      urls[index] = await context
          .read<FirestoreService>()
          .uploadFile(File(pickedFile.path), '${context.read<User>().uid}');
      setState(() {
        isLoading = false;
      });
    } else {
      print('No image selected.');
      context.read<_ProfileEditPageState>().changeValue('images', urls);
    }
  }

  void reorderData(int oldindex, int newindex) {
    if (urls[oldindex] != null || urls[newindex] != null) {
      setState(() {
        var item = urls.removeAt(oldindex);
        urls.insert(newindex, item);
      });
      context.read<_ProfileEditPageState>().changeValue('images', urls);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: ReorderableWrap(
                onReorder: reorderData,
                maxMainAxisCount: 3,
                spacing: 10,
                padding: EdgeInsets.all(10),
                children: List<Widget>.generate(
                    urls.length,
                    (int index) => GestureDetector(
                          onTap: () {
                            replaceImage(index);
                          },
                          child: CachedNetworkImage(
                            imageUrl: urls[index],
                            imageBuilder: (context, imageProvider) => Container(
                                width: 3 * 37.0,
                                height: 4 * 37.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: imageProvider),
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color
                                        .withOpacity(.1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)))),
                            placeholder: (context, url) =>
                                CircularProgressIndicator.adaptive(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )),
              )),
          SizedBox(height: 10),
          Text(
            'Hold to drag and reorder.',
            style: TextStyle(
                color:
                    Theme.of(context).textTheme.bodyText1.color.withOpacity(.7),
                fontSize: 10),
          )
        ],
      ),
    );
  }
}
