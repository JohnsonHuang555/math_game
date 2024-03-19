import 'package:basic/helpers/math_symbol.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../helpers/game_risk.dart';
import '../../style/palette.dart';
import '../content_hint.dart';
import '../game_board.dart';

class StepSelectSymbol extends StatelessWidget {
  final List<MathSymbol> mathSymbols;
  final List<SelectedItem> selectedSymbols;
  final Function(int, MathSymbol) onSelect;
  final bool showSelectResult;
  const StepSelectSymbol({
    super.key,
    required this.mathSymbols,
    required this.onSelect,
    required this.showSelectResult,
    required this.selectedSymbols,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();

    var items = mathSymbols.asMap().entries.map((entry) {
      int index = entry.key;
      var isSelected = checkIsAlreadySelected(selectedSymbols, index);
      return convertMathSymbolToIcon(
        mathSymbol: entry.value,
        isSelected: isSelected,
        palette: palette,
        size: 40,
      );
    }).toList();
    return Column(
      children: [
        Text(
          '請選擇三個',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 15),
        GameBoard(
          items: items,
          onSelect: (index) {
            onSelect(index, mathSymbols[index]);
          },
          showSelectResult: showSelectResult,
          selectedItems: selectedSymbols,
        ),
        SizedBox(height: 5),
        ContentHint(),
      ],
    );
  }
}
