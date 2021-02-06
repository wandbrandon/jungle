import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/user_model.dart';
import 'package:jungle/widgets/profile_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ContactItem extends StatelessWidget {
  final UserModel user;
  final double radius;
  const ContactItem({
    Key key,
    this.radius,
    this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheKey: user.images[0],
      imageUrl: user.images[0],
      imageBuilder: (context, image) => CircleAvatar(
          radius: radius,
          backgroundImage: image,
          child: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: InkWell(
                  onTap: () => {
                        showMaterialModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.black.withOpacity(.75),
                            animationCurve: Curves.ease,
                            duration: Duration(milliseconds: 300),
                            context: context,
                            builder: (context) => Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15, bottom: 45),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ProfileCard(
                                      modal: true,
                                      user: user,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .70,
                                      matches: [],
                                    ),
                                  ),
                                ))
                      }))),
    );
  }
}
