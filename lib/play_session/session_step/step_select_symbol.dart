import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../helpers/contain_hint_item.dart';
import '../../helpers/game_risk.dart';
import '../../helpers/math_symbol.dart';
import '../content_hint.dart';
import '../game_board.dart';
import '../../style/palette.dart';

class StepSelectSymbol extends StatelessWidget {
  final List<MathSymbol> mathSymbols;
  final List<SelectedItem> selectedSymbols;
  final Function(int, MathSymbol) onSelect;
  final bool showSelectResult;
  final List<ContainHintItem> containHintSymbolItems;
  const StepSelectSymbol({
    super.key,
    required this.mathSymbols,
    required this.onSelect,
    required this.showSelectResult,
    required this.selectedSymbols,
    required this.containHintSymbolItems,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();

    final items = mathSymbols.asMap().entries.map((entry) {
      int index = entry.key;
      final isSelected = checkIsAlreadySelected(selectedSymbols, index);
      return convertMathSymbolToIcon(
        mathSymbol: entry.value,
        isSelected: isSelected,
        palette: palette,
        size: 40,
      );
    }).toList();
    return Column(
      children: [
        const Text(
          'choose_three_items',
          style: TextStyle(
            fontSize: 18,
          ),
        ).tr(),
        const SizedBox(height: 20),
        GameBoard(
          items: items,
          onSelect: (index) {
            onSelect(index, mathSymbols[index]);
          },
          showSelectResult: showSelectResult,
          selectedItems: selectedSymbols,
        ),
        const SizedBox(height: 30),
        ContentHint(
          containHintItems: containHintSymbolItems,
        ),
      ],
    );
  }
}
