import 'package:flutter/material.dart';
import 'package:jungle/data/data.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'contact_item.dart';

class MatchQueue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Match Queue", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,  color: Theme.of(context).accentColor),), Icon(LineAwesomeIcons.ellipsis_h)],
          )),
      Ink(
        height: MediaQuery.of(context).size.height * .175,
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) =>
                  Padding(padding: EdgeInsets.symmetric(horizontal: 7.5)),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
          itemCount: favorites.length,
          itemBuilder: (BuildContext context, int index) {
              String tempName = favorites[index].name;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: ContactItem(user: favorites[index], radius: 40,),
              ),
              Text('$tempName'),
            ]);
          },
        ),
      ),
    ]);
  }
}
