import 'package:flutter/material.dart';

class ImageSetting extends StatefulWidget {
  final List<dynamic> images;

  const ImageSetting({Key key, this.images}) : super(key: key);

  @override
  _ImageSettingState createState() => _ImageSettingState();
}

class _ImageSettingState extends State<ImageSetting> {
  bool listChecker(int index) {
    if (widget.images.length - 1 < index) {
      return false;
    } else if (widget.images[index] == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //height: MediaQuery.of(context).size.height * .25,
        decoration: BoxDecoration(          
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Flexible(
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 3/4,
                ),
            itemCount: 3,
            itemBuilder: (context, int index) {
              return Container(
                  child: listChecker(index) ? Icon(Icons.check_circle, color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.125)) : Icon(Icons.add_circle, color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.125)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.125),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ));
            },
          ),
        ));
  }
}
