import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/models/activity_model.dart';
import 'package:jungle/screens/home/home_screen.dart';
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
          print('found activity match, adding it to cart');
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
        StreamProvider<DocumentSnapshot>(catchError: (context, object) {
          print(object.toString());
          return null;
        }, create: (context) {
          final authchanged = context.read<AuthenticationService>();
          if (authchanged == null) {
            return null;
          }
          return authchanged.authStateChanges.transform(
            FlatMapStreamTransformer<User, DocumentSnapshot>(
              (firebaseUser) =>
                  firestoreService.getUserSnapshotStreamByAuth(firebaseUser),
            ),
          );
        }),
        FutureProvider<Map<String, List<Activity>>>(
            lazy: false,
            create: (context) => firestoreService.getAllActivities()),
        ChangeNotifierProxyProvider2<DocumentSnapshot,
                Map<String, List<Activity>>, ActivityState>(
            lazy: false,
            create: (_) => ActivityState(7),
            update: (_, myDoc, myMap, myActivityState) {
              myActivityState.set(activitiesFromDoc(myDoc, myMap));
              return myActivityState;
            }),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MaterialApp(
            title: 'Jungle',
            debugShowCheckedModeBanner: false,
            theme: kLightTheme,
            darkTheme: kDarkTheme,
            home: AuthenticationWrapper(),
            routes: {
              '/splash': (context) => SplashPage(),
            }),
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  User authUser;
  DocumentSnapshot dbUser;
  bool opacity = false;

  @override
  void initState() {
    super.initState();
    wait();
  }

  Future<void> wait() async {
    if (authUser == null) {
      print('waiting...');
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        opacity = !opacity;
      });
      await Future.delayed(Duration(milliseconds: 2400));
      print('done');
      Navigator.pushAndRemoveUntil(
          context, _createRoute(SplashPage()), (route) => false);
    }
    if (authUser == null) {
      Navigator.pushAndRemoveUntil(
          context, _createRoute(SplashPage()), (route) => false);
    } else if (!dbUser.exists && authUser != null) {
      Navigator.pushAndRemoveUntil(
          context, _createRoute(UserName()), (route) => false);
    } else if (dbUser != null && authUser != null)
      Navigator.pushAndRemoveUntil(
          context, _createRoute(HomeScreen()), (route) => false);
  }

  Route _createRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = 0.0;
        var end = 1.0;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(
          curve: curve,
        ));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget buildSplash() {
    return Material(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 2300),
        curve: Curves.ease,
        alignment: Alignment.center,
        color: opacity
            ? Theme.of(context).accentColor
            : Theme.of(context).highlightColor,
        child: AnimatedOpacity(
            opacity: opacity ? 1 : 0,
            duration: Duration(milliseconds: 2300),
            curve: Curves.ease,
            child: Image.asset(
              'lib/assets/artboard.png',
              height: 200,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    authUser = context.watch<User>();
    dbUser = context.watch<DocumentSnapshot>();
    return buildSplash();
  }
}
