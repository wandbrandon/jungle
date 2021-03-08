import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/discover_page/activity_page.dart';
import 'package:jungle/screens/home/discover_page/activity_state.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:like_button/like_button.dart';
import 'package:tap_builder/tap_builder.dart';

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
  ActivityState cart;

  Future<bool> onLikeButtonTapped(bool isLiked) async {
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
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    cart = context.watch<ActivityState>();
    selected = cart.getCart.contains(widget.activity);
    return GestureDetector(
      onTap: () {
        showBarModalBottomSheet(
            context: context,
            builder: (context) => ActivityPage(
                  activity: widget.activity,
                ));
      },
      child: Container(
        height: 225,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          key: ValueKey(widget.activity.aid),
          alignment: Alignment.bottomCenter,
          children: [
            Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.activity.images[0],
                  fit: BoxFit.cover,
                  memCacheHeight: 600,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withOpacity(.8),
                          Colors.transparent
                        ]),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.activity.name}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Text('${widget.activity.tag}, ${widget.activity.price}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.95),
                            fontSize: 16,
                          )),
                    ],
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.ease,
                    opacity: !(cart.atLimit && !selected) ? 1 : 0,
                    child: AbsorbPointer(
                      absorbing: (cart.atLimit && !selected),
                      child: LikeButton(
                        isLiked: selected,
                        size: 30,
                        likeCountPadding: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        onTap: onLikeButtonTapped,
                        likeBuilder: (bool isLiked) {
                          return Center(
                            child: Icon(
                              isLiked ? Ionicons.heart : Ionicons.heart_outline,
                              color: isLiked ? Colors.redAccent : Colors.white,
                              size: 30,
                            ),
                          );
                        },
                        circleColor:
                            CircleColor(start: Colors.white, end: Colors.red),
                        bubblesColor: BubblesColor(
                            dotPrimaryColor: Colors.red,
                            dotSecondaryColor: Colors.red[900]),
                      ),
                    ),
                  ),
                ],
              ),
            )
            // Positioned(
            //   top: 10,
            //   left: 10,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(15),
            //     child: BackdropFilter(
            //       filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            //       child: Container(
            //         alignment: Alignment.center,
            //         constraints: BoxConstraints(minWidth: 40),
            //         padding: const EdgeInsets.all(12),
            //         decoration: BoxDecoration(
            //           color: Theme.of(context).primaryColor.withOpacity(.4),
            //         ),
            //         child: Text(
            //           '${widget.activity.price}',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 20,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Positioned(
            //   bottom: 10,
            //   left: 10,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(15),
            //     child: BackdropFilter(
            //       filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            //       child: Container(
            //         alignment: Alignment.center,
            //         constraints: BoxConstraints(minWidth: 40),
            //         padding: const EdgeInsets.all(12),
            //         decoration: BoxDecoration(
            //           color: Theme.of(context).primaryColor.withOpacity(.4),
            //         ),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               '${widget.activity.name}',
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 16,
            //               ),
            //             ),
            //             Text('${widget.activity.tag}',
            //                 style: TextStyle(
            //                   color: Colors.white.withOpacity(.95),
            //                   fontSize: 14,
            //                 )),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Positioned(
            //   bottom: 10,
            //   right: 10,
            //   child: AnimatedOpacity(
            //     duration: const Duration(milliseconds: 400),
            //     curve: Curves.ease,
            //     opacity: !(cart.atLimit && !selected) ? 1 : 0,
            //     child: AbsorbPointer(
            //       absorbing: (cart.atLimit && !selected),
            //       child: ClipRRect(
            //           borderRadius: BorderRadius.circular(15),
            //           child: BackdropFilter(
            //               filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            //               child: AnimatedContainer(
            //                   duration: Duration(milliseconds: 400),
            //                   alignment: Alignment.center,
            //                   constraints: BoxConstraints(minWidth: 40),
            //                   padding: const EdgeInsets.all(16),
            //                   decoration: BoxDecoration(
            //                     color:
            //                         Theme.of(context).primaryColor.withOpacity(.4),
            //                   ),
            //                   child: LikeButton(
            //                     isLiked: selected,
            //                     size: 30,
            //                     likeCountPadding: EdgeInsets.zero,
            //                     padding: EdgeInsets.zero,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     onTap: onLikeButtonTapped,
            //                     likeBuilder: (bool isLiked) {
            //                       return Center(
            //                         child: Icon(
            //                           isLiked
            //                               ? Ionicons.heart
            //                               : Ionicons.heart_outline,
            //                           color:
            //                               isLiked ? Colors.redAccent : Colors.white,
            //                           size: 30,
            //                         ),
            //                       );
            //                     },
            //                     circleColor: CircleColor(
            //                         start: Colors.white, end: Colors.red),
            //                     bubblesColor: BubblesColor(
            //                         dotPrimaryColor: Colors.red,
            //                         dotSecondaryColor: Colors.red[900]),
            //                   )))),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
