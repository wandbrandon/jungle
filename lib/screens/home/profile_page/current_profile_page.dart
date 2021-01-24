import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/screens/home/profile_page/profile_edit_page.dart';
import 'package:jungle/screens/home/profile_page/settings_page.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/widgets/contact_item.dart';
import 'package:jungle/screens/home/profile_page/settings_item.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final currentUserSnapshot = context.watch<DocumentSnapshot>();
    final currentUser = models.UserModel.fromJson(currentUserSnapshot.data());
    return Scaffold(
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          elevation: 0,
          title: Text('Your Profile'),
        ),
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
                          fontSize: 15,
                          color: Theme.of(context).highlightColor),
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
                          showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => ProfileEditPage());
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
