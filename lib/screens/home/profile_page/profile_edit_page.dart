import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/profile_page/image_settings.dart';

import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';

class ProfileEditPage extends StatefulWidget {
  final User currentUser;

  const ProfileEditPage({Key key, this.currentUser}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          FlatButton(
            textColor: Theme.of(context).accentColor,
            textTheme: ButtonTextTheme.normal,
            onPressed: () {
              Navigator.of(context).pop();
            }, child: Center(child: Text('Save', style: TextStyle(fontSize: 16)),
          )
          )
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
            maxlines: 4,
            about: 'About me',
            hint: "A little bit about you...",
          ),
          SizedBox(height: 8),
          EditorItem(
            maxlines: 1,
            about: 'Hometown',
            hint: "Where you're from...",
          ),
          SizedBox(height: 8),
          EditorItem(
            maxlines: 1,
            about: 'Living',
            hint: "Where you live...",
          ),
          SizedBox(height: 8),
          EditorItem(
            maxlines: 1,
            about: 'Education',
            hint: "Where you went to study...",
          ),
          SizedBox(height: 8),
          EditorItem(
            maxlines: 1,
            about: 'Work',
            hint: "Where you went to study...",
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class EditorItem extends StatefulWidget {
  final int maxlines;
  final String about;
  final String hint;

  const EditorItem({Key key, this.maxlines, this.about, this.hint})
      : super(key: key);

  @override
  _EditorItemState createState() => _EditorItemState();
}

class _EditorItemState extends State<EditorItem>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(widget.about, style: Theme.of(context).textTheme.caption),
        ),
        AnimatedSize(
          alignment: Alignment.topCenter,
          vsync: this,
          curve: Curves.easeOut,
          duration: Duration(milliseconds: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(150)],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hint,
              ),
              maxLines: widget.maxlines,
              minLines: (widget.maxlines / 2).round(),
              onSubmitted: (value) {
                print("$value!");
              },
            ),
          ),
        ),
      ],
    );
  }
}
