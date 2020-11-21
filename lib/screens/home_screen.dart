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
    initialPage: 0,
  );
  int _selectedIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<IconData> _icons = [
    Icons.search,
    Icons.how_to_reg_outlined,
    Icons.chat_bubble_outline,
    Icons.person_outlined,
  ];

  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _controller.jumpToPage(index);
      },
      child: Icon(
        _icons[index],
        size: 30.0,
        color: _selectedIndex == index
            ? Colors.black
            : Colors.black.withOpacity(0.20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark
                .copyWith(statusBarColor: Colors.transparent),
            child: Stack(
              children: <Widget>[
                PageView(
                  controller: _controller,
                  children: [
                    DiscoverPage(),
                    ChatPage(),
                    ProfilePage(),
                  ],
                  onPageChanged: (page) {
                    setState(() {
                      _selectedIndex = page;
                    });
                  },
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildIcon(0),
                          _buildIcon(1),
                          _buildIcon(2),
                          _buildIcon(3)
                        ],
                      ),
                    ))
              ],
            )));
  }
}
