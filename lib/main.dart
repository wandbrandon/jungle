import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/screens/home/home_screen.dart';
import 'package:jungle/screens/splash/custom_loading.dart';
import 'package:jungle/screens/splash/splash_page.dart';
import 'package:jungle/screens/splash/user_name.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/theme.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarIconBrightness: Theme.of(context).brightness,
          statusBarBrightness: Theme.of(context).brightness,
          statusBarColor: Colors.transparent),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges),
        Provider<FirestoreService>(
            create: (_) => FirestoreService(FirebaseFirestore.instance)),
      ],
      child: MaterialApp(
          title: 'Jungle',
          debugShowCheckedModeBanner: false,
          theme: kLightTheme,
          darkTheme: kDarkTheme,
          home: AuthenticationWrapper(),
          routes: {
            '/splash': (context) => SplashPage(),
          }),
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
    if (authUser == null) {
      return SplashPage();
    }
    return MultiProvider(
      providers: [
        StreamProvider<DocumentSnapshot>(
            create: (_) => context
                .read<FirestoreService>()
                .getUserSnapshotStreamByAuth(context.read<User>()))
      ],
      builder: (context, child) {
        if (context.watch<DocumentSnapshot>() == null) return UserName();
        return HomeScreen();
      },
    );
  }
}

// Widget build(BuildContext context) {
//     final authUser = context.watch<User>();
//     final isUserCreated =
//         context.watch<FirestoreService>().userExistsByAuth(authUser);
//     return FutureBuilder(
//       future: isUserCreated,
//       builder: (context, snapshot) {
//         if (authUser == null) {
//           return SplashPage();
//         }
//         if (snapshot.connectionState != ConnectionState.done) {
//           return CustomLoading();
//         } else if (snapshot.connectionState == ConnectionState.done) {
//           if (!snapshot.data) return UserName();
//         }
//         return HomeScreen();
//       },
//     );
//   }
