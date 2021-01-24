import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JungleButton extends StatefulWidget {
  final Color color;
  final Widget child;
  final bool disabled;
  final EdgeInsetsGeometry padding;
  final Function onTap;

  JungleButton(
      {Key key,
      this.color = Colors.white,
      this.disabled = false,
      this.child,
      this.padding = const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      this.onTap})
      : super(key: key);

  @override
  _JungleButtonState createState() => _JungleButtonState();
}

class _JungleButtonState extends State<JungleButton> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.disabled,
      child: GestureDetector(
          onTapCancel: () {
            setState(() {
              isTapped = false;
            });
          },
          onTapDown: (details) {
            setState(() {
              isTapped = true;
            });
          },
          onTap: () {
            setState(() {
              isTapped = false;
            });
            widget.onTap();
          },
          child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: !widget.disabled ? widget.color : Colors.grey),
              transformAlignment: Alignment.center,
              transform: !isTapped
                  ? Matrix4.diagonal3Values(1, 1, 1)
                  : Matrix4.diagonal3Values(.96, .96, .96),
              curve: Curves.ease,
              child: Padding(
                padding: widget.padding,
                child: widget.child,
              ))),
    );
  }
}
