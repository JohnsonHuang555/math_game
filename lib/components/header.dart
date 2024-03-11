import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget {
  final Widget? child;
  const Header({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 32,
          ),
        ),
        child ?? Container(),
      ],
    );
  }
}
