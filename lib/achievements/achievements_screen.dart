import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../components/basic_button.dart';
import '../components/header.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            const Header(
              title: '成就',
            ),
            const SizedBox(height: 30),
            // Expanded(
            //   child: AnimationLimiter(
            //     child: ListView.builder(
            //       itemCount: topTenUsers.length,
            //       itemBuilder: (context, index) {
            //         return AnimationConfiguration.staggeredList(
            //           position: index,
            //           duration: const Duration(milliseconds: 375),
            //           child: SlideAnimation(
            //             verticalOffset: 50.0,
            //             child: FadeInAnimation(
            //               child: LeaderboardPlayer(
            //                 rank: rank++,
            //                 name: topTenUsers[index]['name'] as String,
            //                 score: topTenUsers[index]['score'].toString(),
            //                 highlight: playerProgress.userId ==
            //                     topTenUsers[index].id as String,
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // )
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
