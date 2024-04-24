import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget {
  final Widget? leftChild;
  final Widget? rightChild;
  final String? title;
  const Header({super.key, this.leftChild, this.rightChild, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leftChild != null
            ? leftChild!
            : GestureDetector(
                onTap: () {
                  GoRouter.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 32,
                ),
              ),
        Expanded(
          child: Center(
            child: Text(
              title ?? '',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        rightChild ??
            const SizedBox(
              width: 30,
            ),
      ],
    );
  }
}
