import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/screens/home/profile_page/profile_edit_page.dart';
import 'package:jungle/screens/splash/custom_loading.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/services/firestore_service.dart';
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
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: 
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
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            spreadRadius: 0,
                                            blurRadius: 2,
                                            offset: Offset(1, 2),
                                          )
                                        ],
                                      ),
                                      child: IconButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  fullscreenDialog: true,
                                                  builder: (context) =>
                                                      ProfileEditPage(currentUser: currentUserSnapshot ))),
                                          icon: Icon(Icons.edit),
                                          iconSize: 20),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: Text(currentUser.name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 15.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.place_outlined,
                                        size: 16, color: Colors.blue),
                                    SizedBox(width: 5),
                                    Text('${currentUser.age}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.blue),
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
                                    height: MediaQuery.of(context).size.height *
                                        .0625,
                                    width:
                                        MediaQuery.of(context).size.width * .50,
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    )),
                              )
                            ],
                          ),
                        ),
                  ),
                  Flexible(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 2),
                      children: [
                        SettingsItem(
                            icon: Icons.settings_outlined,
                            text: 'Settings',
                            onTap: () {
                              print('test');
                            }),
                        SizedBox(height: 15),
                        SettingsItem(
                            icon: Icons.history_outlined,
                            text: 'Purchase History',
                            onTap: () {
                              print('test');
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
