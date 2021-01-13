import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/screens/home/profile_page/pro_setting_item.dart';
import 'package:jungle/screens/home/profile_page/profile_edit_page.dart';
import 'package:jungle/screens/home/profile_page/settings_page.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/widgets/contact_item.dart';
import 'package:jungle/screens/home/profile_page/settings_item.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final currentUserSnapshot = context.watch<DocumentSnapshot>();
    final currentUser = models.User.fromJson(currentUserSnapshot.data());
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(height: 25),
          ContactItem(user: currentUser, radius: 70),
          SizedBox(height: 15),
          Text('${currentUser.name}, ${currentUser.age}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.place_outlined,
                  size: 16, color: Theme.of(context).highlightColor),
              SizedBox(width: 5),
              Text('Gainesville, Florida',
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).highlightColor),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          SizedBox(height: 15),
          Flexible(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                // ProSettingItem(
                //   text: 'Pro settings here!',
                //   onTap: () => print('test'),
                // ),
                SizedBox(height: 15),
                SettingsItem(
                    icon: Icons.face_outlined,
                    text: 'Edit Profile',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => ProfileEditPage(
                                currentUser: currentUserSnapshot,
                              )));
                    }),
                SizedBox(height: 15),
                SettingsItem(
                    icon: Icons.settings_outlined,
                    text: 'Settings',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SettingsPage()));
                    }),
                SizedBox(height: 15),
                SettingsItem(
                    icon: Icons.help_outline,
                    text: 'Help and Support',
                    onTap: () {
                      print('test');
                    }),
                SizedBox(height: 15),
                SettingsItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    arrow: false,
                    onTap: () {
                      context.read<AuthenticationService>().signOut();
                    }),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
