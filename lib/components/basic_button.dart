import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';

// ignore: must_be_immutable
class BasicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  BasicButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.interval = 1000,
  });
  int interval;

  @override
  State<BasicButton> createState() => _BasicButtonState();
}

class _BasicButtonState extends State<BasicButton> {
  var isClicked = false;

  late Timer _timer;

  _startTimer() {
    _timer = Timer(Duration(milliseconds: widget.interval), () => isClicked = false);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          if (isClicked == false) {
            _startTimer();
            widget.onPressed!();
            isClicked = true;
          }
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          side: BorderSide(width: 2, color: palette.ink),
        ),
        child: widget.child,
      ),
    );
  }
}
