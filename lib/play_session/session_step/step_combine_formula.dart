import '../../helpers/math_symbol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../helpers/game_risk.dart';
import '../../style/palette.dart';

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
            size: 26,
          ),
        );
      }
      return Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Text(
          item.number.toString(),
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _getCurrentSelectItems(Palette palette) {
    return currentSelectedItems.map((item) {
      var isChecked = checkIsAlreadySelected(selectedFormulaItems, item.index);
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

    return Column(
      children: [
        Text(
          '請組合出合理算式',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 15),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Color(0xffE6E6E6),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          child: Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: _getBoardItems(palette),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          '= ?',
          style: TextStyle(
            fontSize: 44,
          ),
        ),
        SizedBox(height: 20),
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
