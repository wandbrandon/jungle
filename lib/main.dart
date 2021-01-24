import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/models/activity_model.dart';
import 'package:jungle/screens/home/home_screen.dart';
import 'package:jungle/screens/splash/custom_loading.dart';
import 'package:jungle/screens/splash/splash_page.dart';
import 'package:jungle/screens/splash/user_name.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/theme.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'screens/home/discover_page/activity_state.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

List<Activity> activitiesFromDoc(
    DocumentSnapshot doc, Map<String, List<Activity>> activityMap) {
  List<Activity> activities = new List<Activity>.empty(growable: true);
  if (doc == null) {
    return activities;
  }
  if (activityMap == null) {
    return activities;
  }
  List userActivitiesByAID = doc.data()['activities'];
  userActivitiesByAID.forEach((userAID) {
    activityMap.forEach((key, value) {
      value.forEach((element) {
        if (element.aid == userAID) {
          print('found one!');
          activities.add(element);
        }
      });
    });
  });
  return activities;
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
    final firestoreService =
        FirestoreService(FirebaseFirestore.instance, FirebaseStorage.instance);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        Provider<FirestoreService>.value(value: firestoreService),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges),
        StreamProvider<DocumentSnapshot>(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges.transform(
                    FlatMapStreamTransformer<User, DocumentSnapshot>(
                      (firebaseUser) => firestoreService
                          .getUserSnapshotStreamByAuth(firebaseUser),
                    ),
                  ),
        ),
        FutureProvider<Map<String, List<Activity>>>(
            create: (context) => firestoreService.getAllActivities()),
        ChangeNotifierProxyProvider2<DocumentSnapshot,
                Map<String, List<Activity>>, ActivityState>(
            create: (_) => ActivityState(10),
            update: (_, myDoc, myMap, myActivityState) {
              myActivityState.set(activitiesFromDoc(myDoc, myMap));
              return myActivityState;
            }),
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
    final dbUser = context.watch<DocumentSnapshot>();
    if (authUser == null) {
      return SplashPage();
    } else if (dbUser == null) {
      return CustomLoading();
    } else if (!dbUser.exists) {
      return UserName();
    }
    return HomeScreen();
  }
}
