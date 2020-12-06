import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/data/data.dart';
import 'package:flutter_chat_ui/widgets/contact_item.dart';
import 'package:flutter_chat_ui/widgets/profile_item.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<ProfileItem> profileItems = [
    ProfileItem(
        icon: Icons.settings_outlined,
        text: 'Settings',
        onTap: () {
          print('test');
        }),
    ProfileItem(
        icon: Icons.history_outlined,
        text: 'Purchase History',
        onTap: () {
          print('test');
        }),
    ProfileItem(
        icon: Icons.help_outline,
        text: 'Help and Support',
        onTap: () {
          print('test');
        }),
    ProfileItem(
        icon: Icons.logout,
        text: 'Logout',
        onTap: () {
          print('test');
        }),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.settings),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ContactItem(user: currentUser, radius: 60),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: Offset(1, 2),
                                  )
                                ],
                              ),
                              child: Icon(Icons.edit, size: 20),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(currentUser.name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          children: [
                            Icon(Icons.place_outlined,
                                size: 16, color: Colors.blue),
                            SizedBox(width: 5),
                            Text(currentUser.location,
                                style:
                                    TextStyle(fontSize: 15, color: Colors.blue),
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        splashColor: Colors.black,
                        highlightColor: Colors.black.withAlpha(100),
                        onTap: () {
                          print("pro tapped");
                        },
                        child: Ink(
                            height: MediaQuery.of(context).size.height * .0625,
                            width: MediaQuery.of(context).size.width * .50,
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(.5),
                                      blurRadius: 6.0,
                                      spreadRadius: 0.0)
                                ]),
                            child: Center(
                              child: Text('Upgrade to PRO',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                      )
                    ],
                  ),
                ),
                Icon(Icons.info)
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              padding: EdgeInsets.only(top: 2),
              separatorBuilder: (BuildContext context, int index) =>
                  Padding(padding: EdgeInsets.symmetric(vertical: 7.5)),
              itemCount: profileItems.length,
              itemBuilder: (context, index) => profileItems[index],
            ),
          )
        ],
      ),
    ));
  }
}
