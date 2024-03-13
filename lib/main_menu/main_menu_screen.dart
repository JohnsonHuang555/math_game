// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../settings/settings.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            SizedBox(height: 80),
            SizedBox(
              width: 200,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            SizedBox(height: 50),
            Text(
              '1000',
              style: TextStyle(
                fontSize: 64,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/crown.svg',
                  width: 36,
                  height: 36,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '1st',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ],
        ),
        rectangularMenuArea: SizedBox(
          height: 300,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  GoRouter.of(context).go('/play');
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
                    Icon(
                      Icons.play_arrow_rounded,
                      size: 70,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    'assets/icons/trophy.svg',
                    width: 32,
                    height: 32,
                  ),
                  Icon(
                    Icons.leaderboard,
                    size: 36,
                  ),
                  Icon(
                    Icons.settings,
                    size: 36,
                  ),
                ],
              )
              // MyButton(
              //   onPressed: () {
              //     audioController.playSfx(SfxType.buttonTap);
              //     GoRouter.of(context).go('/play');
              //   },
              //   child: const Text('Play'),
              // ),
              // MyButton(
              //   onPressed: () => GoRouter.of(context).push('/settings'),
              //   child: const Text('Settings'),
              // ),
              // _gap,
              // Padding(
              //   padding: const EdgeInsets.only(top: 32),
              //   child: ValueListenableBuilder<bool>(
              //     valueListenable: settingsController.audioOn,
              //     builder: (context, audioOn, child) {
              //       return IconButton(
              //         onPressed: () => settingsController.toggleAudioOn(),
              //         icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
              //       );
              //     },
              //   ),
              // ),
              // _gap,
              // const Text('Music by Mr Smith'),
              // _gap,
            ],
          ),
        ),
      ),
    );
  }
}
