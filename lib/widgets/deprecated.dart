import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  static const double kExpandedHeight = 300.0;

  static const double kInitialSize = 75.0;

  static const double kFinalSize = 30.0;

  static const List<Color> kBoxColors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.grey,
  ];

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {/* State being set is the Scroll Controller's offset */});
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    double size = !_scrollController.hasClients || _scrollController.offset == 0
        ? 75.0
        : 75 -
            math.min(
                45.0,
                (45 /
                    kExpandedHeight *
                    math.min(_scrollController.offset, kExpandedHeight) *
                    1.5));

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: kExpandedHeight,
            title: Text("Title!"),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(55),
              child: buildAppBarBottom(size),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(title: Text('Item $index'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBarBottom(double size) {
    double t =
        ((size - kInitialSize) / (kFinalSize - kInitialSize)).clamp(0.0, 1.0);

    const double initialContainerHeight = 2 * kInitialSize;
    const double finalContainerHeight = kFinalSize;

    return Container(
      height: lerpDouble(initialContainerHeight, finalContainerHeight, t),
      child: LayoutBuilder(
        builder: (context, constraints) {
          List<Widget> stackChildren = [];
          for (int i = 0; i < 6; i++) {
            Offset offset = getInterpolatedOffset(i, constraints, t);
            stackChildren.add(Positioned(
              left: offset.dx,
              top: offset.dy,
              child: buildSizedBox(size, kBoxColors[i]),
            ));
          }

          return Stack(children: stackChildren);
        },
      ),
    );
  }

  Offset getInterpolatedOffset(
      int index, BoxConstraints constraints, double t) {
    Curve curve = Curves.easeIn;
    double curveT = curve.transform(t);

    Offset a = getOffset(index, constraints, kInitialSize, 3);
    Offset b = getOffset(index, constraints, kFinalSize, 6);

    return Offset(
      lerpDouble(a.dx, b.dx, curveT),
      lerpDouble(a.dy, b.dy, curveT),
    );
  }

  Offset getOffset(
      int index, BoxConstraints constraints, double size, int columns) {
    int x = index % columns;
    int y = index ~/ columns;
    double horizontalMargin = (constraints.maxWidth - size * columns) / 2;

    return Offset(horizontalMargin + x * size, y * size);
  }

  Widget buildSizedBox(double size, Color color) {
    return Container(
      height: size,
      width: size,
      color: color,
    );
  }
}
