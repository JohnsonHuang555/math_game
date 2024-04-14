import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../helpers/math_symbol.dart';
import '../../helpers/contain_hint_item.dart';
import '../../helpers/game_risk.dart';
import '../../style/palette.dart';
import '../content_hint.dart';
import '../game_board.dart';

class StepSelectNumber extends StatelessWidget {
  final List<int> numbers;
  final List<SelectedItem> selectedNumbers;
  final Function(int, int) onSelect;
  final bool showSelectResult;
  final List<ContainHintItem> containHintNumberItems;
  const StepSelectNumber({
    super.key,
    required this.numbers,
    required this.onSelect,
    required this.showSelectResult,
    required this.selectedNumbers,
    required this.containHintNumberItems,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();

    final items = numbers.asMap().entries.map((entry) {
      int index = entry.key;
      final isSelected = checkIsAlreadySelected(selectedNumbers, index);
      return Text(
        entry.value.toString(),
        style: TextStyle(
          fontSize: 40,
          color: isSelected ? palette.selectedItem : palette.ink,
        ),
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
        const SizedBox(height: 10),
        GameBoard(
          items: items,
          onSelect: (index) {
            onSelect(index, numbers[index]);
          },
          showSelectResult: showSelectResult,
          selectedItems: selectedNumbers,
        ),
        const SizedBox(height: 10),
        ContentHint(
          containHintItems: containHintNumberItems,
        ),
      ],
    );
  }
}
