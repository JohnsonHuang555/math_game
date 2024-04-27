import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../player_progress/player_progress.dart';
import '../style/responsive_screen.dart';

class IntroduceScreen extends StatefulWidget {
  const IntroduceScreen({super.key});

  @override
  State<IntroduceScreen> createState() => _IntroduceScreenState();
}

class _IntroduceScreenState extends State<IntroduceScreen> {
  String playerName = '';
  bool validate = false;

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.read<PlayerProgress>();

    return Scaffold(
      body: ResponsiveScreen(
        squarishMainArea: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'introduce_page_1_title'.tr(),
              body: 'introduce_page_1_desc'.tr(),
              image: Center(
                child: Lottie.asset(
                  'assets/animations/introduce.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            PageViewModel(
              title: 'introduce_page_2_title'.tr(),
              body: 'introduce_page_2_desc'.tr(),
              image: Center(
                child: SvgPicture.asset(
                  'assets/icons/select-symbol.svg',
                  width: 200,
                ),
              ),
            ),
            PageViewModel(
              title: 'introduce_page_3_title'.tr(),
              body: 'introduce_page_3_desc'.tr(),
              image: Center(
                child: SvgPicture.asset(
                  'assets/icons/select-number.svg',
                  width: 200,
                ),
              ),
            ),
            PageViewModel(
              title: 'introduce_page_4_title'.tr(),
              body: 'introduce_page_4_desc'.tr(),
              image: Center(
                child: SvgPicture.asset(
                  'assets/icons/combine-formula.svg',
                  width: 200,
                ),
              ),
            ),
            PageViewModel(
              title: 'introduce_page_5_title'.tr(),
              bodyWidget: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      maxLength: 8,
                      decoration: InputDecoration(
                          errorText:
                              validate ? 'name_already_exist'.tr() : null,
                          border: OutlineInputBorder(),
                          hintText: 'introduce_page_5_hint_text'.tr(),
                          labelText: 'introduce_page_5_label_text'.tr(),
                          helperText: 'introduce_page_5_helper_text'.tr()),
                      onChanged: (value) {
                        setState(() {
                          playerName = value;
                          validate = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              image: Center(
                child: Lottie.asset(
                  'assets/animations/write-name.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
          showNextButton: false,
          done: const Text('Let\'s GO'),
          onDone: () async {
            if (playerName == '') {
              return;
            }

            final isSuccess = await playerProgress.createNewPlayer(playerName);
            if (isSuccess && context.mounted) {
              GoRouter.of(context).pushReplacement('/');
            } else {
              setState(() {
                validate = true;
              });
            }
          },
        ),
        rectangularMenuArea: SizedBox.shrink(),
      ),
    );
  }
}
