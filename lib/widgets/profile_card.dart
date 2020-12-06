import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/models/models.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class ProfileCard extends StatelessWidget {
  final User user;

  const ProfileCard({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double textPadding = 25;
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      height: MediaQuery.of(context).size.height * .63,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(17.5)),
      ),
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            controller: ModalScrollController.of(context),
            padding: EdgeInsets.zero,
            children: [
              Stack(children: [
                Container(
                    height: MediaQuery.of(context).size.height * .63,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black, Colors.transparent]),
                      image: DecorationImage(
                          image: NetworkImage(user.imageUrl),
                          fit: BoxFit.cover),
                    )),
                Container(
                    height: MediaQuery.of(context).size.height * .63,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(.75),
                            Colors.transparent
                          ],
                          begin: FractionalOffset.bottomCenter,
                          end: FractionalOffset.center),
                    )),
                Container(
                    height: MediaQuery.of(context).size.height * .63,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(.30),
                            Colors.transparent
                          ],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.center),
                    )),
                Positioned(
                    bottom: textPadding,
                    left: textPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user.name}, ${user.age}',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 5,
                        ),
                        Text('${user.work}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      ],
                    )),
                Positioned(
                    top: textPadding,
                    left: textPadding,
                    child: Wrap(
                      spacing: 7.5,
                      children: [
                        Icon(Icons.offline_bolt_rounded,
                            color: Colors.white, size: 20),
                        Icon(Icons.outbond_rounded,
                            color: Colors.white, size: 20),
                        Icon(Icons.error_rounded,
                            color: Colors.white, size: 20),
                      ],
                    ))
              ]),
              Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.bio,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      Text('From: ${user.hometown}', style: TextStyle(color: Theme.of(context).accentColor),),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: textPadding,
            right: textPadding,
            child:
                CustomScrollBar(controller: ModalScrollController.of(context)),
          ),
        ],
      ),
    );
  }
}

class CustomScrollBar extends StatefulWidget {
  final ScrollController controller;

  CustomScrollBar({Key key, this.controller}) : super(key: key);

  @override
  _CustomScrollBarState createState() => _CustomScrollBarState();
}

class _CustomScrollBarState extends State<CustomScrollBar> {
  double position = 0;
  void _scrollListener() {
    setState(() {
      position = widget.controller.position.pixels /
          widget.controller.position.maxScrollExtent;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.addListener(_scrollListener);
    return Stack(
      children: [
        Container(
          height: 85,
          width: 4,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.50),
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        Positioned(
          top: position * 60,
          child: Container(
            height: 25,
            width: 4,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
      ],
    );
  }
}
