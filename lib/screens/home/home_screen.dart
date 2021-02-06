import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/discover_page/activity_profile_card.dart';
import 'package:jungle/screens/home/match_page/match_page.dart';
import 'package:jungle/screens/home/profile_page/current_profile_page.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:ionicons/ionicons.dart';

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

  List<Widget> listViewBuilder(Map<String, List<Activity>> map) {
    List<Widget> widgets = [];
    map.forEach((key, value) {
      widgets.add(ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 14,
        ),
        itemBuilder: (context, index) {
          return Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    offset: Offset(0, 4),
                    spreadRadius: .5,
                    blurRadius: 5)
              ], borderRadius: BorderRadius.circular(15)),
              height: 225,
              child: ActivityProfileCard(activity: value[index]));
        },
        itemCount: value.length,
        padding: EdgeInsets.all(12),
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

  Widget buildCartItem(Activity item, bool last) {
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
      widthFactor: last ? 1 : .7,
    );
  }

  Widget buildCartList(List<Activity> cart) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: cart.length,
        itemBuilder: (context, index) {
          if (index == cart.length - 1) {
            return buildCartItem(cart[index], true);
          }
          return buildCartItem(cart[index], false);
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
                          border: Border.all(width: 5, color: Colors.black),
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
              // SizedBox(width: 8),
              // Text(item.price,
              //     textAlign: TextAlign.right,
              //     style: TextStyle(fontSize: 16, color: Colors.grey))
            ],
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              cartModel.removeFromCart(item);
            },
            child: Icon(Ionicons.close_circle_outline, color: Colors.red),
          )
        ],
      ),
    );
  }

  Widget buildLowerCartList(List<Activity> cart) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return buildLowerCartItem(cart[index], index);
        });
  }

  Widget buildPlacesList(List<Activity> cart) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      switchInCurve: Curves.ease,
      switchOutCurve: Curves.ease,
      child: !scrolled ? buildBottomBar(cart) : buildBottomPage(cart),
    );
  }

  Widget buildBottomPage(List<Activity> cart) {
    return AnimatedSwitcher(
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.ease,
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 300),
        child: cart.isNotEmpty
            ? Center(
                key: ValueKey('notempty'),
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
                              padding: const EdgeInsets.only(top: 60.0),
                              child: Text('Activities',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 32)),
                            ),
                          ),
                          SizedBox(height: 10),
                          ConstrainedBox(
                              constraints: new BoxConstraints(
                                minHeight: 35.0,
                                maxHeight:
                                    MediaQuery.of(context).size.height * .345,
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
                                      Ionicons.information_circle,
                                      color: Colors.white,
                                    )),
                                SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        'Maximum Choices',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[400]),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Currently you are at ${cart.length} places. You can scroll through this list. Your limit is ${cartModel.limit}.',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 10),
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
                                                color: cart.length >=
                                                        cartModel.limit
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
                      AbsorbPointer(
                        absorbing: !cartModel.modified,
                        child: TapBuilder(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            List<String> aids = cartModel.saveChanges();
                            context
                                .read<FirestoreService>()
                                .updateUserFieldByAuth(
                                    context.read<User>(), 'activities', aids);
                          },
                          builder: (context, state) {
                            return AnimatedContainer(
                              alignment: Alignment.center,
                              curve: Curves.ease,
                              duration: Duration(milliseconds: 200),
                              width: MediaQuery.of(context).size.width * .85,
                              height: MediaQuery.of(context).size.width * .12,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: cartModel.modified
                                      ? state != TapState.pressed
                                          ? Theme.of(context).accentColor
                                          : Theme.of(context).highlightColor
                                      : Colors.grey),
                              child: Text('Start Swiping',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16)),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                key: ValueKey('empty'),
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
              ));
  }

  Widget buildBottomBar(List<Activity> cart) {
    return Align(
      alignment: Alignment.topCenter,
      child: AbsorbPointer(
        absorbing: scrolled,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Ionicons.bookmarks_outline,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[
                                Colors.black,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black,
                              ],
                              stops: [
                                0,
                                .05,
                                .95,
                                1,
                              ]).createShader(bounds);
                        },
                        blendMode: BlendMode.srcOver,
                        child:
                            Container(height: 50, child: buildCartList(cart)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TapBuilder(
              onTap: cartModel.modified
                  ? () {
                      HapticFeedback.mediumImpact();
                      _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          curve: Curves.ease,
                          duration: Duration(milliseconds: 400));
                    }
                  : null,
              builder: (context, state) => AnimatedContainer(
                duration: Duration(milliseconds: 600),
                curve: Curves.ease,
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cartModel.modified
                        ? cart.length == cartModel.limit
                            ? Theme.of(context).accentColor
                            : Theme.of(context).highlightColor
                        : Colors.grey),
                child: Center(
                  child: !(cart.length == cartModel.limit)
                      ? Text('${cartModel.limit - cart.length}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor))
                      : Icon(
                          Icons.check_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                child: SafeArea(
                  bottom: false,
                  right: false,
                  left: false,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text('Explore',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                )),
                            centerTitle: false,
                            titlePadding: EdgeInsetsDirectional.only(
                                start: 24, bottom: 13),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          expandedHeight: 125,
                          elevation: 0,
                          pinned: false,
                          actions: [
                            IconButton(
                                iconSize: 30,
                                icon: Icon(Ionicons.person_circle_outline),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) => ProfilePage()));
                                }),
                            IconButton(
                                iconSize: 30,
                                icon: Icon(Ionicons.heart_outline),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MatchPage()));
                                }),
                            IconButton(
                                iconSize: 30,
                                icon: Icon(Ionicons.chatbubbles_outline),
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
                    body: TabBarView(children: listViewBuilder(activityMap)),
                  ),
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Theme.of(context).primaryColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
