// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:basic/play_session/item_list.dart';
import 'package:basic/play_session/session_step/step_combine_formula.dart';
import 'package:basic/play_session/session_step/step_select_number.dart';
import 'package:basic/play_session/session_step/step_select_symbol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../components/header.dart';
import '../game_internals/game_state.dart';
import '../style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/level_state.dart';
import '../game_internals/score.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import '../style/confetti.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import 'game_widget.dart';

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  @override
  void initState() {
    super.initState();

    _startOfPlay = DateTime.now();
  }

  Widget _getGameStep(GameState state) {
    switch (state.step) {
      case 1:
        return StepSelectSymbol(
          mathSymbols: state.boxSymbols,
          onSelect: state.handleSelectMathSymbol,
          showSelectResult: state.showSelectResult,
          selectedSymbols: state.selectedSymbols,
        );
      case 2:
        return StepSelectNumber(
          numbers: state.boxNumbers,
          onSelect: state.handleSelectNumber,
          showSelectResult: state.showSelectResult,
          selectedNumbers: state.selectedNumbers,
        );
      case 3:
        return StepCombineFormula(
          currentSelectedItems: state.currentSelectedItems,
          onSelectAnswer: state.handleSelectAnswer,
        );
      default:
        return Text('Something wrong...');
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    // return MultiProvider(
    //   providers: [
    //     Provider.value(value: widget.level),
    //     // Create and provide the [LevelState] object that will be used
    //     // by widgets below this one in the widget tree.
    //     ChangeNotifierProvider(
    //       create: (context) => LevelState(
    //         goal: widget.level.difficulty,
    //         onWin: _playerWon,
    //       ),
    //     ),
    //   ],
    //   child: IgnorePointer(
    //     // Ignore all input during the celebration animation.
    //     ignoring: _duringCelebration,
    //     child: Scaffold(
    //       backgroundColor: palette.backgroundPlaySession,
    //       // The stack is how you layer widgets on top of each other.
    //       // Here, it is used to overlay the winning confetti animation on top
    //       // of the game.
    //       body: Stack(
    //         children: [
    //           // This is the main layout of the play session screen,
    //           // with a settings button on top, the actual play area
    //           // in the middle, and a back button at the bottom.
    //           Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Align(
    //                 alignment: Alignment.centerRight,
    //                 child: InkResponse(
    //                   onTap: () => GoRouter.of(context).push('/settings'),
    //                   child: Image.asset(
    //                     'assets/images/settings.png',
    //                     semanticLabel: 'Settings',
    //                   ),
    //                 ),
    //               ),
    //               const Spacer(),
    //               Expanded(
    //                 // The actual UI of the game.
    //                 child: GameWidget(),
    //               ),
    //               const Spacer(),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: MyButton(
    //                   onPressed: () => GoRouter.of(context).go('/play'),
    //                   child: const Text('Back'),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           // This is the confetti animation that is overlaid on top of the
    //           // game when the player wins.
    //           SizedBox.expand(
    //             child: Visibility(
    //               visible: _duringCelebration,
    //               child: IgnorePointer(
    //                 child: Confetti(
    //                   isStopped: !_duringCelebration,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GameState(),
        ),
      ],
      child: Scaffold(
        backgroundColor: palette.backgroundMain,
        body: Consumer<GameState>(
          builder: ((context, state, child) {
            return ResponsiveScreen(
              squarishMainArea: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Header(
                    child: Icon(
                      Icons.help_outline,
                      size: 34,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    state.risk.toString(),
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(height: 35),
                  _getGameStep(state),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    child: ItemList(),
                  ),
                ],
              ),
              rectangularMenuArea: MyButton(
                onPressed: () {
                  state.handleNextStep();
                  // GoRouter.of(context).go('/');
                },
                child: const Text('選好了'),
              ),
            );
          }),
        ),
      ),
    );
  }

  // Future<void> _playerWon() async {
  //   _log.info('Level ${widget.level.number} won');

  //   final score = Score(
  //     widget.level.number,
  //     widget.level.difficulty,
  //     DateTime.now().difference(_startOfPlay),
  //   );

  //   final playerProgress = context.read<PlayerProgress>();
  //   playerProgress.setLevelReached(widget.level.number);

  //   // Let the player see the game just after winning for a bit.
  //   await Future<void>.delayed(_preCelebrationDuration);
  //   if (!mounted) return;

  //   setState(() {
  //     _duringCelebration = true;
  //   });

  //   final audioController = context.read<AudioController>();
  //   audioController.playSfx(SfxType.congrats);

  //   /// Give the player some time to see the celebration animation.
  //   await Future<void>.delayed(_celebrationDuration);
  //   if (!mounted) return;

  //   GoRouter.of(context).go('/play/won', extra: {'score': score});
  // }
}
