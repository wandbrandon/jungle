import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfileCard extends StatefulWidget {
  final User user;

  const ProfileCard({Key key, this.user}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  ScrollController scrollController;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalScrollController.of(context) == null) {
      scrollController = ScrollController();
    } else {
      scrollController = ModalScrollController.of(context);
    }
    final double textPadding = 25;
    return Container(
      clipBehavior: Clip.antiAlias,
      height: MediaQuery.of(context).size.height * .63,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              Stack(children: [
                CachedNetworkImage(
                  imageUrl: widget.user.images[0],
                  imageBuilder: (context, imageProvider) => Container(
                    height: MediaQuery.of(context).size.height * .63,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * .63,
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
                    CircularProgressIndicator(value: progress.progress),
                imageUrl: widget.user.images[1],
              ),
              CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) =>
                    CircularProgressIndicator(value: progress.progress),
                imageUrl: widget.user.images[2],
              ),
              Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.user.from != ''
                        ? Text(
                            'From ${widget.user.from}',
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          )
                        : SizedBox(),
                    SizedBox(height: 10),
                    widget.user.live != ''
                        ? Text(
                            'Lives in ${widget.user.live}',
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              top: textPadding,
              right: textPadding,
              child: CustomScrollBar(controller: scrollController)),
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
  double maxScroll = 1;

  @override
  void initState() {
    widget.controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    setState(() {
      position = widget.controller.offset;
      maxScroll = widget.controller.position.maxScrollExtent;
    });
  }

  @override
  Widget build(BuildContext context) {
    double newpos = position / maxScroll;
    return Stack(
      children: [
        Positioned(
          top: newpos * 65,
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
