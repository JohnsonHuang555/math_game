import 'package:basic/helpers/math_symbol.dart';
import 'package:flutter/widgets.dart';

import '../content_hint.dart';
import '../game_board.dart';
import '../item_list.dart';

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
    var items = mathSymbols.map((e) => convertMathSymbolToIcon(e)).toList();
    return Column(
      children: [
        GameBoard(
          items: items,
          onSelect: (index) {
            onSelect(index, mathSymbols[index]);
          },
          showSelectResult: showSelectResult,
          selectedItem: selectedSymbols,
        ),
        SizedBox(height: 5),
        ContentHint(),
        SizedBox(height: 35),
        Padding(
          padding: EdgeInsets.only(left: 50, right: 50),
          child: ItemList(),
        )
      ],
    );
  }
}
