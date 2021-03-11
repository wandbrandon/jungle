import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/screens/splash/congrats_page.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:image_editor/image_editor.dart' as editor;

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
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  ImagePicker picker = ImagePicker();

  Future<MaterialPageRoute> uploadImage(
      int index, PickedFile pickedFile) async {
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

                        if (result != null) {
                          setState(() {
                            _images.removeAt(index);
                            _images.insert(index, result);
                            if (_images.length > 3) {
                              _images = _images.sublist(0, 3);
                            }
                            validate =
                                _images.any((element) => element != null);
                          });
                        } else {
                          print('No image selected.');
                        }

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
                    );
                  },
                ),
              ),
            ));
  }

  Future getImage(int index) async {
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
                          context, await uploadImage(index, pickedFile));
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
                          context, await uploadImage(index, pickedFile));
                    }
                  },
                  child: Text('Camera'),
                  textStyle: TextStyle(color: Theme.of(context).accentColor),
                ),
              ],
            ));
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

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            child: Column(
              children: [
                Text(
                  "Lastly, who's behind the screen?",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12.5),
                Text(
                  "Here at Jungle we believe three pictures is just enough information so you can spend more time meeting and less time swiping. \n\nMake those pictures count, ${widget.tempUser.name}!",
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 25),
                Center(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: ReorderableWrap(
                        buildDraggableFeedback: (context, constraints, widget) {
                          return Container(
                              child: widget,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.5),
                                        blurRadius: 15,
                                        spreadRadius: 2)
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))));
                        },
                        minMainAxisCount: 3,
                        onReorder: reorderData,
                        padding: EdgeInsets.all(10),
                        spacing: 10,
                        children: List<Widget>.generate(
                            _images.length,
                            (int index) => GestureDetector(
                                  onTap: () {
                                    getImage(index);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .23,
                                    height:
                                        MediaQuery.of(context).size.width * .30,
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
                                                image:
                                                    FileImage(_images[index]))
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
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Hold to drag and reorder.\nTap again to replace.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(.4)),
                ),
                Spacer(),
                GestureDetector(
                    onTap: validate
                        ? () async {
                            setState(() {
                              isTapped = false;
                              isLoading = true;
                            });

                            await context.read<FirestoreService>().createUser(
                                context.read<User>().uid, widget.tempUser);

                            await context.read<FirestoreService>().saveImages(
                                _images
                                    .where((element) => element != null)
                                    .toList(),
                                context.read<User>());

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

// class ImageSetting extends StatefulWidget {
//   const ImageSetting({Key key}) : super(key: key);

//   @override
//   _ImageSettingState createState() => _ImageSettingState();
// }

// class _ImageSettingState extends State<ImageSetting> {
//   final picker = ImagePicker();
//   List<dynamic> urls = [null, null, null];
//   final GlobalKey<ExtendedImageEditorState> editorKey =
//       GlobalKey<ExtendedImageEditorState>();

//   @override
//   void initState() {
//     urls = context.read<DocumentSnapshot>().data()['images'];
//     super.initState();
//   }

//   Future replaceImage(String imgUrl) async {
//     showDialog(
//         context: context,
//         builder: (context) => CupertinoAlertDialog(
//               title: Text('Where would you like to get this image from?'),
//               actions: [
//                 CupertinoDialogAction(
//                   onPressed: () async {
//                     final pickedFile = await picker.getImage(
//                         source: ImageSource.gallery,
//                         maxWidth: 650,
//                         maxHeight: 650);
//                     if (pickedFile == null) {
//                       Navigator.pop(context);
//                     } else {
//                       Navigator.pushReplacement(
//                           context, await uploadImage(imgUrl, pickedFile));
//                     }
//                   },
//                   child: Text('Gallery'),
//                   textStyle: TextStyle(color: Theme.of(context).accentColor),
//                 ),
//                 CupertinoDialogAction(
//                   onPressed: () async {
//                     final pickedFile = await picker.getImage(
//                         source: ImageSource.camera,
//                         maxWidth: 650,
//                         maxHeight: 650);
//                     if (pickedFile == null) {
//                       Navigator.pop(context);
//                     } else {
//                       Navigator.pushReplacement(
//                           context, await uploadImage(imgUrl, pickedFile));
//                     }
//                   },
//                   child: Text('Camera'),
//                   textStyle: TextStyle(color: Theme.of(context).accentColor),
//                 ),
//               ],
//             ));
//   }



//   void reorderData(int oldindex, int newindex) {
//     if (urls[oldindex] != null && urls[newindex] != null) {
//       setState(() {
//         var item = urls.removeAt(oldindex);
//         urls.insert(newindex, item);
//       });
//       context.read<_ProfileEditPageState>().changeValue(
//           'images', urls.where((element) => element != null).toList());
//     }
//     return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//               color: Theme.of(context).backgroundColor,
//               borderRadius: BorderRadius.all(Radius.circular(15))),
//           child: ReorderableWrap(
//               onReorder: reorderData,
//               maxMainAxisCount: 3,
//               spacing: 8,
//               buildDraggableFeedback: (context, constraints, widget) =>
//                   Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(12)),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black.withOpacity(.7),
//                               blurRadius: 15,
//                               spreadRadius: 1)
//                         ]),
//                     child: widget,
//                   ),
//               children: [
//                 for (var image in urls)
//                   GestureDetector(
//                       key: ValueKey(image),
//                       onTap: () {
//                         replaceImage(image);
//                       },
//                       child: image != null
//                           ? ExtendedImage.network(
//                               image,
//                               shape: BoxShape.rectangle,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(12)),
//                               fit: BoxFit.cover,
//                               height: MediaQuery.of(context).size.width * .42,
//                               width: MediaQuery.of(context).size.width * .28,
//                             )
//                           : Container(
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).errorColor,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(12)),
//                               ),
//                               alignment: Alignment.center,
//                               height: MediaQuery.of(context).size.width * .42,
//                               width: MediaQuery.of(context).size.width * .28,
//                               child: Icon(
//                                 Ionicons.add_circle,
//                                 size: 35,
//                                 color: Theme.of(context).primaryColor,
//                               )))
//               ]),
//         ),
//         SizedBox(height: 10),
//         Center(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(
//                     width: 1.2, color: Theme.of(context).backgroundColor)),
//             child: Text(
//               'Hold & drag your photos to change their order.',
//               style: TextStyle(
//                   color: Theme.of(context)
//                       .textTheme
//                       .bodyText1
//                       .color
//                       .withOpacity(.7),
//                   fontSize: 10),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
