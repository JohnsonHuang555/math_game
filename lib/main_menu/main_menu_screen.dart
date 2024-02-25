// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
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
                SizedBox(
                  width: 26,
                  child: Image.asset(
                    'assets/icons/crown.png',
                  ),
                ),
                SizedBox(
                  width: 10,
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
                      Icons.play_arrow,
                      size: 60,
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
                  SizedBox(
                    width: 36,
                    child: Image.asset(
                      'assets/icons/medal.png',
                    ),
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
