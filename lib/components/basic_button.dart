import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../style/palette.dart';

// ignore: must_be_immutable
class BasicButton extends StatefulWidget {
  final Color? bgColor;
  final double? padding;
  final Widget child;
  final VoidCallback? onPressed;
  BasicButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.interval = 1000,
    this.bgColor,
    this.padding,
  });
  int interval;

  @override
  State<BasicButton> createState() => _BasicButtonState();
}

class _BasicButtonState extends State<BasicButton> {
  var isClicked = false;

  late Timer _timer;

  _startTimer() {
    _timer =
        Timer(Duration(milliseconds: widget.interval), () => isClicked = false);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();

    return SizedBox(
      width: double.infinity,
      child: ZoomTapAnimation(
        onTap: () {
          if (isClicked == false) {
            _startTimer();
            widget.onPressed!();
            isClicked = true;
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: palette.ink,
            ),
            borderRadius: BorderRadius.circular(6),
            color: widget.bgColor ?? Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.padding ?? 4.0),
            child: Center(
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
