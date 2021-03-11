import 'package:extended_image/extended_image.dart';
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
    return Stack(
      fit: StackFit.loose,
      children: [
        ExtendedImage.network(
          user.images[0],
          cacheWidth: 200,
          shape: BoxShape.circle,
          fit: BoxFit.cover,
          height: radius * 2,
          width: radius * 2,
          enableLoadState: true,
          loadStateChanged: (state) {
            return AnimatedOpacity(
                opacity:
                    state.extendedImageLoadState == LoadState.completed ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  fit: BoxFit.cover,
                ));
          },
        ),
        Positioned.fill(
          child: ClipOval(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Theme.of(context).backgroundColor,
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
                                  borderRadius: BorderRadius.circular(20)),
                              child: ProfileCard(
                                user: user,
                                height:
                                    MediaQuery.of(context).size.height * .75,
                                matches: matches ?? [],
                              ),
                            ),
                          ))
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
