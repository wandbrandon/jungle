import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final GestureTapCallback onTap;

  const ProfileItem({
    Key key,
    this.icon,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: this.onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).accentColor.withAlpha(150),
        child: Ink(
            height: MediaQuery.of(context).size.height * .070,
            width: MediaQuery.of(context).size.width * .875,
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(this.icon, size: 25),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .05,
                      ),
                      Text(this.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16))
                    ],
                  ),
                  Icon(Icons.navigate_next)
                ],
              ),
            )),
      ),
    );
  }
}
