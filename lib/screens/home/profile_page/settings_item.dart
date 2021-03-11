import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool arrow;
  final GestureTapCallback onTap;

  const SettingsItem({
    Key key,
    this.icon,
    this.arrow: true,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: this.onTap,
        borderRadius: BorderRadius.circular(15),
        splashColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).accentColor.withOpacity(.5),
        child: Ink(
            height: MediaQuery.of(context).size.height * .065,
            width: MediaQuery.of(context).size.width * .875,
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(this.icon, size: 25),
                      SizedBox(
                        width: 20,
                      ),
                      Text(this.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16))
                    ],
                  ),
                  arrow ? Icon(Ionicons.chevron_forward_outline) : SizedBox()
                ],
              ),
            )),
      ),
    );
  }
}
