import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/models/models.dart';

class ActivityPage extends StatefulWidget {
  final Activity food;

  ActivityPage({this.food});
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.transparent),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Stack(children: <Widget>[
            Hero(
              tag: widget.food.images[0],
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.food.images[0]),
                          fit: BoxFit.cover))),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_rounded),
                    iconSize: 30.0,
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            )
          ]),
        ],
      ),
    ));
  }
}
