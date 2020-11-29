import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/screens/discover_page.dart';
import 'package:flutter_chat_ui/screens/chat_page.dart';
import 'package:flutter_chat_ui/screens/profile_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
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
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: Stack(
          children: <Widget>[
            PageView(
              controller: _controller,
              children: [
                ProfilePage(),
                DiscoverPage(),
                ChatPage(),
              ],
              onPageChanged: _onItemTapped,
            ),
          ],
        ));
  }
}
