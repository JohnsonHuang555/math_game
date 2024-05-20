import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';
import '../../helpers/game_risk.dart';
import '../../player_progress/player_progress.dart';
import '../../style/palette.dart';
import '../../helpers/math_symbol.dart';

class StepCombineFormula extends StatelessWidget {
  final List<SelectedItem> currentSelectedItems;
  final List<SelectedItem> selectedFormulaItems;
  final Function(SelectedItem) onSelectAnswer;
  const StepCombineFormula({
    super.key,
    required this.currentSelectedItems,
    required this.selectedFormulaItems,
    required this.onSelectAnswer,
  });

  List<Widget> _getBoardItems(Palette palette) {
    return selectedFormulaItems.map((item) {
      if (item.mathSymbol != null) {
        return Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          child: convertMathSymbolToIcon(
            mathSymbol: item.mathSymbol!,
            isSelected: false,
            palette: palette,
            size: 36,
          ),
        );
      }
      // 負數需要加括號
      final numberVal = item.number.toString();
      return Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        child: Text(
          item.number! < 0 ? '($numberVal)' : numberVal,
          style: const TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _getCurrentSelectItems(
      Palette palette, AudioController audioController) {
    return currentSelectedItems.map((item) {
      final isChecked = checkIsAlreadySelected(
        selectedFormulaItems,
        item.index,
      );
      return AnimationConfiguration.staggeredGrid(
        position: item.index,
        duration: const Duration(milliseconds: 375),
        columnCount: 3,
        child: ScaleAnimation(
          child: FadeInAnimation(
            child: ZoomTapAnimation(
              onTap: () {
                audioController.playSfx(SfxType.buttonGaming);
                onSelectAnswer(item);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: isChecked ? palette.selectedItem : palette.ink,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  item.mathSymbol != null
                      ? convertMathSymbolToIcon(
                          mathSymbol: item.mathSymbol!,
                          isSelected: isChecked,
                          palette: palette,
                          size: 28,
                        )
                      : Text(
                          item.number.toString(),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color:
                                isChecked ? palette.selectedItem : palette.ink,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    final playerProgress = context.read<PlayerProgress>();
    final audioController = context.read<AudioController>();

    return Column(
      children: [
        const Text(
          'combine_formula',
          style: TextStyle(
            fontSize: 20,
          ),
        ).tr(),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 270,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 220, 234, 204),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 2),
          ),
          margin: const EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              const Text(
                                'current_score',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ).tr(),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                playerProgress.yourScore,
                                style: TextStyle(
                                  fontSize: 36,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      selectedFormulaItems.isNotEmpty
                          ? FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _getBoardItems(palette),
                                ),
                              ),
                            )
                          : FittedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'please_click_symbol_or_number',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 135, 135, 135),
                                    ),
                                  ).tr(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'select_symbol_first',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 135, 135, 135),
                                    ),
                                  ).tr(),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '= ?',
                            style: TextStyle(
                              fontSize: 38,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'step_three_hint',
          textAlign: TextAlign.center,
        ).tr(),
        const SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.only(
            left: 60,
            right: 60,
          ),
          child: AnimationLimiter(
            child: GridView.count(
              crossAxisCount: 3, //決定每列數量
              childAspectRatio: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: _getCurrentSelectItems(palette, audioController),
            ),
          ),
        ),
      ],
    );
  }
}
