import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/screens/splash/sign_in.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  PageController _controller = PageController(
    initialPage: 1,
    keepPage: true,
  );
  int _selectedIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageFinished(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Theme.of(context).brightness,
        statusBarBrightness: Theme.of(context).brightness,
        statusBarColor: Colors.transparent // status bar color
        ));
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width * .80,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            children: [
              SignIn(),
            ],
            onPageChanged:_onPageFinished,
          ),
        ),
      ),
    );
  }
}
