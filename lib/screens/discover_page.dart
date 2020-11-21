import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/data/data.dart';
import 'package:flutter_chat_ui/screens/food_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animations/animations.dart';

class DiscoverPage extends StatefulWidget {

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with SingleTickerProviderStateMixin{
  
  PageController _pageController;
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.90);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _barSelector(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions){
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 530.0,
            width: Curves.easeInOut.transform(value) * 530.0,
            child: widget,
          )
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => FoodPage(food: bars[index])));
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Hero(
              tag: bars[index].imageUrls[0],
                child: Container(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30.0),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.2),
                  //     spreadRadius: -5,
                  //     blurRadius: 15,
                  //     offset: Offset(0, 30), // changes position of shadow
                  //   )
                  // ],
                  image: DecorationImage (
                    image: NetworkImage(bars[index].imageUrls[0]),
                    fit: BoxFit.cover
                  )
                ),
                child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        bottom: 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget> [
                          ]
                        )
                      )
                    ]
                  ),
                )
              ),
          ]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
            child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                    child: Container(
                      height: 50.0,
                      padding: EdgeInsets.fromLTRB(16, 5, 0, 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Row(
                        children: <Widget> [
                          Icon(
                              Icons.search,
                              size: 16
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              currentUser.location,
                              style: TextStyle(
                                fontSize: 16
                              ), 
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                ]
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 5,
                ),
                child: Text(
                  'Discover',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500
                  )
                ),
              ),
              Container(
                height: 530.0,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _selectedPage = index;
                    });
                  },
                  itemCount: bars.length,
                  itemBuilder: (BuildContext context, int index){
                    return _barSelector(index);
                  },             
                )
              ),
            //   Container(
            //   child: Center(
            //     child: SmoothPageIndicator(
            //       controller: _pageController,
            //       count:  bars.length,
            //       effect:  WormEffect(
            //         dotHeight: 3,
            //         dotWidth: 3,
            //         activeDotColor: Colors.black
            //       ),
            //     )
            //   ),
            // ),
            ],
        ),
      )
    );
  }
}

