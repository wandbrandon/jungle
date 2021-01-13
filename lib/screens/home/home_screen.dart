import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _controller = ScrollController();
  bool scrolled = false;

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_controller.position.pixels <= 15)
      setState(() {
        scrolled = false;
      });
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      setState(() {
        scrolled = true;
      });
    }
  }

  Widget buildPlacesList() {
    return Column(children: [
      AnimatedOpacity(
        curve: Curves.ease,
        duration: Duration(milliseconds: 300),
        opacity: scrolled ? 0 : 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Places',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(width: 16),
                CircleAvatar(),
                SizedBox(width: 8),
                CircleAvatar(),
                SizedBox(width: 8),
                CircleAvatar(),
                SizedBox(width: 8),
                CircleAvatar(),
              ],
            ),
            ClipOval(
              child: Material(
                color: Theme.of(context).accentColor, // button color
                child: InkWell(
                  splashColor:
                      Theme.of(context).highlightColor, // inkwell color
                  child: SizedBox(
                      width: 56, height: 56, child: Icon(Icons.check_rounded)),
                  onTap: () {},
                ),
              ),
            )
          ],
        ),
      ),
      AnimatedOpacity(
        curve: Curves.ease,
        duration: Duration(milliseconds: 300),
        opacity: scrolled ? 1 : 0,
        child: Container(
          height: MediaQuery.of(context).size.height * .5,
          child: ListView(
            children: [
              Container(color: Colors.red, height: 100),
              Container(color: Colors.blue, height: 100),
            ],
          ),
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        shrinkWrap: true,
        controller: _controller,
        physics: PageScrollPhysics(parent: ClampingScrollPhysics()),
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .84,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.all(Radius.elliptical(50, 40))),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  flexibleSpace: FlexibleSpaceBar(
                    title: Row(
                      children: [
                        Text(
                          'Discover',
                        ),
                        Text(' Bars')
                      ],
                    ),
                    centerTitle: false,
                    titlePadding:
                        EdgeInsetsDirectional.only(start: 16, bottom: 16),
                  ),
                  backgroundColor: Theme.of(context).backgroundColor,
                  expandedHeight: 150,
                  elevation: 3,
                  pinned: true,
                  actions: [
                    IconButton(
                        icon: Icon(Icons.person_outline_rounded),
                        onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.chat_bubble_outline_rounded),
                        onPressed: () {})
                  ],
                ),
                SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).highlightColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))));
                      },
                      childCount: 25,
                    ),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: 3 / 4.0,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * .84,
              padding: EdgeInsets.all(16),
              color: Colors.black,
              child: buildPlacesList()),
        ],
      ),
    );
  }
}
