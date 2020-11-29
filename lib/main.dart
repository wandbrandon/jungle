import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/screens/home_screen.dart';
import 'package:flutter_chat_ui/widgets/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Jungle UI',
        debugShowCheckedModeBanner: false,
        theme: kLightTheme,
        home: HomeScreen());
  }
}
