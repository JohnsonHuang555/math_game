import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.read<PlayerProgress>();

    return Scaffold(
      body: ResponsiveScreen(
        squarishMainArea: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Welcome to 算式拼圖',
              body: '遊戲分為三個階段，符號、數字、組合，運用所選的符號與數字組合成合理的算式，得出最高積分與全世界的玩家一較高下！',
              image: Center(
                child: Lottie.asset(
                  'assets/animations/introduce.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            PageViewModel(
              title: '選符號',
              body: '每個格子會隨機產生加減乘除其中一種符號，請在九個格子中選取三個，並進入下一個階段',
              image: Center(
                child: SvgPicture.asset(
                  'assets/icons/select-symbol.svg',
                  width: 200,
                ),
              ),
            ),
            PageViewModel(
              title: '選數字',
              body: '每個格子會隨機產生 -9~9 其中一個數字，請在九個格子中選取三個，並進入下一個階段',
              image: Center(
                child: SvgPicture.asset(
                  'assets/icons/select-number.svg',
                  width: 200,
                ),
              ),
            ),
            PageViewModel(
              title: '組合算式',
              body: '運用前兩個階段抽的符號與數字組合出合理的算式，得到的結果會更新到積分上，會影響排名及成就',
              image: Center(
                child: SvgPicture.asset(
                  'assets/icons/combine-formula.svg',
                  width: 200,
                ),
              ),
            ),
            PageViewModel(
              title: '開始遊戲',
              bodyWidget: Column(
                children: [
                  SizedBox(height: 20,),
                  Text(
                    '遊戲暱稱',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      maxLength: 8,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '請輸入遊戲暱稱',
                      ),
                      onChanged: (value) {
                        setState(() {
                          playerName = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    '暱稱輸入後不能更改',
                    style: TextStyle(
                      fontSize: 14,
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
          // showBackButton: true,
          showNextButton: false,
          done: const Text('Let\'s GO'),
          onDone: () async {
            final isSuccess = await playerProgress.createNewPlayer(playerName);
            if (isSuccess && context.mounted) {
              print('succccc');
              Navigator.of(context).pop();
            }
          },
        ),
        rectangularMenuArea: SizedBox.shrink(),
      ),
    );
  }
}
