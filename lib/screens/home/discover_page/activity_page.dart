import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/models/models.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ActivityPage extends StatefulWidget {
  final Activity activity;

  ActivityPage({this.activity});
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.transparent),
      child: Scaffold(
          body: CustomScrollView(
        controller: ModalScrollController.of(context),
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.activity.name,
                  style: TextStyle(color: Colors.white)),
              background: Container(
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: CachedNetworkImage(
                    imageUrl: widget.activity.images[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.black,
            expandedHeight: 400,
            elevation: 4,
            pinned: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Text('test', style: TextStyle(fontSize: 80)),
              Text('test', style: TextStyle(fontSize: 80)),
              Text('test', style: TextStyle(fontSize: 80)),
              Text('test', style: TextStyle(fontSize: 80)),
              Text('test', style: TextStyle(fontSize: 80)),
              Text('test', style: TextStyle(fontSize: 80)),
              Text('test', style: TextStyle(fontSize: 80)),
            ])),
          )
        ],
      )),
    );
  }
}
