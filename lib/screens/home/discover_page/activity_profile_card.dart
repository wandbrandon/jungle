import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/discover_page/activity_page.dart';
import 'package:jungle/screens/home/discover_page/activity_state.dart';
import 'package:provider/provider.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:shimmer/shimmer.dart';

class ActivityProfileCard extends StatefulWidget {
  final Activity activity;

  const ActivityProfileCard({
    Key key,
    this.activity,
  }) : super(key: key);

  @override
  _ActivityProfileCardState createState() => _ActivityProfileCardState();
}

class _ActivityProfileCardState extends State<ActivityProfileCard> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<ActivityState>();
    selected = cart.getCart.contains(widget.activity);
    return AnimatedContainer(
      key: ValueKey(widget.activity.aid),
      duration: Duration(milliseconds: 25),
      curve: Curves.ease,
      child: Stack(
        children: [
          CachedNetworkImage(
            cacheKey: widget.activity.images[0],
            imageUrl: widget.activity.images[0],
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(.9),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(.5),
                      ],
                      stops: [0, 0.5, 0.8, 1],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                )
              ],
            ),
            placeholder: (context, url) => Shimmer.fromColors(
                child: Container(),
                baseColor: Colors.black,
                highlightColor: Theme.of(context).accentColor),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          // Positioned(
          //   top: 15,
          //   left: 15,
          //   child: Text(
          //     '${widget.activity.price}',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 20,
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 15,
            left: 15,
            child: Text(
              '${widget.activity.tag}',
              style: TextStyle(
                color: Colors.white.withOpacity(.90),
                fontSize: 14,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 15,
            child: Text(
              '${widget.activity.name}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
              top: 15,
              right: 15,
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black, spreadRadius: 1, blurRadius: 30)
                ]),
                child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.ease,
                    opacity: !(cart.atLimit && !selected) ? 1 : 0,
                    child: AbsorbPointer(
                        absorbing: (cart.atLimit && !selected),
                        child: GestureDetector(
                          child: AnimatedSwitcher(
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            duration: Duration(milliseconds: 100),
                            child: !selected
                                ? Icon(
                                    Ionicons.bookmark_outline,
                                    key: ValueKey(Ionicons.bookmark_outline),
                                    color: Colors.white,
                                    size: 26,
                                  )
                                : Icon(
                                    Ionicons.bookmark,
                                    key: ValueKey(Ionicons.bookmark),
                                    color: Colors.white,
                                    size: 26,
                                  ),
                          ),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              selected = !selected;
                              if (selected) {
                                if (!cart.addToCart(widget.activity)) {
                                  selected = false;
                                  print("Cant go over the limit!");
                                } else {}
                              } else if (!selected) {
                                cart.removeFromCart(widget.activity);
                              }
                              print(cart.getCart);
                            });
                          },
                        ))),
              )),
          // Positioned(
          //   top: 15,
          //   right: 15,
          //   child: AnimatedOpacity(
          //     duration: const Duration(milliseconds: 300),
          //     curve: Curves.ease,
          //     opacity: !(cart.atLimit && !selected) ? 1 : 0,
          //     child: AbsorbPointer(
          //       absorbing: (cart.atLimit && !selected),
          //       child: GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             selected = !selected;

          //             if (selected) {
          //               if (!cart.addToCart(widget.activity)) {
          //                 selected = false;
          //                 print("Cant go over the limit!");
          //               } else {}
          //             } else if (!selected) {
          //               cart.removeFromCart(widget.activity);
          //             }
          //             print(cart.getCart);
          //           });
          //         },
          //         child: AnimatedContainer(
          //             curve: Curves.easeInOutBack,
          //             transformAlignment: Alignment.center,
          //             transform: selected
          //                 ? Matrix4.rotationZ(-pi / 4)
          //                 : Matrix4.rotationZ(0),
          //             duration: Duration(milliseconds: 300),
          //             decoration: BoxDecoration(
          //                 boxShadow: [
          //                   BoxShadow(
          //                     blurRadius: 8,
          //                     color: Colors.black.withOpacity(.3),
          //                     spreadRadius: 2,
          //                   )
          //                 ],
          //                 borderRadius: BorderRadius.circular(20),
          //                 color: Colors.white),
          //             child: Padding(
          //                 padding: EdgeInsets.all(7),
          //                 child: Icon(
          //                   Icons.add_rounded,
          //                   size: 23,
          //                   color:
          //                       !selected ? Colors.black : Colors.red,
          //                 ))),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
