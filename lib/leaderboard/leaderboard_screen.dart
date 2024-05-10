import 'package:basic/components/header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../audio/sounds.dart';
import '../audio/audio_controller.dart';
import '../components/basic_button.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import './player.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  List<Widget> getPlayers(List<dynamic> topTenUsers, String userId) {
    int rank = 1;
    List<Widget> list = [];
    for (final user in topTenUsers) {
      list.add(LeaderboardPlayer(
        rank: rank++,
        name: user['name'] as String,
        score: user['score'].toString(),
        highlight: userId == user.id as String,
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.read<PlayerProgress>();
    final audioController = context.read<AudioController>();

    return FutureBuilder(
      future: playerProgress.getTopTenPlayers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: palette.backgroundMain,
            body: Center(
              child: const Text(
                'loading',
                style: TextStyle(
                  fontSize: 26,
                ),
              ).tr(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: palette.backgroundMain,
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontFamily: 'Saira',
                  fontSize: 26,
                ),
              ),
            ),
          );
        }

        List<dynamic> topTenUsers = snapshot.data as List<dynamic>;
        int rank = 1;

        return Scaffold(
          backgroundColor: palette.backgroundMain,
          body: ResponsiveScreen(
            squarishMainArea: Column(
              children: [
                const Header(
                  title: 'TOP 20',
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: topTenUsers.length,
                      itemBuilder: (context, index) {
                        final highlight = playerProgress.userId ==
                            topTenUsers[index].id as String;

                        List<Color> colors = [];
                        switch (rank) {
                          case 1:
                            colors = [
                              Color(0xffFFD700),
                              Color.fromARGB(255, 255, 245, 166),
                            ];
                            break;
                          case 2:
                            colors = [
                              Color.fromARGB(255, 178, 178, 178),
                              Color.fromARGB(192, 228, 228, 228),
                            ];
                            break;
                          case 3:
                            colors = [
                              Color.fromARGB(255, 229, 158, 92),
                              Color.fromARGB(255, 255, 218, 184),
                            ];
                            break;
                          default:
                            colors = [
                              Color.fromARGB(198, 239, 239, 239),
                              Color.fromARGB(198, 239, 239, 239),
                            ];
                            break;
                        }

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            child: FadeInAnimation(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: highlight ? 3 : 1,
                                      color: highlight
                                          ? palette.selectedItem
                                          : palette.ink),
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: colors,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30.0,
                                    right: 16.0,
                                    top: 16.0,
                                    bottom: 16.0,
                                  ),
                                  child: LeaderboardPlayer(
                                    rank: rank++,
                                    name: topTenUsers[index]['name'] as String,
                                    score:
                                        topTenUsers[index]['score'].toString(),
                                    highlight: highlight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
            rectangularMenuArea: Column(
              children: [
                Divider(
                  thickness: 1,
                  color: palette.ink,
                ),
                const SizedBox(
                  height: 10,
                ),
                LeaderboardPlayer(
                  name: 'your_score'.tr(),
                  score: playerProgress.yourScore,
                  highlight: false,
                ),
                const SizedBox(
                  height: 30,
                ),
                BasicButton(
                  onPressed: () {
                    audioController.playSfx(SfxType.buttonBack);
                    GoRouter.of(context).pop();
                  },
                  child: Text(
                    'back',
                    style: TextStyle(
                      color: palette.ink,
                      fontSize: 18,
                    ),
                  ).tr(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
