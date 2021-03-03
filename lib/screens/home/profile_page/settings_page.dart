import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jungle/main.dart';
import 'package:jungle/screens/splash/splash_page.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: ListView(
          children: [
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Are you sure?'),
                          content: Text(
                              "We're sad to see you go, hopefully we can do better next time. \n\nRemember, you can always make a new account if you'd like"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                User currentUser = context.read<User>();
                                FirestoreService service =
                                    context.read<FirestoreService>();
                                await service.removeFiles(currentUser.uid);
                                await service.deleteUser(currentUser.uid);
                                await context
                                    .read<AuthenticationService>()
                                    .deleteCurrentUser();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SplashPage()),
                                    (r) => false);
                              },
                              child: Text('Delete'),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text('Cancel'),
                            ),
                          ],
                        ));
              },
              child: Ink(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Theme.of(context).backgroundColor),
                  child: Center(
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  )),
            )
          ],
        ));
  }
}
