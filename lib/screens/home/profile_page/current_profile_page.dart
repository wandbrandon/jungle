import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jungle/main.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:jungle/screens/home/discover_page/activity_state.dart';
import 'package:jungle/screens/home/profile_page/profile_edit_page.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/widgets/contact_item.dart';
import 'package:jungle/screens/home/profile_page/settings_item.dart';
import 'package:jungle/widgets/profile_card.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final currentUserSnapshot = context.watch<DocumentSnapshot>();
    final currentUser = models.UserModel?.fromJson(currentUserSnapshot?.data());
    final acts = context.watch<ActivityState>().getCart;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Your Profile'),
        ),
        body: SafeArea(
          child: currentUser != null
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: MediaQuery.of(context).size.width * .9,
                        height: MediaQuery.of(context).size.height * .60,
                        child: ProfileCard(
                            user: currentUser,
                            height: MediaQuery.of(context).size.height * .60,
                            matches: acts),
                      ),
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
                              context.read<AuthenticationService>().signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AuthenticationWrapper()),
                                  (route) => false);
                            } catch (e) {
                              print(e);
                            }
                          }),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator.adaptive()),
        ));
  }
}
