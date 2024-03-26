import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

import '../player_progress/player_progress.dart';

class IntroduceScreen extends StatefulWidget {
  const IntroduceScreen({super.key});

  @override
  State<IntroduceScreen> createState() => _IntroduceScreenState();
}

class _IntroduceScreenState extends State<IntroduceScreen> {
  @override
  Widget build(BuildContext context) {
    final playerProgress = context.read<PlayerProgress>();

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Title of custom body page",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on "),
              Icon(Icons.edit),
              Text(" to edit a post"),
            ],
          ),
          image: const Center(child: Icon(Icons.android)),
        )
      ],
      showNextButton: false,
      done: const Text("Done"),
      onDone: () async {
        final isSuccess = await playerProgress.createNewPlayer('????');
        if (isSuccess && context.mounted) {
          GoRouter.of(context).pop();
        }
      },
    );
  }
}
