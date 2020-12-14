import 'package:flutter/material.dart';
import 'package:jungle/data/data.dart';
import 'package:jungle/screens/home/discover_page/food_profile_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int _selectedPage = 0;
  ScrollPhysics physics;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: .90);
  }

  String currentSelection = "Bars";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Discover $currentSelection'),
      ),
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * .75,
              width: double.infinity,
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    _selectedPage = index;
                  });
                },
                itemCount: rests.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30.0),
                    child: AnimatedStateButton(food: rests[index]),
                  );
                },
              )),
          Container(
            child: Center(
                child: SmoothPageIndicator(
                    controller: _pageController,
                    count: rests.length,
                    effect: ExpandingDotsEffect(
                        dotColor: Theme.of(context).backgroundColor,
                        expansionFactor: 4,
                        dotHeight: 5,
                        dotWidth: 5,
                        activeDotColor: Theme.of(context).accentColor),
                    onDotClicked: (index) {
                      setState(() {
                        _selectedPage = index;
                        _pageController.animateToPage(index, curve: Curves.easeInOutCirc, duration: const Duration(milliseconds: 500));
                      });
                    })),
          ),
        ],
      ),
    );
  }
}
