import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';

class ImageSetting extends StatefulWidget {
  final List<dynamic> images;

  const ImageSetting({Key key, this.images}) : super(key: key);

  @override
  _ImageSettingState createState() => _ImageSettingState();
}

class _ImageSettingState extends State<ImageSetting> {
  final picker = ImagePicker();
  File _image;

  List<Widget> widgetImages;

  @override
  void initState() {
    widgetImages = List<Widget>.generate(
        widget.images.length,
        (int index) => Container(
            width: 3 * 31.0,
            height: 4 * 31.0,
            decoration: BoxDecoration(
                color: Color(0xFF7cb342).withOpacity(.5),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: listChecker(index)
                ? Icon(Icons.check_circle, color: Colors.black)
                : Icon(Icons.add_circle, color: Colors.black)));
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      Widget item = widgetImages.removeAt(oldindex);
      widgetImages.insert(newindex, item);
    });
  }

  bool listChecker(int i) {
    if (widget.images.length - 1 < i) {
      return false;
    } else if (widget.images[i] == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: ReorderableWrap(
              onReorder: reorderData,
              children: widgetImages,
              maxMainAxisCount: 3,
              spacing: 10,
              padding: EdgeInsets.all(10),
              footer: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .color
                              .withOpacity(.1),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        'Hold to drag and reorder.',
                        style: Theme.of(context).textTheme.caption,
                      )),
                ),
              ))),
    );
  }
}
