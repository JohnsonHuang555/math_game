import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

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
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Text(
          item.number! < 0 ? '($numberVal)' : numberVal,
          style: TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _getCurrentSelectItems(Palette palette) {
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

    return Column(
      children: [
        const Text(
          'combine_formula',
          style: TextStyle(
            fontSize: 18,
          ),
        ).tr(),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 270,
          decoration: BoxDecoration(
            color: Color(0xffE6E6E6),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(
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
                            width: 30,
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
                          Text(
                            playerProgress.yourScore,
                            style: TextStyle(
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
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
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ).tr(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'select_symbol_first',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
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
                              fontSize: 36,
                            ),
                          ),
                          SizedBox(
                            width: 30,
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
        const SizedBox(height: 60),
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
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: _getCurrentSelectItems(palette),
            ),
          ),
        ),
      ],
    );
  }
}
