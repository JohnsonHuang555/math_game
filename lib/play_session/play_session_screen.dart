// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/helpers/math_symbol.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../components/basic_button.dart';
import '../components/header.dart';
import '../game_internals/game_state.dart';
import '../player_progress/player_progress.dart';
import '../play_session/session_step/step_combine_formula.dart';
import '../play_session/session_step/step_select_number.dart';
import '../play_session/session_step/step_select_symbol.dart';
import '../style/responsive_screen.dart';
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

class _PlaySessionScreenState extends State<PlaySessionScreen>
    with WidgetsBindingObserver {
  static final _log = Logger('PlaySessionScreen');

  late BuildContext tempContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      final playerProgress = context.read<PlayerProgress>();
      final gameState = tempContext.read<GameState>();
      playerProgress.saveCurrentPlayingData(
        step: gameState.step,
        boxSymbols: gameState.boxSymbols,
        boxNumbers: gameState.boxNumbers,
        selectedSymbols: gameState.selectedSymbols,
        selectedNumbers: gameState.selectedNumbers,
      );
    }
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
          containHintSymbolItems: state.containHintSymbolItems,
        );
      case 2:
        return StepSelectNumber(
          numbers: state.boxNumbers,
          onSelect: state.handleSelectNumber,
          showSelectResult: state.showSelectResult,
          selectedNumbers: state.selectedNumbers,
          containHintNumberItems: state.containHintNumberItems,
        );
      case 3:
        return StepCombineFormula(
          currentSelectedItems: state.currentSelectedItems,
          selectedFormulaItems: state.selectedFormulaItems,
          onSelectAnswer: state.handleSelectAnswer,
        );
      default:
        return const Text('something_wrong').tr();
    }
  }

  // 底部按鈕
  Widget _getBottomAction(
      BuildContext context, GameState state, Palette palette) {
    switch (state.step) {
      case 1:
        return BasicButton(
          onPressed: () {
            if (!state.showSelectResult) {
              if (state.selectedSymbols.length == 3) {
                state.handleNextStep();
                return;
              }
              Fluttertoast.showToast(
                msg: 'please_select_three'.tr(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: palette.redPen,
                textColor: palette.trueWhite,
                fontSize: 16,
              );
            }
          },
          child: Text(
            'selected',
            style: TextStyle(
              color: palette.ink,
              fontSize: 18,
            ),
          ).tr(),
        );
      case 2:
        return BasicButton(
          onPressed: () {
            if (!state.showSelectResult) {
              if (state.selectedNumbers.length == 3) {
                state.handleNextStep();
                return;
              }
              Fluttertoast.showToast(
                msg: 'please_select_three'.tr(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: palette.redPen,
                textColor: palette.trueWhite,
                fontSize: 16,
              );
            }
          },
          child: Text(
            'selected',
            style: TextStyle(
              color: palette.ink,
              fontSize: 18,
            ),
          ).tr(),
        );
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
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'clear',
                      style: TextStyle(
                        fontSize: 18,
                        color: palette.ink,
                      ),
                    ).tr(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: BasicButton(
                onPressed: () {
                  final playerProgress = context.read<PlayerProgress>();
                  final yourScore = playerProgress.yourScore;
                  final newScore = state.getCurrentAnswer(yourScore);
                  if (state.selectedFormulaItems.length != 6) {
                    Fluttertoast.showToast(
                      msg: 'each_one_must_be_used'.tr(),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: palette.redPen,
                      textColor: palette.trueWhite,
                      fontSize: 16,
                    );
                    return;
                  }

                  final checkDivideZeroIndex = state.selectedFormulaItems
                      .indexWhere(
                          (element) => element.mathSymbol == MathSymbol.divide);
                  if (checkDivideZeroIndex != -1) {
                    try {
                      final nextItem =
                          state.selectedFormulaItems[checkDivideZeroIndex + 1];
                      if (nextItem.number == 0) {
                        Fluttertoast.showToast(
                          msg: 'cannot_divide_zero'.tr(),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 2,
                          backgroundColor: palette.redPen,
                          textColor: palette.trueWhite,
                          fontSize: 16,
                        );
                        return;
                      }
                    } catch (e) {
                      _log.info('CheckDivideZero error: $e');
                    }
                  }

                  if (!state.checkFormula() || newScore == '?') {
                    Fluttertoast.showToast(
                      msg: 'format_error'.tr(),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: palette.redPen,
                      textColor: palette.trueWhite,
                      fontSize: 16,
                    );
                    return;
                  }
                  Dialogs.materialDialog(
                    msg: 'confirm_complete'.tr(),
                    msgStyle: TextStyle(
                      fontSize: 18,
                    ),
                    title: 'calculate_score'.tr(),
                    titleStyle: TextStyle(
                      fontSize: 22,
                    ),
                    msgAlign: TextAlign.end,
                    context: context,
                    barrierDismissible: false,
                    actions: [
                      BasicButton(
                        padding: 6.0,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'cancel',
                          style: TextStyle(
                            color: palette.ink,
                            fontSize: 16,
                          ),
                        ).tr(),
                      ),
                      BasicButton(
                        bgColor: Colors.blueGrey,
                        padding: 6.0,
                        onPressed: () async {
                          if (!context.mounted) return;
                          Navigator.of(context).pop();

                          final result = await playerProgress.saveNewScore(
                            newScore: newScore,
                            selectedSymbols: state.selectedSymbols,
                            selectedNumbers: state.selectedNumbers,
                          );
                          if (!result) {
                            throw Exception('setNewScore error');
                          }

                          if (!context.mounted) return;
                          // 清除 local storage
                          playerProgress.removeCurrentPlayingData();
                          Dialogs.materialDialog(
                            customView: Column(
                              children: [
                                const Text(
                                  'new_score',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ).tr(),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: FittedBox(
                                    child: Text(
                                      newScore,
                                      style: TextStyle(
                                        fontSize: 44,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            color: palette.trueWhite,
                            titleStyle: const TextStyle(
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
                                      ZoomTapAnimation(
                                        child: Container(
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
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      ZoomTapAnimation(
                                        child: Container(
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
                                              GoRouter.of(context)
                                                  .pushReplacement('/play');
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        child: Text(
                          'confirm',
                          style: TextStyle(
                            color: palette.trueWhite,
                            fontSize: 16,
                          ),
                        ).tr(),
                      ),
                    ],
                  );
                },
                child: Text(
                  'OK',
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
        return SizedBox.shrink();
    }
  }

  String _getStep(int step) {
    switch (step) {
      case 1:
        return 'math_symbol'.tr();
      case 2:
        return 'number'.tr();
      case 3:
        return 'combination'.tr();
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    final playerProgress = context.read<PlayerProgress>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GameState(playerProgress.currentPlayingData),
        ),
      ],
      child: Scaffold(
        backgroundColor: palette.backgroundMain,
        body: Consumer<GameState>(
          builder: ((context, state, child) {
            tempContext = context;

            return ResponsiveScreen(
              squarishMainArea: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Header(
                    leftChild: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push('/settings');
                      },
                      child: Icon(
                        Icons.settings,
                        size: 32,
                      ),
                    ),
                    rightChild: Icon(
                      Icons.help_outline,
                      size: 34,
                    ),
                    title: _getStep(state.step).toString(),
                  ),
                  const SizedBox(height: 60),
                  _getGameStep(state),
                ],
              ),
              rectangularMenuArea: _getBottomAction(context, state, palette),
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
