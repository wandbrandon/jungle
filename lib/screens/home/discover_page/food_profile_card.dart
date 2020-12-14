import 'package:flutter/material.dart';
import 'package:jungle/models/models.dart';
import 'package:jungle/screens/home/discover_page/food_page.dart';
import 'package:tap_builder/tap_builder.dart';

class AnimatedStateButton extends StatelessWidget {
  final Food food;

  const AnimatedStateButton({
    Key key,
    this.food,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: food.imageUrls[0],
      child: AnimatedTapBuilder(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => FoodPage(food: food)));
        },
        builder: (context, state, cursorLocation, cursorAlignment) {
          cursorAlignment = state == TapState.pressed
              ? Alignment(-cursorAlignment.x, -cursorAlignment.y)
              : Alignment.center;
          return AnimatedContainer(
            transformAlignment: Alignment.center,
            transform: Matrix4.rotationX(-cursorAlignment.y * 0.2)
              ..rotateY(cursorAlignment.x * 0.2)
              ..scale(
                state == TapState.pressed ? 0.96 : 1.0,
              ),
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: state == TapState.pressed ? 0.6 : 1,
                    child: Image.network(
                      '${food.imageUrls[0]}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                    gradient: LinearGradient(
                        tileMode: TileMode.mirror,
                        colors: [
                          Colors.black.withOpacity(.25),
                          Colors.transparent
                        ],
                        begin: FractionalOffset.bottomCenter,
                        end: FractionalOffset.center),
                  )),
                  AnimatedContainer(
                    alignment: Alignment.center,
                    transform: Matrix4.translationValues(
                      cursorAlignment.x * 7,
                      cursorAlignment.y * 7,
                      0,
                    ),
                    duration: const Duration(milliseconds: 200),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 45,
                          left: 20,
                          child: Text(
                            '${food.name}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                      alignment: Alignment.center,
                      transform: Matrix4.translationValues(
                        cursorAlignment.x * 4,
                        cursorAlignment.y * 4,
                        0,
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: Stack(children: [
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Text(
                            'location info',
                            style: TextStyle(
                              color: Colors.white.withOpacity(.80),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ])),
                  AnimatedContainer(
                      alignment: Alignment.center,
                      transform: Matrix4.translationValues(
                        cursorAlignment.x * 12,
                        cursorAlignment.y * 12,
                        0,
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: Stack(children: [
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Text(
                            '\$\$\$',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ])),
                  Positioned.fill(
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment:
                          Alignment(-cursorAlignment.x, -cursorAlignment.y),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.01),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(
                                  state == TapState.pressed ? 0.5 : 0.0),
                              blurRadius: 200,
                              spreadRadius: 75,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
