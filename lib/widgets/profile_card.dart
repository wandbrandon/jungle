import 'dart:math';
import 'dart:ui';

//import 'package:extended_image/extended_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _ProfileCardState extends State<ProfileCard>
    with TickerProviderStateMixin {
  ScrollController _controller;
  final TransformationController _transformationController =
      TransformationController();
  Animation<Matrix4> _animationReset;
  AnimationController _controllerReset;

  String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }

  void _onAnimateReset() {
    _transformationController.value = _animationReset.value;
    if (!_controllerReset.isAnimating) {
      _animationReset?.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: _controllerReset, curve: Curves.easeOut));
    _animationReset.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

// Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    _animateResetInitialize();
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controllerReset = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _controllerReset.dispose();
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
                  index.type == 'bar' ? Icons.liquor : Icons.restaurant_sharp,
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
          Positioned.fill(
            child: Opacity(
              opacity: .05,
              child: ExtendedImage.asset(
                widget.user.gender == 'female'
                    ? 'lib/assets/toucangirl-600x600.jpg'
                    : 'lib/assets/tigerpattern-600x600.jpg',
                repeat: ImageRepeat.repeat,
                scale: widget.user.gender == 'female' ? 4 : 2,
                color: Theme.of(context).backgroundColor,
                colorBlendMode: BlendMode.saturation,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.zero,
            controller: ModalScrollController.of(context) ?? _controller,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.15),
                      blurRadius: 10,
                      spreadRadius: 2)
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(children: [
                    ExtendedImage.network(
                      widget.user.images[0],
                      height: widget.height,
                      width: double.infinity,
                      //cacheHeight: widget.height.toInt(),
                      cacheWidth: 600,
                      fit: BoxFit.cover,
                      //cache: true,
                    ),
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          showMaterialModalBottomSheet(
                              enableDrag: true,
                              backgroundColor: Colors.transparent,
                              barrierColor: Colors.black,
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: InteractiveViewer(
                                    panEnabled: false,
                                    //constrained: false,
                                    boundaryMargin:
                                        EdgeInsets.all(double.infinity),
                                    transformationController:
                                        _transformationController,
                                    minScale: .8,
                                    maxScale: 4,
                                    onInteractionStart: _onInteractionStart,
                                    onInteractionEnd: _onInteractionEnd,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: ExtendedImage.network(
                                        widget.user.images[0],
                                        clearMemoryCacheWhenDispose: true,
                                        enableMemoryCache: false,
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
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
                    ),
                    Positioned(
                        bottom: textPadding,
                        left: textPadding,
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${widget.user.name}, ${calculateAge(widget.user.birthday)}',
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
                  Container(
                    color: Theme.of(context).backgroundColor,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
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
                      ],
                    ),
                  ),
                  for (var image in widget.user.images.sublist(1))
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        showMaterialModalBottomSheet(
                            enableDrag: true,
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.black,
                            context: context,
                            builder: (context) {
                              return Center(
                                child: InteractiveViewer(
                                  panEnabled: false,
                                  //constrained: false,
                                  boundaryMargin:
                                      EdgeInsets.all(double.infinity),
                                  transformationController:
                                      _transformationController,
                                  minScale: .8,
                                  maxScale: 4,
                                  onInteractionStart: _onInteractionStart,
                                  onInteractionEnd: _onInteractionEnd,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: ExtendedImage.network(
                                      image,
                                      clearMemoryCacheWhenDispose: true,
                                      enableMemoryCache: false,
                                      //cache: true,
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: ExtendedImage.network(image,
                          cache: true, cacheWidth: 500, fit: BoxFit.cover),
                    ),
                ],
              ),
            ),
          ),
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
              Color(0xFF77ad39),
            ),
            backgroundColor: Colors.black.withOpacity(.08),
          ),
        ),
      ),
    );
  }
}
