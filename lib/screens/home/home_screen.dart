import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/screens/home/profile_page/current_profile_page.dart';
import 'package:jungle/screens/home/chats_page/chat_page.dart';
import 'package:jungle/screens/home/discover_page/discover_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _controller = PageController(
    initialPage: 1,
    keepPage: true,
  );
  int _selectedIndex = 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _bottomTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  void _onItemTapped(int index) {
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
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Theme.of(context).backgroundColor,
          onTap: _bottomTapped,
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              PageView(
                
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                children: [
                  ProfilePage(),
                  DiscoverPage(),
                  ChatPage(),
                ],
                onPageChanged: _onItemTapped,
              ),
            ],
          ),
        ));
  }
}
