import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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
      final isChecked = checkIsAlreadySelected(selectedFormulaItems, item.index);
      return GestureDetector(
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
                      color: isChecked ? palette.selectedItem : palette.ink,
                    ),
                  ),
          ],
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
        Text(
          '請組合出合理算式',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
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
                      FittedBox(
                        child: Text(
                          playerProgress.yourScore,
                          style: TextStyle(
                            fontSize: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _getBoardItems(palette),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        '= ?',
                        style: TextStyle(
                          fontSize: 36,
                        ),
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
        const SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.only(
            left: 75,
            right: 75,
          ),
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
      ],
    );
  }
}
