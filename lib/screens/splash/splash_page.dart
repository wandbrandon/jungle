import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:jungle/screens/splash/sign_in_num.dart';
import 'package:jungle/services/authentication_service.dart';
import 'package:jungle/widgets/flutter_sinusoidals.dart';
import 'package:provider/provider.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:ionicons/ionicons.dart';

import '../../main.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  bool signInClicked = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: ShaderMask(
        blendMode: Theme.of(context).brightness == Brightness.dark
            ? BlendMode.multiply
            : BlendMode.screen,
        shaderCallback: (bounds) => LinearGradient(
            stops: [.08, .8],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Theme.of(context).highlightColor,
              Theme.of(context).accentColor,
            ]).createShader(bounds),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).textTheme.bodyText1.color,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'lib/assets/artboard.png',
                color: Theme.of(context).primaryColor,
                height: 300,
              ),
              SizedBox(
                height: 65,
              ),
              CombinedWave(
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
                      frequency: 1,
                    ),
                    SinusoidalModel(
                      amplitude: 20,
                      waves: 1,
                      translate: .6,
                      frequency: .5,
                    ),
                  ],
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 40, bottom: 10),
                    child: SafeArea(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .81,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            AnimatedCrossFade(
                              duration: Duration(milliseconds: 500),
                              sizeCurve: Curves.ease,
                              firstCurve: Curves.ease,
                              secondCurve: Curves.ease,
                              crossFadeState: !signInClicked
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: buildFirst(context),
                              secondChild: buildSecond(context),
                            ),
                            SizedBox(height: 20),
                            // RichText(
                            //     text: TextSpan(
                            //         style: TextStyle(
                            //             fontSize: 13,
                            //             color: Theme.of(context)
                            //                 .textTheme
                            //                 .bodyText1
                            //                 .color),
                            //         children: [
                            //       TextSpan(text: 'Caught a bug? '),
                            //       TextSpan(
                            //           text: 'Let us know.',
                            //           style: TextStyle(
                            //               decoration:
                            //                   TextDecoration.underline)),
                            //     ]))
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFirst(BuildContext context) {
    return Container(
      key: ValueKey('create'),
      child: Column(
        children: [
          TapBuilder(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInNum()));
            },
            builder: (context, state) => AnimatedContainer(
                height: 50,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
                alignment: Alignment.center,
                transformAlignment: Alignment.center,
                transform: state == TapState.pressed
                    ? Matrix4.diagonal3Values(.95, .95, .95)
                    : Matrix4.diagonal3Values(1, 1, 1),
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.bodyText1.color,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Text('CREATE ACCOUNT',
                    style: TextStyle(color: Theme.of(context).primaryColor))),
          ),
          SizedBox(height: 15),
          TapBuilder(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                signInClicked = !signInClicked;
              });
            },
            builder: (context, state) => AnimatedContainer(
                height: 50,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
                alignment: Alignment.center,
                transformAlignment: Alignment.center,
                transform: state == TapState.pressed
                    ? Matrix4.diagonal3Values(.95, .95, .95)
                    : Matrix4.diagonal3Values(1, 1, 1),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      color: Theme.of(context).textTheme.bodyText1.color,
                      width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Text('SIGN IN / APPLE ID',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color))),
          ),
        ],
      ),
    );
  }

  Widget buildSecond(BuildContext context) {
    return Container(
      key: ValueKey('signin'),
      child: Column(
        children: [
          TapBuilder(
            onTap: () async {
              HapticFeedback.selectionClick();
              await context.read<AuthenticationService>().signInWithApple();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthenticationWrapper()),
                  (route) => false);
            },
            builder: (context, state) => AnimatedContainer(
              height: 50,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
              alignment: Alignment.center,
              transformAlignment: Alignment.center,
              transform: state == TapState.pressed
                  ? Matrix4.diagonal3Values(.95, .95, .95)
                  : Matrix4.diagonal3Values(1, 1, 1),
              decoration: BoxDecoration(
                color: Theme.of(context).textTheme.bodyText1.color,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Text('SIGN IN WITH APPLE ID',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          SizedBox(height: 15),
          TapBuilder(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInNum()));
            },
            builder: (context, state) => AnimatedContainer(
                height: 50,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
                alignment: Alignment.center,
                transformAlignment: Alignment.center,
                transform: state == TapState.pressed
                    ? Matrix4.diagonal3Values(.95, .95, .95)
                    : Matrix4.diagonal3Values(1, 1, 1),
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.bodyText1.color,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Text('SIGN IN WITH PHONE',
                    style: TextStyle(color: Theme.of(context).primaryColor))),
          ),
          SizedBox(height: 15),
          TapBuilder(
              onTap: () {
                HapticFeedback.heavyImpact();
                setState(() {
                  signInClicked = !signInClicked;
                });
              },
              builder: (context, state) => Transform.scale(
                    alignment: Alignment.center,
                    scale: state == TapState.pressed ? .95 : 1,
                    child: AnimatedContainer(
                        width: MediaQuery.of(context).size.width * .85,
                        height: MediaQuery.of(context).size.height * .06,
                        duration: const Duration(milliseconds: 600),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                            child: Text('BACK',
                                key: UniqueKey(),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color)))),
                  )),
        ],
      ),
    );
  }
}
