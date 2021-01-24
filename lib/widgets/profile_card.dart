import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatefulWidget {
  final UserModel user;
  final double height;

  const ProfileCard({Key key, this.user, this.height}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  ScrollController _controller;

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double textPadding = 25;
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor.withOpacity(.3),
      ),
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            controller: _controller,
            padding: EdgeInsets.zero,
            children: [
              Stack(children: [
                CachedNetworkImage(
                  imageUrl: widget.user.images[0],
                  imageBuilder: (context, imageProvider) => Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      CircularProgressIndicator.adaptive(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Colors.black.withOpacity(.4),
                          Colors.transparent,
                          Colors.black.withOpacity(.4)
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter))),
                Positioned(
                    bottom: textPadding,
                    left: textPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${widget.user.name}, ${widget.user.age}',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 5,
                        ),
                        widget.user.work == ''
                            ? SizedBox()
                            : Text('${widget.user.work}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                        widget.user.edu == ''
                            ? SizedBox()
                            : Text('${widget.user.edu}',
                                style: TextStyle(
                                    fontSize: 14,
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
              widget.user.bio == ''
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.all(25),
                      child: Text(
                        widget.user.bio,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      )),
              CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) =>
                    CircularProgressIndicator.adaptive(
                        value: progress.progress),
                imageUrl: widget.user.images[1],
              ),
              CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) =>
                    CircularProgressIndicator.adaptive(
                        value: progress.progress),
                imageUrl: widget.user.images[2],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomScrollBar extends StatefulWidget {
  CustomScrollBar({Key key}) : super(key: key);

  @override
  _CustomScrollBarState createState() => _CustomScrollBarState();
}

class _CustomScrollBarState extends State<CustomScrollBar> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ScrollController>();
    print(controller.offset);
    return Stack(
      children: [
        Positioned(
          top: controller.offset / controller.position.maxScrollExtent * 65,
          child: Container(
            height: 20,
            width: 4,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          height: 85,
          width: 4,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.33),
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ],
    );
  }
}
