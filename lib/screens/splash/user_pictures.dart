import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/screens/splash/congrats_page.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';

class UserPictures extends StatefulWidget {
  final models.UserModel tempUser;
  UserPictures({Key key, this.tempUser}) : super(key: key);

  @override
  _UserPicturesState createState() => _UserPicturesState();
}

class _UserPicturesState extends State<UserPictures> {
  bool isTapped = false;
  List<File> _images = [null, null, null];
  bool validate = false;
  bool isLoading = false;

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

  Future getImage(int index) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery
    showLoaderDialog(context);
    pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 15);
    Navigator.pop(context);
    setState(() {
      if (pickedFile != null) {
        _images.removeAt(index);
        _images.insert(index, File(pickedFile.path));
        validate = (!(_images.contains(null)) && _images.length == 3);
      } else {
        print('No image selected.');
      }
    });
  }

  void reorderData(int oldindex, int newindex) {
    if (_images[oldindex] != null || _images[newindex] != null) {
      setState(() {
        var item = _images.removeAt(oldindex);
        _images.insert(newindex, item);
      });
    }
    return;
  }

  void removeImages() {
    setState(() {
      _images.clear();
      validate = _images.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
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
                      "Lastly, who's behind the screen?",
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12.5),
                    Text(
                      "Here at Jungle we believe three pictures is just enough information so you can spend more time meeting and less time swiping. Make those pictures count, ${widget.tempUser.name}!",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: ReorderableWrap(
                            onReorder: reorderData,
                            maxMainAxisCount: 3,
                            spacing: 10,
                            padding: EdgeInsets.all(10),
                            children: List<Widget>.generate(
                                _images.length,
                                (int index) => GestureDetector(
                                      onTap: () {
                                        getImage(index);
                                      },
                                      child: Container(
                                        width: 3 * 31.0,
                                        height: 4 * 31.0,
                                        child: _images[index] == null
                                            ? Center(
                                                child: Icon(
                                                Icons.add_circle_rounded,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color
                                                    .withOpacity(.3),
                                              ))
                                            : null,
                                        decoration: BoxDecoration(
                                            image: _images[index] != null
                                                ? DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(
                                                        _images[index]))
                                                : null,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .color
                                                .withOpacity(.1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4))),
                                      ),
                                    )),
                          )),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Hold to drag and reorder.\nTap again to replace.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: validate
                        ? () async {
                            setState(() {
                              isTapped = false;
                              isLoading = true;
                            });

                            await context.read<FirestoreService>().createUser(
                                context.read<User>().uid, widget.tempUser);

                            await context
                                .read<FirestoreService>()
                                .saveImages(_images, context.read<User>());

                            setState(() {
                              isLoading = false;
                            });

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CongratsPage()),
                                (r) => false);
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
                              child: !isLoading
                                  ? Text('CREATE ACCOUNT',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor))
                                  : SizedBox(
                                      height: 12,
                                      width: 12,
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor,
                                      )),
                                    ))),
                    ))
              ],
            )),
      ),
    );
  }
}
