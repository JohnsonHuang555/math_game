import 'package:basic/audio/sounds.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';

class Header extends StatelessWidget {
  final Widget? leftChild;
  final Widget? rightChild;
  final String? title;
  const Header({super.key, this.leftChild, this.rightChild, this.title});

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leftChild != null
            ? leftChild!
            : GestureDetector(
                onTap: () {
                  audioController.playSfx(SfxType.buttonBack);
                  GoRouter.of(context).pop();
                },
                child: const Icon(
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
