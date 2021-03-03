import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/discover_page/activity_profile_card.dart';
import 'package:jungle/screens/home/match_page/match_page.dart';
import 'package:jungle/screens/home/profile_page/current_profile_page.dart';
import 'package:jungle/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
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
  List<Activity> activities;
  ActivityState cartModel;
  UserModel currentUser;
  bool badge = false;

  @override
  void initState() {
    super.initState();
    activities = context.read<List<Activity>>();
    _controller.addListener(_scrollListener);
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> getTabs(List<Activity> acts) {
    List<String> activityTypes =
        acts.map((e) => e.type).toList().toSet().toList();
    activityTypes.sort();
    return activityTypes;
  }

  List<Widget> listViewBuilder(List<Activity> acts, List<String> tabs) {
    List<Widget> actLists = [];
    tabs.forEach((value) {
      List<Activity> tabList = acts.where((e) => (e.type == value)).toList();
      actLists.add(ListView.separated(
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) => ActivityProfileCard(
                activity: tabList[index],
              ),
          separatorBuilder: (context, index) => SizedBox(height: 14),
          itemCount: tabList.length));
    });
    return actLists;
  }

  List<Widget> tabBuilder(List<Activity> acts) {
    List<Widget> tabs = [];
    final tabStrings = getTabs(acts);
    tabStrings.forEach((e) {
      tabs.add(Tab(text: '${e[0].toUpperCase() + e.substring(1)}s'));
    });
    return tabs;
  }

  Widget buildCartItem(Activity item, bool isLast) {
    return Align(
      key: ValueKey(item.aid),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Colors.white),
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                item.images[0],
                maxHeight: 40,
                maxWidth: 40,
              ),
              fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7, // changes position of shadow
            ),
          ],
        ),
      ),
      alignment: Alignment.centerLeft,
      widthFactor: .7,
    );
  }

  Widget buildCartList(List<Activity> cart) {
    return ImplicitlyAnimatedList(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: 5),
      scrollDirection: Axis.horizontal,
      insertDuration: Duration(milliseconds: 200),
      removeDuration: Duration(milliseconds: 200),
      items: cart,
      areItemsTheSame: (Activity oldItem, Activity newItem) =>
          oldItem.aid == oldItem.aid,
      itemBuilder: (context, animation, item, index) {
        return FadeTransition(
            opacity: animation,
            child: buildCartItem(item, index == cart.length - 1));
      },
    );
  }

  Widget buildLowerCartItem(Activity item, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 24.0, bottom: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
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
                          image: CachedNetworkImageProvider(item.images[0]),
                          fit: BoxFit.cover),
                    ),
                  )),
              SizedBox(width: 18),
              Row(
                children: [
                  Text(
                    '${item.name} ',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '${item.price}',
                    style: TextStyle(
                        fontSize: 16, color: Colors.white.withOpacity(.6)),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
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
    return ImplicitlyAnimatedList<Activity>(
        removeDuration: Duration(milliseconds: 500),
        areItemsTheSame: (item1, item2) => item1.aid == item2.aid,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        reverse: true,
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        items: cart,
        itemBuilder: (context, animation, item, index) {
          return SizeFadeTransition(
              curve: Curves.ease,
              animation: animation,
              child: buildLowerCartItem(item, index));
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

  Widget buildBottomPage(
    List<Activity> cart,
  ) {
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
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            List<String> aids = cartModel.saveChanges();
                            setState(() {
                              currentUser.activities = aids;
                            });
                            await context
                                .read<FirestoreService>()
                                .updateUserByAuth(
                                    context.read<User>(), currentUser);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MatchPage()));
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
                    Ionicons.heart_outline,
                    color: Colors.white,
                    size: 30,
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
                        child: Container(
                          height: 50,
                          child: buildCartList(cart),
                          decoration: BoxDecoration(),
                          clipBehavior: Clip.hardEdge,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TapBuilder(
              onTap: () {
                HapticFeedback.mediumImpact();
                _controller.animateTo(_controller.position.maxScrollExtent,
                    curve: Curves.ease, duration: Duration(milliseconds: 400));
              },
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
                          Ionicons.checkmark,
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
    cartModel = context.watch<ActivityState>();
    currentUser =
        UserModel.fromJson(context.watch<DocumentSnapshot>()?.data() ?? {});
    if (activities == null) {
      return Center(child: CircularProgressIndicator.adaptive());
    }

    final chatRooms = context.watch<QuerySnapshot>()?.docs;
    badge = chatRooms.any((element) =>
        !element.data()['lastMessageRead'] &&
        element.data()['lastMessageSentBy'] != currentUser.uid);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness != Brightness.dark
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
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
                  length: getTabs(activities).length,
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
                            floating: true,
                            actions: [
                              IconButton(
                                  icon: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              currentUser.images[0],
                                            ),
                                            fit: BoxFit.cover)),
                                  ),
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) =>
                                                ProfilePage()));
                                  }),
                              IconButton(
                                  iconSize: 30,
                                  icon: Icon(Ionicons.heart_outline),
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MatchPage()));
                                  }),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  IconButton(
                                      iconSize: 30,
                                      icon: Icon(Ionicons.chatbubbles_outline),
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatPage()));
                                      }),
                                  badge
                                      ? Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            height: 15,
                                            width: 15,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 2,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ],
                          ),
                          SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(TabBar(
                              indicatorSize: TabBarIndicatorSize.label,
                              isScrollable: true,
                              labelColor: Theme.of(context).primaryColor,
                              unselectedLabelColor: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .color
                                  .withOpacity(.75),
                              indicator: BubbleTabIndicator(
                                indicatorHeight: 25.0,
                                indicatorColor: Theme.of(context).accentColor,
                                tabBarIndicatorSize: TabBarIndicatorSize.label,
                              ),
                              tabs: tabBuilder(activities),
                            )),
                            pinned: true,
                            floating: false,
                          ),
                        ];
                      },
                      body: TabBarView(
                          children:
                              listViewBuilder(activities, getTabs(activities))),
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
