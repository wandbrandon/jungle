import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatefulWidget {
  final UserModel user;
  final double height;
  final List<Activity> matches;
  final bool modal;

  const ProfileCard({Key key, this.user, this.height, this.matches, this.modal})
      : super(key: key);

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

  List<Widget> getList() {
    return List<Widget>.generate(
        widget.matches.length,
        (index) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).accentColor, width: 1),
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).accentColor.withOpacity(.15),
            ),
            child: Text(widget.matches[index].name)));
  }

  @override
  Widget build(BuildContext context) {
    final double textPadding = 25;
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            controller:
                !widget.modal ? _controller : ModalScrollController.of(context),
            padding: EdgeInsets.zero,
            children: [
              Stack(children: [
                CachedNetworkImage(
                  cacheKey: widget.user.images[0],
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
                      Center(child: CircularProgressIndicator.adaptive()),
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
                // Positioned(
                //     top: textPadding,
                //     left: textPadding,
                //     child: Wrap(
                //       spacing: 7.5,
                //       children: [
                //         Icon(Icons.offline_bolt_rounded,
                //             color: Colors.white, size: 20),
                //         Icon(Icons.outbond_rounded,
                //             color: Colors.white, size: 20),
                //         Icon(Icons.error_rounded,
                //             color: Colors.white, size: 20),
                //       ],
                //     ))
              ]),
              widget.user.bio == ''
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.all(textPadding),
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
              Padding(
                padding: EdgeInsets.all(textPadding),
                child: Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 12.0, // gap between lines

                  children: getList(),
                ),
              )
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
