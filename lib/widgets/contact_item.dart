import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/activity_model.dart';
import 'package:jungle/models/user_model.dart';
import 'package:jungle/widgets/profile_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ContactItem extends StatelessWidget {
  final UserModel user;
  final double radius;
  final List<Activity> matches;
  const ContactItem({
    Key key,
    this.radius,
    this.user,
    this.matches,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: user.images[0],
      height: radius * 2,
      width: radius * 2,
      placeholder: (context, string) => Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).backgroundColor),
      ),
      imageBuilder: (context, image) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
          height: radius * 2,
          width: radius * 2,
          child: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: InkWell(
                  onTap: () => {
                        showMaterialModalBottomSheet(
                            enableDrag: true,
                            bounce: true,
                            backgroundColor: Colors.transparent,
                            barrierColor: Colors.black.withOpacity(.80),
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
                                      user: user,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .75,
                                      matches: matches ?? [],
                                    ),
                                  ),
                                ))
                      }))),
    );
  }
}
