import 'package:basic/helpers/math_symbol.dart';
import 'package:flutter/widgets.dart';

import '../content_hint.dart';
import '../game_board.dart';
import '../item_list.dart';

class StepSelectSymbol extends StatelessWidget {
  final List<MathSymbol> mathSymbols;
  final Function(int, MathSymbol) onSelect;
  const StepSelectSymbol({super.key, required this.mathSymbols, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    var items = mathSymbols.map((e) => convertMathSymbolToIcon(e)).toList();
    return Column(
      children: [
        GameBoard(
          items: items,
          onSelect:(index) {
            onSelect(index, mathSymbols[index]);
          },
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
