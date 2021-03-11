import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor/image_editor.dart' as editor;
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key key}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  Map<String, dynamic> tempUser;
  bool modified = false;

  @override
  initState() {
    tempUser = context.read<DocumentSnapshot>().data();

    super.initState();
  }

  void changeValue(String identifier, dynamic value) {
    setState(() {
      tempUser[identifier] = value;
      modified = true;
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
              actions: [
                TextButton(
                    onPressed: () async {
                      if (modified) {
                        await context.read<FirestoreService>().updateUserByUID(
                            tempUser['uid'], UserModel.fromJson(tempUser));
                      }
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text('Save',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).accentColor)),
                    ))
              ],
              elevation: 0,
            ),
            body: ListView(
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
                SizedBox(height: 10),
                EditorItem(
                    identifier: 'work',
                    maxlines: 1,
                    about: 'My personal information',
                    hint: "Add job",
                    icon: Icon(
                      Ionicons.briefcase_outline,
                      size: 18,
                    )),
                SizedBox(height: 10),
                EditorItem(
                  identifier: 'edu',
                  maxlines: 1,
                  about: null,
                  hint: "Add education",
                  icon: Icon(
                    Ionicons.school_outline,
                    size: 18,
                  ),
                ),
                SizedBox(height: 10),
                GenderPicker(),
                SizedBox(height: 10),
                LookingForPicker()
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
  final Icon icon;

  const EditorItem({
    Key key,
    this.maxlines,
    this.about,
    this.hint,
    this.identifier,
    this.icon,
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
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Theme(
            data: Theme.of(context).copyWith(
              // override textfield's icon color when selected
              accentColor: Theme.of(context).accentColor,
              primaryColor: Theme.of(context).accentColor,
            ),
            child: TextField(
              cursorColor: Theme.of(context).accentColor,
              controller: _controller,
              inputFormatters: [
                LengthLimitingTextInputFormatter(150),
              ],
              decoration: InputDecoration(
                icon: widget.icon,
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
                child: const Text(
                  'Male',
                ),
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Row(
            children: [
              Icon(
                gender == 'male'
                    ? Ionicons.male_outline
                    : gender == 'other'
                        ? Ionicons.male_female_outline
                        : Ionicons.female_outline,
                size: 18,
                color:
                    Theme.of(context).textTheme.bodyText1.color.withOpacity(.7),
              ),
              SizedBox(width: 16),
              Text(
                gender[0].toUpperCase() + gender.substring(1),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Spacer(),
              Icon(
                Ionicons.chevron_forward_outline,
                size: 18,
              )
            ],
          )),
    );
  }
}

class LookingForPicker extends StatefulWidget {
  @override
  _LookingForPickerState createState() => _LookingForPickerState();
}

class _LookingForPickerState extends State<LookingForPicker> {
  List<String> genders = ['male', 'female', 'other'];
  List<dynamic> pickedGenders = [];

  @override
  void initState() {
    pickedGenders = context.read<DocumentSnapshot>().data()['lookingFor'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 8),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Looking for',
                  style: Theme.of(context).textTheme.caption)),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var genderVal in genders)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (pickedGenders.contains(genderVal)) {
                          if (pickedGenders.length == 1) {
                            HapticFeedback.heavyImpact();
                            print('dude you can not remove em all');
                          } else {
                            HapticFeedback.selectionClick();
                            pickedGenders.remove(genderVal);
                            context
                                .read<_ProfileEditPageState>()
                                .changeValue('lookingFor', pickedGenders);
                          }
                        } else {
                          HapticFeedback.selectionClick();
                          pickedGenders.add(genderVal);
                          context
                              .read<_ProfileEditPageState>()
                              .changeValue('lookingFor', pickedGenders);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 6),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                          color: pickedGenders.contains(genderVal)
                              ? Theme.of(context).accentColor
                              : Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: AnimatedDefaultTextStyle(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            genderVal[0].toUpperCase() + genderVal.substring(1),
                          ),
                          style: pickedGenders.contains(genderVal)
                              ? TextStyle(color: Theme.of(context).primaryColor)
                              : TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color)),
                    ),
                  ),
              ],
            )),
      ],
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
  List<dynamic> urls = [null, null, null];
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  void initState() {
    urls = context.read<DocumentSnapshot>().data()['images'];
    while (urls.length != 3) {
      urls.add(null);
    }
    super.initState();
  }

  Future replaceImage(String imgUrl) async {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('Where would you like to get this image from?'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () async {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.gallery,
                        maxWidth: 650,
                        maxHeight: 650);
                    if (pickedFile == null) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                          context, await uploadImage(imgUrl, pickedFile));
                    }
                  },
                  child: Text('Gallery'),
                  textStyle: TextStyle(color: Theme.of(context).accentColor),
                ),
                CupertinoDialogAction(
                  onPressed: () async {
                    final pickedFile = await picker.getImage(
                        source: ImageSource.camera,
                        maxWidth: 650,
                        maxHeight: 650);
                    if (pickedFile == null) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                          context, await uploadImage(imgUrl, pickedFile));
                    }
                  },
                  child: Text('Camera'),
                  textStyle: TextStyle(color: Theme.of(context).accentColor),
                ),
              ],
            ));
  }

  Future<MaterialPageRoute> uploadImage(
      String imgUrl, PickedFile pickedFile) async {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('Crop Image'),
                elevation: 0,
                actions: [
                  TextButton(
                      onPressed: () async {
                        //Preliminary for cropped image in bytes
                        final Rect cropRect =
                            editorKey.currentState.getCropRect();
                        var img = editorKey.currentState.rawImageData;
                        editor.ImageEditorOption option =
                            editor.ImageEditorOption();
                        option.addOption(editor.ClipOption.fromRect(cropRect));

                        //Loading dialog
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => Container(
                                  child: CircularProgressIndicator.adaptive(),
                                ));

                        //Get actual image file
                        final result =
                            await editor.ImageEditor.editImageAndGetFile(
                          image: img,
                          imageEditorOption: option,
                        );

                        try {
                          if (imgUrl != null) {
                            await context
                                .read<FirestoreService>()
                                .storage
                                .refFromURL(imgUrl)
                                .delete();
                          }

                          //Attempt to upload and get that url.
                          final newImgUrl = await context
                              .read<FirestoreService>()
                              .uploadFile(
                                  result, '${context.read<User>().uid}');

                          //check if that image was there before, and delete it.

                          //get current UserModel
                          UserModel temp = UserModel.fromJson(
                              context.read<DocumentSnapshot>().data());

                          // get index of current image
                          int val = temp.images.indexOf(imgUrl);

                          // if it doesn't exist just add it in to temporary UserModel, otherwise just replace the index.
                          if (val < 0) {
                            temp.images.add(newImgUrl);
                            if (urls.length > 3) {
                              urls = urls.sublist(0, 3);
                            }
                          } else {
                            temp.images[val] = newImgUrl;
                          }

                          //update user
                          await context
                              .read<FirestoreService>()
                              .updateUserByUID(
                                  context
                                      .read<DocumentSnapshot>()
                                      .data()['uid'],
                                  temp);
                        } catch (e) {
                          print(e.toString());
                          print('not a success');
                        }
                        //pop loading, and pop cropping

                        setState(() {
                          urls =
                              context.read<DocumentSnapshot>().data()['images'];
                          while (urls.length != 3) {
                            urls.add(null);
                          }
                        });
                        var count = 0;
                        Navigator.popUntil(context, (route) {
                          return count++ == 2;
                        });
                      },
                      child: Text('Save',
                          style:
                              TextStyle(color: Theme.of(context).accentColor)))
                ],
              ),
              body: SafeArea(
                child: ExtendedImage.file(
                  File(pickedFile.path),
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.editor,
                  extendedImageEditorKey: editorKey,
                  initEditorConfigHandler: (state) {
                    return EditorConfig(
                      cornerColor: Theme.of(context).accentColor,
                      cornerSize: Size(40, 10),
                      lineColor: Theme.of(context).accentColor,
                      hitTestSize: 20.0,
                    );
                  },
                ),
              ),
            ));
  }

  void reorderData(int oldindex, int newindex) {
    if (urls[oldindex] != null && urls[newindex] != null) {
      setState(() {
        var item = urls.removeAt(oldindex);
        urls.insert(newindex, item);
      });
      context.read<_ProfileEditPageState>().changeValue(
          'images', urls.where((element) => element != null).toList());
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: ReorderableWrap(
              onReorder: reorderData,
              maxMainAxisCount: 3,
              spacing: 8,
              buildDraggableFeedback: (context, constraints, widget) =>
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.7),
                              blurRadius: 15,
                              spreadRadius: 1)
                        ]),
                    child: widget,
                  ),
              children: [
                for (var image in urls)
                  GestureDetector(
                      key: ValueKey(image),
                      onTap: () {
                        replaceImage(image);
                      },
                      child: image != null
                          ? ExtendedImage.network(
                              image,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.width * .42,
                              width: MediaQuery.of(context).size.width * .28,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).errorColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.width * .42,
                              width: MediaQuery.of(context).size.width * .28,
                              child: Icon(
                                Ionicons.add_circle,
                                size: 35,
                                color: Theme.of(context).primaryColor,
                              )))
              ]),
        ),
        SizedBox(height: 10),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    width: 1.2, color: Theme.of(context).backgroundColor)),
            child: Text(
              'Hold & drag your photos to change their order.',
              style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .color
                      .withOpacity(.7),
                  fontSize: 10),
            ),
          ),
        )
      ],
    );
  }
}
