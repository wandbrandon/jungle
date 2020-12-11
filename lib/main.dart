// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jungle/screens/home_screen.dart';
import 'package:jungle/screens/sign_in_page.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/theme.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jungle',
      debugShowCheckedModeBanner: false,
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      home: HomeScreen(),
    );
  }
}

// class AuthenticationWrapper extends StatelessWidget {
//   const AuthenticationWrapper({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User>();
//     return firebaseUser != null ? HomeScreen() : SignInPage();
//   }
// }
