import 'package:basic/player_progress/player_progress.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final achievements = context.read<PlayerProgress>().achievements;

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            Header(
              title: 'achievements'.tr(),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: AnimationLimiter(
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  padding: EdgeInsets.all(8),
                  crossAxisCount: 2,
                  childAspectRatio: (3 / 1.5),
                  children: List.generate(
                    achievements.length,
                    (index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: Container(
                              decoration: BoxDecoration(
                                color: achievements[index].isAchieve
                                    ? const Color.fromARGB(255, 224, 206, 86)
                                    : const Color.fromARGB(198, 239, 239, 239),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          margin: EdgeInsets.only(
                                            right: 8,
                                            left: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  achievements[index].isAchieve
                                                      ? const Color.fromARGB(
                                                          255, 146, 116, 71)
                                                      : const Color.fromARGB(
                                                          255, 190, 190, 190),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(120),
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          achievements[index].imageUrl,
                                          width: 30,
                                          height: 30,
                                          color: achievements[index].isAchieve
                                              ? const Color.fromARGB(
                                                  255, 146, 116, 71)
                                              : const Color.fromARGB(
                                                  255, 190, 190, 190),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            child: Text(
                                              achievements[index].title,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: achievements[index]
                                                        .isAchieve
                                                    ? const Color.fromARGB(
                                                        255, 146, 116, 71)
                                                    : const Color.fromARGB(
                                                        255, 190, 190, 190),
                                              ),
                                            ).tr(),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          FittedBox(
                                            child: Text(
                                              achievements[index].description,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: achievements[index]
                                                        .isAchieve
                                                    ? const Color.fromARGB(
                                                        255, 146, 116, 71)
                                                    : const Color.fromARGB(
                                                        255, 190, 190, 190),
                                              ),
                                            ).tr(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        rectangularMenuArea: BasicButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          child: Text(
            'back',
            style: TextStyle(
              color: palette.ink,
              fontSize: 18,
            ),
          ).tr(),
        ),
      ),
    );
  }
}
