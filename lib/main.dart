import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/screens/home/home_screen.dart';
import 'package:jungle/screens/splash/splash_page.dart';
import 'package:jungle/screens/splash/user_name.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/theme.dart';
import 'package:jungle/models/models.dart' as models;
import 'package:provider/provider.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges),
        Provider<FirestoreService>(
            create: (_) => FirestoreService(FirebaseFirestore.instance)),
        StreamProvider<models.User>(create: (context) => context.read<FirestoreService>().getUserByAuth(context.read<User>()))
      ],
      child: MaterialApp(
        title: 'Jungle',
        debugShowCheckedModeBanner: false,
        theme: kLightTheme,
        darkTheme: kDarkTheme,
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<User>();
    final storeUser = context.watch<models.User>();
    if (authUser == null) {
      return SplashPage();
    } else {
      if (storeUser == null) {
        return UserName();
      } else {
        return HomeScreen();
      }
    }
  }
}
