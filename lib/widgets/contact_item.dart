import 'package:flutter/material.dart';
import 'package:jungle/models/user_model.dart';
import 'package:jungle/widgets/profile_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ContactItem extends StatelessWidget {
  final User user;
  final double radius;
  const ContactItem({
    Key key,
    this.radius,
    this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(user.imageUrl),
        child: Material(
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
                onTap: () => {
                      showMaterialModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.black.withOpacity(.75),
                          //isScrollControlled: true,
                          //enableDrag: true,
                          context: context,
                          builder: (context) => ProfileCard(user: user))
                    })));
  }
}
