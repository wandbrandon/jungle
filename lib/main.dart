import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  if (doc.data() == null || activityMap == null) {
    return activities;
  }
  List userActivitiesByAID = doc.data()['activities'] ?? [];
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
    final firestoreService = FirestoreService(FirebaseFirestore.instance,
        FirebaseStorage.instance, FirebaseMessaging());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance)),
        Provider<FirestoreService>.value(value: firestoreService),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges),
        StreamProvider<DocumentSnapshot>(catchError: (context, object) {
          print(object.toString() + 'Couldnt get user...');
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
            create: (context) => firestoreService.getAllActivities()),
        ChangeNotifierProxyProvider2<DocumentSnapshot,
                Map<String, List<Activity>>, ActivityState>(
            create: (_) => ActivityState(7),
            update: (_, myDoc, myMap, myActivityState) {
              if (myDoc == null || myMap == null || myActivityState == null) {
                return ActivityState(7);
              }
              myActivityState.set(activitiesFromDoc(myDoc, myMap));
              return myActivityState;
            }),
      ],
      child: MaterialApp(
          title: 'Jungle',
          debugShowCheckedModeBanner: false,
          theme: kLightTheme,
          darkTheme: kDarkTheme,
          home: AnnotatedRegion<SystemUiOverlayStyle>(
              value: Theme.of(context).brightness == Brightness.dark
                  ? SystemUiOverlayStyle.dark
                  : SystemUiOverlayStyle.light,
              child: AuthenticationWrapper()),
          routes: {
            '/splash': (context) => SplashPage(),
            '/home': (context) => HomeScreen(),
          }),
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
      await Future.delayed(Duration(milliseconds: 2500));
      print('done');
    }

    if (authUser == null) {
      Navigator.pushAndRemoveUntil(
          context, _createRoute(SplashPage()), (route) => false);
    } else if (dbUser != null && authUser != null) {
      if (!dbUser.exists && authUser != null) {
        Navigator.pushAndRemoveUntil(
            context, _createRoute(UserName()), (route) => false);
      } else {
        final firestore = context.read<FirestoreService>();
        final fbmessage = firestore.fbmessaging;
        await fbmessage.requestNotificationPermissions();
        String token = await fbmessage.getToken();
        print('token: $token');
        await firestore.db
            .collection('users')
            .doc(dbUser.data()['uid'])
            .update({'pushToken': token});

        Navigator.pushAndRemoveUntil(
            context, _createRoute(HomeScreen()), (route) => false);
      }
    }
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        child: Material(
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
                  color: Theme.of(context).primaryColor,
                )),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    authUser = context.watch<User>();
    dbUser = context.watch<DocumentSnapshot>();
    return buildSplash();
  }
}
