import 'package:flutter/material.dart';
import 'package:jungle/data/data.dart';
import 'package:jungle/models/models.dart';
import '../../../widgets/contact_item.dart';

class MatchQueue extends StatelessWidget {
  final List<User> users;

  const MatchQueue({Key key, this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Match Queue",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Theme.of(context).accentColor),
              ),
              Icon(Icons.more_horiz_rounded)
            ],
          )),
      Ink(
        height: MediaQuery.of(context).size.height * .175,
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) =>
              Padding(padding: EdgeInsets.symmetric(horizontal: 7.5)),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            String tempName = users[index].name;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: ContactItem(
                  user: users[index],
                  radius: 40,
                ),
              ),
              Text('$tempName'),
            ]);
          },
        ),
      ),
    ]);
  }
}
