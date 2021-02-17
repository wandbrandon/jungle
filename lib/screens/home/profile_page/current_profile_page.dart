import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/screens/home/profile_page/profile_edit_page.dart';
import 'package:jungle/screens/home/profile_page/settings_page.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/services/firestore_service.dart';
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
    if (currentUserSnapshot == null) {
      return Material(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Text(' Something happened, try again later. \nSorry about that.'),
        )),
      );
    }
    final currentUser = models.UserModel?.fromJson(currentUserSnapshot?.data());
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
                        icon: Ionicons.settings_outline,
                        text: 'Edit Profile',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileEditPage()));
                        }),
                    SizedBox(height: 15),
                    SettingsItem(
                        icon: Ionicons.log_out_outline,
                        text: 'Logout',
                        arrow: false,
                        onTap: () async {
                          try {
                            await context
                                .read<FirestoreService>()
                                .db
                                .collection('users')
                                .doc(currentUser.uid)
                                .update({'pushToken': null});

                            await context
                                .read<AuthenticationService>()
                                .signOut();

                            Navigator.pushNamedAndRemoveUntil(
                                context, '/splash', (route) => false);
                          } catch (e) {
                            print(e);
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
