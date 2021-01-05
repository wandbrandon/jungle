import 'package:flutter/material.dart';

class ProSettingItem extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;

  const ProSettingItem({
    Key key,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
      onTap: this.onTap,
      borderRadius: BorderRadius.circular(30),
      splashColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).primaryColor.withAlpha(150),
      child: Ink(
          height: MediaQuery.of(context).size.height * .15,
          width: MediaQuery.of(context).size.width * .875,
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Center(child: Text(text)),
          )),
    ));
  }
}
