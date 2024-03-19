// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/play_session/item_list.dart';
import 'package:basic/play_session/session_step/step_combine_formula.dart';
import 'package:basic/play_session/session_step/step_select_number.dart';
import 'package:basic/play_session/session_step/step_select_symbol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';

import '../components/basic_button.dart';
import '../components/header.dart';
import '../game_internals/game_state.dart';
import '../player_progress/player_progress.dart';
import '../style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../style/palette.dart';

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

  // 棋盤遊戲區塊
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
          selectedFormulaItems: state.selectedFormulaItems,
          onSelectAnswer: state.handleSelectAnswer,
        );
      default:
        return Text('Something wrong...');
    }
  }

  // 底部按鈕
  Widget _getBottomAction(GameState state, Palette palette) {
    switch (state.step) {
      case 1:
      case 2:
        return BasicButton(
            onPressed: () {
              if (!state.showSelectResult) {
                state.handleNextStep();
              }
            },
            child: Text(
              '選好了',
              style: TextStyle(
                color: palette.ink,
                fontSize: 18,
              ),
            ));
      case 3:
        return Row(
          children: [
            SizedBox(
              width: 120,
              child: BasicButton(
                onPressed: () {
                  state.clearSelection();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/eraser.svg'),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '清除',
                      style: TextStyle(
                        fontSize: 18,
                        color: palette.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: BasicButton(
                onPressed: () {
                  Dialogs.materialDialog(
                    msg: '確定要完成嗎？',
                    title: '結算分數',
                    color: Colors.white,
                    titleStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    msgAlign: TextAlign.end,
                    context: context,
                    barrierDismissible: false,
                    actions: [
                      BasicButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: palette.ink,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                        onPressed: () async {
                          var playerProgress = context.read<PlayerProgress>();
                          var yourScore = playerProgress.yourScore;
                          var newScore = state.getCurrentAnswer(yourScore);

                          if (newScore == '?') {
                            Fluttertoast.showToast(
                              msg: ' 算式有誤 ',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 2,
                              backgroundColor: palette.redPen,
                              textColor: Colors.white,
                              fontSize: 16,
                            );
                            Navigator.of(context).pop();
                            return;
                          }

                          // 寫到 firebase TODO: 串 service center
                          var result =
                              await playerProgress.saveNewScore(newScore);
                          if (!result) {
                            throw Exception('setNewScore error');
                          }
                          Navigator.of(context).pop();
                          Dialogs.materialDialog(
                            customView: Column(
                              children: [
                                Text(
                                  '新積分',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  newScore,
                                  style: TextStyle(
                                    fontSize: 44,
                                  ),
                                ),
                              ],
                            ),
                            color: Colors.white,
                            titleStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                            msgAlign: TextAlign.end,
                            lottieBuilder: Lottie.asset(
                              'assets/animations/congrats.json',
                              fit: BoxFit.contain,
                            ),
                            context: context,
                            barrierDismissible: false,
                            actions: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                            width: 2,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: SvgPicture.asset(
                                            'assets/icons/home.svg',
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: palette.ink,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            GoRouter.of(context)
                                                .pushReplacement('/');
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Container(
                                        width: 60,
                                        height: 60,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                            width: 2,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: SvgPicture.asset(
                                            'assets/icons/restart.svg',
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: palette.ink,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            var canPop =
                                                GoRouter.of(context).canPop();
                                            if (canPop) {
                                              GoRouter.of(context).pop();
                                            }
                                            GoRouter.of(context).push('/play');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ],
                          );
                        },
                        child: Text(
                          '確定',
                          style: TextStyle(
                            color: palette.trueWhite,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                child: Text(
                  '完成',
                  style: TextStyle(
                    fontSize: 18,
                    color: palette.ink,
                  ),
                ),
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  String _getStep(int step) {
    switch (step) {
      case 1:
        return '符號';
      case 2:
        return '數字';
      case 3:
        return '組合';
      default:
        return '';
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
                    _getStep(state.step).toString(),
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(height: 35),
                  _getGameStep(state),
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.only(left: 80, right: 80),
                    child: ItemList(),
                  ),
                ],
              ),
              rectangularMenuArea: _getBottomAction(state, palette),
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
