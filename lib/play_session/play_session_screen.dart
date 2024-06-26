// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../helpers/ad_helper.dart';
import '../helpers/math_symbol.dart';
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

  /// The banner ad to show. This is `null` until the ad is actually loaded.
  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;

  late BuildContext newContext;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadRewardedAd();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bannerAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      final playerProgress = newContext.read<PlayerProgress>();
      final gameState = newContext.read<GameState>();
      if (gameState.gameOver) {
        return;
      }
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
    BuildContext context,
    GameState state,
    Palette palette,
  ) {
    final audioController = context.read<AudioController>();

    switch (state.step) {
      case 1:
        return BasicButton(
          onPressed: () {
            audioController.playSfx(SfxType.buttonPlay);
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
          child: const Text(
            'selected',
            style: TextStyle(
              fontSize: 18,
            ),
          ).tr(),
        );
      case 2:
        return BasicButton(
          onPressed: () {
            audioController.playSfx(SfxType.buttonPlay);
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
          child: const Text(
            'selected',
            style: TextStyle(
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
                  audioController.playSfx(SfxType.buttonTap);
                  state.clearSelection();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/eraser.svg'),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'clear',
                      style: TextStyle(
                        fontSize: 18,
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
                onPressed: () async {
                  audioController.playSfx(SfxType.buttonPlay);
                  final playerProgress = context.read<PlayerProgress>();
                  final gameState = context.read<GameState>();
                  final yourScore = playerProgress.yourScore;
                  final newScore = state.getCurrentAnswer(yourScore);
                  if (state.selectedFormulaItems.length != 6) {
                    await Fluttertoast.showToast(
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
                        await Fluttertoast.showToast(
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
                    await Fluttertoast.showToast(
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
                  await Dialogs.materialDialog(
                    msg: 'confirm_complete'.tr(),
                    msgStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    title: 'calculate_score'.tr(),
                    titleStyle: const TextStyle(
                      fontSize: 22,
                    ),
                    context: context,
                    actions: [
                      BasicButton(
                        padding: 6.0,
                        onPressed: () {
                          audioController.playSfx(SfxType.buttonBack);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'cancel',
                          style: TextStyle(
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

                          await audioController.pauseMusic();
                          audioController.playSfx(SfxType.buttonTap);

                          final result = await playerProgress.saveNewScore(
                            newScore: newScore,
                            selectedSymbols: state.selectedSymbols,
                            selectedNumbers: state.selectedNumbers,
                          );
                          if (!result) {
                            throw Exception('setNewScore error');
                          }

                          // 清除 local storage
                          await playerProgress.removeCurrentPlayingData();
                          gameState.setGameOver();
                          if (!context.mounted) return;

                          audioController.playSfx(SfxType.congrats);
                          createCongratsDialog(context, newScore);
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
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
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

  /// Loads a banner ad.
  void _loadBannerAd() {
    final bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }

  /// Loads a rewarded ad.
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
            onAdShowedFullScreenContent: (ad) {},
            // Called when an impression occurs on the ad.
            onAdImpression: (ad) {},
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
            // Called when a click is recorded for an ad.
            onAdClicked: (ad) {},
          );

          // Keep a reference to the ad so you can show it later.
          setState(() {
            _rewardedAd = ad;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void createCongratsDialog(BuildContext context,String newScore) {
    final audioController = context.read<AudioController>();
    final palette = context.read<Palette>();

    Dialogs.materialDialog(
      customView: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          SvgPicture.asset(
            'assets/icons/congrats.svg',
            width: double.infinity,
            height: 120,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'new_score',
            style: TextStyle(
              fontSize: 24,
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
      // lottieBuilder: Lottie.asset(
      //   'assets/animations/congrats.json',
      //   fit: BoxFit.contain,
      // ),
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
                      borderRadius: BorderRadius.circular(100),
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
                        audioController.playSfx(SfxType.buttonTap);
                        GoRouter.of(context).pushReplacement('/');
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
                      borderRadius: BorderRadius.circular(100),
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
                        audioController.playSfx(SfxType.buttonTap);
                        GoRouter.of(context).pushReplacement('/play');
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
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    final playerProgress = context.read<PlayerProgress>();
    final audioController = context.read<AudioController>();

    Future.delayed(Duration.zero).then((_) {
      audioController.playMusic('play_session');
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GameState(playerProgress.currentPlayingData),
        ),
      ],
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: palette.backgroundMain,
          body: Consumer<GameState>(
            builder: ((context, state, child) {
              newContext = context;

              return ResponsiveScreen(
                topMessageArea: SizedBox(
                  height: 40,
                  child: Header(
                    leftChild: GestureDetector(
                      onTap: () {
                        audioController.playSfx(SfxType.buttonTap);
                        GoRouter.of(context).push('/settings');
                      },
                      child: const Icon(
                        Icons.settings,
                        size: 32,
                      ),
                    ),
                    rightChild: _rewardedAd != null
                        ? GestureDetector(
                            onTap: () {
                              audioController.playSfx(SfxType.buttonTap);
                              Dialogs.materialDialog(
                                title: 'modal_restart_title'.tr(),
                                titleStyle: TextStyle(
                                  fontSize: 22,
                                ),
                                msg: 'modal_restart_desc'.tr(),
                                msgStyle: TextStyle(
                                  fontSize: 18,
                                ),
                                msgAlign: TextAlign.center,
                                context: newContext,
                                actions: [
                                  BasicButton(
                                    padding: 6.0,
                                    onPressed: () {
                                      audioController
                                          .playSfx(SfxType.buttonBack);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'cancel',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ).tr(),
                                  ),
                                  BasicButton(
                                    padding: 6.0,
                                    bgColor: Colors.blueGrey,
                                    onPressed: () {
                                      audioController
                                          .playSfx(SfxType.buttonTap);
                                      _rewardedAd!.show(onUserEarnedReward:
                                          (AdWithoutView ad,
                                              RewardItem rewardItem) {
                                        GoRouter.of(context)
                                            .pushReplacement('/play');
                                      });
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
                            child: const Icon(
                              Icons.replay,
                              size: 34,
                            ),
                          )
                        : null,
                    title: _getStep(state.step).toString(),
                  ),
                ),
                squarishMainArea: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _bannerAd == null
                        ? const SizedBox(
                            height: 50,
                          )
                        // The actual ad.
                        : Container(
                            alignment: Alignment.center,
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                    const SizedBox(height: 30),
                    _getGameStep(state),
                  ],
                ),
                rectangularMenuArea: _getBottomAction(
                  context,
                  state,
                  palette,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
