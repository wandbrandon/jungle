import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/models/models.dart';

class FoodPage extends StatefulWidget {
  final Food food;

  FoodPage({this.food});
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
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
              Stack(
                children: <Widget>[
                  Hero(
                    tag: widget.food.imageUrls[0],
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                      image: DecorationImage (
                        image: NetworkImage(widget.food.imageUrls[0]),
                        fit: BoxFit.cover
                      )
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
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
                ]
              ),
              Align(
                alignment: Alignment.center,
                heightFactor: 0.5,
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30)
                  )
                ),
              )
            ],
          ),
      )
    );
  }
}
