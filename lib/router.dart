// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/achievements/achievements_screen.dart';
import 'package:basic/introduce/introduce_screen.dart';
import 'package:basic/leaderboard/leaderboard_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'main_menu/main_menu_screen.dart';
import 'play_session/play_session_screen.dart';
import 'settings/settings_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainMenuScreen(key: Key('main menu')),
      routes: [
        // GoRoute(
        //   path: 'play',
        //   pageBuilder: (context, state) => buildMyTransition<void>(
        //     key: ValueKey('play'),
        //     color: context.watch<Palette>().backgroundLevelSelection,
        //     child: const PlaySessionScreen(
        //       key: Key('play session'),
        //     ),
        //   ),
        //   // routes: [
        //   //   GoRoute(
        //   //     path: 'session/:level',
        //   //     pageBuilder: (context, state) {
        //   //       final levelNumber = int.parse(state.pathParameters['level']!);
        //   //       final level =
        //   //           gameLevels.singleWhere((e) => e.number == levelNumber);
        //   //       return buildMyTransition<void>(
        //   //         key: ValueKey('level'),
        //   //         color: context.watch<Palette>().backgroundPlaySession,
        //   //         child: PlaySessionScreen(
        //   //           level,
        //   //           key: const Key('play session'),
        //   //         ),
        //   //       );
        //   //     },
        //   //   ),
        //   //   GoRoute(
        //   //     path: 'won',
        //   //     redirect: (context, state) {
        //   //       if (state.extra == null) {
        //   //         // Trying to navigate to a win screen without any data.
        //   //         // Possibly by using the browser's back button.
        //   //         return '/';
        //   //       }

        //   //       // Otherwise, do not redirect.
        //   //       return null;
        //   //     },
        //   //     pageBuilder: (context, state) {
        //   //       final map = state.extra! as Map<String, dynamic>;
        //   //       final score = map['score'] as Score;

        //   //       return buildMyTransition<void>(
        //   //         key: ValueKey('won'),
        //   //         color: context.watch<Palette>().backgroundPlaySession,
        //   //         child: WinGameScreen(
        //   //           score: score,
        //   //           key: const Key('win game'),
        //   //         ),
        //   //       );
        //   //     },
        //   //   )
        //   // ],
        // ),
        GoRoute(
          path: 'play',
          builder: (context, state) =>
              const PlaySessionScreen(key: Key('play')),
        ),
        GoRoute(
          path: 'leaderboard',
          builder: (context, state) =>
              const LeaderboardScreen(key: Key('leaderboard')),
        ),
        GoRoute(
          path: 'achievements',
          builder: (context, state) =>
              const AchievementsScreen(key: Key('achievements')),
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
        GoRoute(
          path: 'intro',
          builder: (context, state) => const IntroduceScreen(key: Key('intro')),
        ),
      ],
    ),
  ],
);
