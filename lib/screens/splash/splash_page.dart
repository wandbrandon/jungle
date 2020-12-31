import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sinusoidals/flutter_sinusoidals.dart';
import 'package:jungle/screens/splash/sign_in_num.dart';
import 'package:tap_builder/tap_builder.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    int ms = 500;
    return ShaderMask(
      blendMode: Theme.of(context).brightness == Brightness.dark
          ? BlendMode.multiply
          : BlendMode.screen,
      shaderCallback: (bounds) => LinearGradient(colors: [
        Theme.of(context).accentColor,
        Theme.of(context).highlightColor
      ]).createShader(bounds),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).textTheme.bodyText1.color,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: CombinedWave(
                  reverse: false,
                  models: const [
                    SinusoidalModel(
                      amplitude: 10,
                      waves: 3,
                      translate: 2.5,
                      frequency: 0.5,
                    ),
                    SinusoidalModel(
                      amplitude: 5,
                      waves: 3,
                      translate: 7.5,
                      frequency: 1.0,
                    ),
                    SinusoidalModel(
                      amplitude: 20,
                      waves: 1,
                      translate: 0,
                      frequency: 0.5,
                    ),
                  ],
                  child: Container(
                    height: MediaQuery.of(context).size.height * .43,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * .025,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * .79,
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color),
                                children: [
                                  TextSpan(
                                      text:
                                          'When tapping Create Account or Sign in, you agree to our '),
                                  TextSpan(
                                      text: 'Terms',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.underline)),
                                  TextSpan(
                                      text:
                                          '. If you would like to learn more about how we handle data, check out our '),
                                  TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.underline)),
                                  TextSpan(text: '.'),
                                ]),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          )),
                      SizedBox(height: 20),
                      TapBuilder(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignInNum()));
                          },
                          builder: (context, state) => Transform.scale(
                                alignment: Alignment.center,
                                scale: state == TapState.pressed ? .95 : 1,
                                child: AnimatedContainer(
                                    width: MediaQuery.of(context).size.width *
                                        .85,
                                    height:
                                        MediaQuery.of(context).size.height *
                                            .06,
                                    duration:
                                        const Duration(milliseconds: 600),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)),
                                    ),
                                    child: Center(
                                        child: Text('CREATE ACCOUNT',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .backgroundColor)))),
                              )),
                      SizedBox(height: 15),
                      TapBuilder(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignInNum()));
                          },
                          builder: (context, state) => Transform.scale(
                                alignment: Alignment.center,
                                scale: state == TapState.pressed ? .95 : 1,
                                child: AnimatedContainer(
                                    width: MediaQuery.of(context).size.width *
                                        .85,
                                    height:
                                        MediaQuery.of(context).size.height *
                                            .06,
                                    duration:
                                        const Duration(milliseconds: 600),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color,
                                          width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)),
                                    ),
                                    child: Center(
                                        child: Text('SIGN IN',
                                                key: UniqueKey(),
                                                style: TextStyle(
                                                    color:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .color))
                                    )),
                              )),
                      SizedBox(height: 20),
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color),
                              children: [
                            TextSpan(text: 'Need Help? '),
                            TextSpan(
                                text: 'Recover Account',
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                          ]))
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: MediaQuery.of(context).size.height * .66,
                  child: Text('Jungle',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 60,
                          color: Theme.of(context).primaryColor))),
            ],
          ),
        ),
      ),
    );
  }
}
