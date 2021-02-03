import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jungle/data/data.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/discover_page/activity_profile_card.dart';
import 'package:jungle/screens/home/match_page/match_page.dart';
import 'package:jungle/screens/home/profile_page/current_profile_page.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:jungle/widgets/jungle_button.dart';
import 'package:jungle/widgets/profile_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import 'chats_page/chat_page.dart';
import 'discover_page/activity_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _controller = ScrollController();
  bool scrolled = false;
  Map<String, List<Activity>> activityMap;
  ActivityState cartModel;

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_controller.position.pixels <= 50)
      setState(() {
        scrolled = false;
      });
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 50) {
      setState(() {
        scrolled = true;
      });
    }
  }

  List<Widget> gridViewBuilder(Map<String, List<Activity>> map) {
    List<Widget> widgets = [];
    map.forEach((key, value) {
      widgets.add(GridView.builder(
        itemBuilder: (context, index) {
          return ActivityProfileCard(activity: value[index]);
        },
        itemCount: value.length,
        padding: EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 500.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 16 / 9.25,
        ),
      ));
    });
    return widgets;
  }

  List<Widget> tabBuilder(Map<String, List<Activity>> map) {
    List<Widget> widgets = [];
    map.forEach((key, value) {
      widgets.add(Tab(text: key));
    });
    return widgets;
  }

  Widget buildCartItem(Activity item) {
    return Align(
      child: CachedNetworkImage(
        imageUrl: item.images[0],
        cacheKey: item.images[0],
        imageBuilder: (context, imageProvider) {
          return Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1, color: Colors.white),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7, // changes position of shadow
                ),
              ],
            ),
          );
        },
      ),
      alignment: Alignment.centerLeft,
      widthFactor: 0.7,
    );
  }

  Widget buildCartList(List<Activity> cart) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return buildCartItem(cart[index]);
        });
  }

  Widget buildLowerCartItem(Activity item, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 24.0, bottom: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: item.images[0],
                cacheKey: item.images[0],
                imageBuilder: (context, imageProvider) {
                  return Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(width: 6, color: Colors.black),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ));
                },
              ),
              SizedBox(width: 18),
              Text(
                item.name,
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.left,
              ),
              SizedBox(width: 8),
              Text(item.price,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 16, color: Colors.grey))
            ],
          ),
          GestureDetector(
            onTap: () {
              cartModel.removeFromCart(item);
            },
            child: Icon(Icons.highlight_off_rounded, color: Colors.red),
          )
        ],
      ),
    );
  }

  Widget buildLowerCartList(List<Activity> cart) {
    return ListView.builder(
        padding: EdgeInsets.only(top: 20),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return buildLowerCartItem(cart[index], index);
        });
  }

  Widget buildPlacesList(List<Activity> cart) {
    return AnimatedCrossFade(
        alignment: Alignment.center,
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300),
        crossFadeState:
            !scrolled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstCurve: Curves.ease,
        secondCurve: Curves.ease,
        sizeCurve: Curves.ease,
        firstChild: AbsorbPointer(
          absorbing: scrolled,
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
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black
                        ],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Container(
                        width: MediaQuery.of(context).size.width * .5,
                        height: 40,
                        child: buildCartList(cart)),
                  ),
                ],
              ),
              GestureDetector(
                onTap: cartModel.modified
                    ? () {
                        context.read<FirestoreService>().updateUserFieldByAuth(
                            context.read<User>(),
                            'activities',
                            cartModel.saveChanges());
                      }
                    : null,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2,
                        color: cartModel.modified
                            ? cart.length == cartModel.limit
                                ? Theme.of(context).accentColor
                                : Theme.of(context).highlightColor
                            : Colors.grey),
                  ),
                  child: Center(
                    child: !(cart.length == cartModel.limit)
                        ? Text('${cartModel.limit - cart.length}',
                            style: TextStyle(
                              fontSize: 20,
                              color: cartModel.modified
                                  ? cart.length == cartModel.limit
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).highlightColor
                                  : Colors.grey,
                            ))
                        : Icon(
                            Icons.check_rounded,
                            color: cartModel.modified
                                ? cart.length == cartModel.limit
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).highlightColor
                                : Colors.grey,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        secondChild: AnimatedCrossFade(
            crossFadeState: cart.isNotEmpty
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstCurve: Curves.ease,
            secondCurve: Curves.ease,
            duration: Duration(milliseconds: 600),
            reverseDuration: Duration(milliseconds: 600),
            firstChild: Center(
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text('Places',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 36)),
                          ),
                        ),
                        SizedBox(height: 10),
                        ConstrainedBox(
                            constraints: new BoxConstraints(
                              minHeight: 35.0,
                              maxHeight:
                                  MediaQuery.of(context).size.height * .37,
                            ),
                            child: buildLowerCartList(cart)),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, left: 24.0, bottom: 8, top: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey),
                                  child: Icon(
                                    Icons.info_rounded,
                                    color: Colors.white,
                                  )),
                              SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      'Maximum Choices',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[400]),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Currently you are at ${cart.length} places. You can scroll through this list. Your limit is ${cartModel.limit}.',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 20),
                                    AnimatedContainer(
                                        padding: EdgeInsets.only(
                                            right: (((cartModel.limit -
                                                            cart.length))
                                                        .clamp(0,
                                                            cartModel.limit) /
                                                    cartModel.limit) *
                                                210),
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.ease,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 5,
                                        width: 210,
                                        child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.ease,
                                            decoration: BoxDecoration(
                                              color:
                                                  cart.length >= cartModel.limit
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    JungleButton(
                      disabled: !cartModel.modified,
                      onTap: () {
                        context.read<FirestoreService>().updateUserFieldByAuth(
                            context.read<User>(),
                            'activities',
                            cartModel.saveChanges());
                      },
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .35,
                          vertical: 15),
                      color: Theme.of(context).accentColor,
                      child: Text('Save',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    )
                  ],
                ),
              ),
            ),
            secondChild: Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 200),
                  child: Column(
                    children: [
                      Icon(Icons.arrow_upward_rounded,
                          color: Colors.white, size: 45),
                      SizedBox(height: 30),
                      Container(
                        width: 200,
                        child: Text(
                          "This page shows your chosen places at a glance, but you haven't added any places yet! \n\nScroll up to do so.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )),
            )));
  }

  @override
  Widget build(BuildContext context) {
    activityMap = context.watch<Map<String, List<Activity>>>();
    cartModel = context.watch<ActivityState>();
    if (activityMap == null) {
      return Center(child: CircularProgressIndicator.adaptive());
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        shrinkWrap: true,
        controller: _controller,
        physics: PageScrollPhysics(parent: ClampingScrollPhysics()),
        padding: EdgeInsets.zero,
        children: [
          AbsorbPointer(
            absorbing: scrolled,
            child: Container(
              height: MediaQuery.of(context).size.height * .84,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: DefaultTabController(
                length: activityMap.length,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        flexibleSpace: FlexibleSpaceBar(
                          title: Container(
                            child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                Text(
                                  'Discover',
                                ),
                              ],
                            ),
                          ),
                          centerTitle: false,
                          titlePadding:
                              EdgeInsetsDirectional.only(start: 12, bottom: 16),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        expandedHeight: 150,
                        elevation: 0,
                        pinned: true,
                        actions: [
                          IconButton(
                              icon: Icon(Icons.account_circle_rounded),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => ProfilePage()));
                              }),
                          IconButton(
                              icon: Icon(Icons.favorite),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MatchPage()));
                              }),
                          IconButton(
                              icon: Icon(Icons.chat_bubble_rounded),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage()));
                              }),
                        ],
                      ),
                      SliverPersistentHeader(
                        delegate: _SliverAppBarDelegate(TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          isScrollable: true,
                          indicator: BubbleTabIndicator(
                            indicatorHeight: 25.0,
                            indicatorColor: Theme.of(context).accentColor,
                            tabBarIndicatorSize: TabBarIndicatorSize.label,
                          ),
                          tabs: tabBuilder(activityMap),
                        )),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(children: gridViewBuilder(activityMap)),
                ),
              ),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * .84,
              padding: EdgeInsets.all(24),
              color: Colors.black,
              child: buildPlacesList(cartModel.getCart)),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      color: Theme.of(context).primaryColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
