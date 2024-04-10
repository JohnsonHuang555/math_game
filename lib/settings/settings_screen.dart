// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/components/basic_button.dart';
import 'package:basic/components/header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.read<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            Header(
              title: '設定',
            ),
            const SizedBox(height: 30),
            ValueListenableBuilder<bool>(
              valueListenable: settings.soundsOn,
              builder: (context, soundsOn, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '音效',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      ToggleSwitch(
                        initialLabelIndex: soundsOn ? 0 : 1,
                        totalSwitches: 2,
                        labels: const ['ON', 'OFF'],
                        activeBgColors: const [
                          [Color.fromARGB(255, 48, 136, 209)],
                          [Color.fromARGB(255, 48, 136, 209)]
                        ],
                        inactiveBgColor: Color.fromARGB(255, 162, 165, 166),
                        inactiveFgColor: Colors.white,
                        onToggle: (_) {
                          settings.toggleSoundsOn();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: settings.musicOn,
              builder: (context, musicOn, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '音樂',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      ToggleSwitch(
                        initialLabelIndex: musicOn ? 0 : 1,
                        totalSwitches: 2,
                        activeBgColors: const [
                          [Color.fromARGB(255, 48, 136, 209)],
                          [Color.fromARGB(255, 48, 136, 209)]
                        ],
                        inactiveBgColor: Color.fromARGB(255, 162, 165, 166),
                        inactiveFgColor: Colors.white,
                        labels: const ['ON', 'OFF'],
                        onToggle: (_) {
                          settings.toggleMusicOn();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '語言',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  ToggleSwitch(
                    initialLabelIndex: 0,
                    totalSwitches: 2,
                    activeBgColors: const [
                      [Color.fromARGB(255, 48, 136, 209)],
                      [Color.fromARGB(255, 48, 136, 209)]
                    ],
                    inactiveBgColor: Color.fromARGB(255, 162, 165, 166),
                    inactiveFgColor: Colors.white,
                    labels: const ['繁中', 'En'],
                    onToggle: (index) {
                      print(index);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        rectangularMenuArea: BasicButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          child: Text(
            '返回',
            style: TextStyle(
              color: palette.ink,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
