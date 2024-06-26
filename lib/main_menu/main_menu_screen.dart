// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../audio/sounds.dart';
import '../audio/audio_controller.dart';
import '../helpers/converters.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();
    final audioController = context.read<AudioController>();

    if (playerProgress.showIntroduceScreenModal) {
      Future.delayed(Duration.zero).then((_) {
        GoRouter.of(context).push('/intro');
      });
    }

    if (playerProgress.currentPlayingData != null) {
      Future.delayed(Duration.zero).then((_) {
        GoRouter.of(context).pushReplacement('/play');
      });
    }

    Future.delayed(Duration.zero).then((_) {
      audioController.playMusic('main_menu');
    });

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            const SizedBox(height: 100),
            SizedBox(
              height: 130,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: FittedBox(
                child: Text(
                  playerProgress.yourScore,
                  style: TextStyle(
                    fontSize: 64,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/crown.svg',
                  width: 36,
                  height: 36,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  getOrdinalSuffix(playerProgress.yourRank),
                  style: TextStyle(fontSize: 28),
                ),
              ],
            ),
          ],
        ),
        rectangularMenuArea: SizedBox(
          height: 300,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              ZoomTapAnimation(
                child: GestureDetector(
                  onTap: () {
                    audioController.playSfx(SfxType.buttonPlay);
                    GoRouter.of(context).pushReplacement('/play');
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const Icon(
                        Icons.play_arrow_rounded,
                        size: 70,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ZoomTapAnimation(
                    onTap: () {
                      audioController.playSfx(SfxType.buttonTap);
                      GoRouter.of(context).push('/achievements');
                    },
                    child: SvgPicture.asset(
                      'assets/icons/trophy.svg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  ZoomTapAnimation(
                    onTap: () {
                      audioController.playSfx(SfxType.buttonTap);
                      GoRouter.of(context).push('/leaderboard');
                    },
                    child: Icon(
                      Icons.leaderboard,
                      size: 36,
                    ),
                  ),
                  ZoomTapAnimation(
                    onTap: () {
                      audioController.playSfx(SfxType.buttonTap);
                      GoRouter.of(context).push('/settings');
                    },
                    child: Icon(
                      Icons.settings,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
