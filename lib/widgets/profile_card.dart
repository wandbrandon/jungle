import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
//import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/models.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProfileCard extends StatefulWidget {
  final UserModel user;
  final double height;
  final List<Activity> matches;

  const ProfileCard({Key key, this.user, this.height, this.matches})
      : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget getList() {
    return Wrap(spacing: 4, runSpacing: 6, children: [
      for (var index in widget.matches)
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color:
                  Theme.of(context).textTheme.bodyText1.color.withOpacity(.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  index.type == 'bar'
                      ? Ionicons.beer_outline
                      : Ionicons.wine_outline,
                  size: 15,
                  color: Theme.of(context).backgroundColor,
                ),
                SizedBox(width: 7),
                Text(index.name,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).backgroundColor)),
              ],
            )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final double textPadding = 26;
    return Container(
      height: widget.height,
      color: Theme.of(context).backgroundColor,
      child: Stack(
        //alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
              padding: EdgeInsets.zero,
              controller: ModalScrollController.of(context) ?? _controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(children: [
                    CachedNetworkImage(
                      imageUrl: widget.user.images[0],
                      placeholder: (context, str) => Container(
                        color: Colors.black,
                      ),
                      height: widget.height,
                      memCacheHeight: (widget.height.round() * 1.4).round(),
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(.7),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center))),
                    ),
                    Positioned(
                        bottom: textPadding,
                        left: textPadding,
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.user.name}, ${widget.user.age}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 5,
                            ),
                            widget.user.work == ''
                                ? SizedBox()
                                : Text('${widget.user.work}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300)),
                            SizedBox(height: 2),
                            widget.user.edu == ''
                                ? SizedBox()
                                : Text('${widget.user.edu}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300)),
                          ],
                        )),
                  ]),
                  widget.user.bio == ''
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(
                              left: textPadding,
                              right: textPadding,
                              top: textPadding),
                          child: Text(
                            widget.user.bio,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                  SizedBox(
                    height: textPadding,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: textPadding,
                        right: textPadding,
                        bottom: textPadding),
                    child: getList(),
                  ),
                  Image.network(widget.user.images[1],
                      cacheHeight: 400, fit: BoxFit.cover),
                  Image.network(
                    widget.user.images[2],
                    cacheHeight: 400,
                    fit: BoxFit.cover,
                  ),
                ],
              )),
          Positioned(
              top: textPadding,
              right: textPadding,
              child: CustomScrollBar(
                  controller:
                      ModalScrollController.of(context) ?? _controller)),
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
  double scrollpercent = 0;

  _scrollListener() {
    setState(() {
      scrollpercent = widget.controller.position.pixels /
          widget.controller.position.maxScrollExtent;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (scrollpercent > 0) {
          HapticFeedback.lightImpact();
          widget.controller.animateTo(0,
              duration: Duration(milliseconds: 700), curve: Curves.easeInOut);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.15),
              spreadRadius: 2,
              blurRadius: 15,
              offset: Offset(-1, 3))
        ], color: Colors.white, shape: BoxShape.circle),
        child: SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(
            value: scrollpercent,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.black,
            ),
            backgroundColor: Colors.black.withOpacity(.1),
          ),
        ),
      ),
    );
  }
}
