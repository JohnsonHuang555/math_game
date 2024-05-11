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
    final currentLanguage = context.locale.toString();

    return Scaffold(
      body: ResponsiveScreen(
        squarishMainArea: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'introduce_page_1_title'.tr(),
              bodyWidget: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: Center(
                      child: Lottie.asset(
                        'assets/animations/introduce.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'introduce_page_1_desc',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ).tr(),
                ],
              ),
            ),
            PageViewModel(
              title: 'introduce_page_2_title'.tr(),
              bodyWidget: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 450,
                    child: Center(
                      child: Image.asset(
                        currentLanguage == 'zh_TW'
                            ? 'assets/images/select_symbol_zh_tw.png'
                            : 'assets/images/select_symbol_en_us.png',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'introduce_page_2_desc',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ).tr(),
                ],
              ),
            ),
            PageViewModel(
              title: 'introduce_page_3_title'.tr(),
              bodyWidget: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 450,
                    child: Center(
                      child: Image.asset(
                        currentLanguage == 'zh_TW'
                            ? 'assets/images/select_number_zh_tw.png'
                            : 'assets/images/select_number_en_us.png',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'introduce_page_3_desc',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ).tr(),
                ],
              ),
            ),
            PageViewModel(
              title: 'introduce_page_4_title'.tr(),
              bodyWidget: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 450,
                    child: Center(
                      child: Image.asset(
                        currentLanguage == 'zh_TW'
                            ? 'assets/images/combine_formula_zh_tw.png'
                            : 'assets/images/combine_formula_en_us.png',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'introduce_page_4_desc',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ).tr(),
                ],
              ),
            ),
            PageViewModel(
              title: 'introduce_page_5_title'.tr(),
              bodyWidget: Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      maxLength: 8,
                      decoration: InputDecoration(
                          errorText:
                              validate ? 'name_already_exist'.tr() : null,
                          border: const OutlineInputBorder(),
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
                child: SvgPicture.asset(
                  'assets/icons/combine-formula.svg',
                  width: 200,
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
        rectangularMenuArea: const SizedBox.shrink(),
      ),
    );
  }
}
