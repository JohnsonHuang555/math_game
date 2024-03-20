import 'package:basic/helpers/math_symbol.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../helpers/game_risk.dart';
import '../../style/palette.dart';
import '../content_hint.dart';
import '../game_board.dart';

class StepSelectNumber extends StatelessWidget {
  final List<int> numbers;
  final List<SelectedItem> selectedNumbers;
  final Function(int, int) onSelect;
  final bool showSelectResult;
  const StepSelectNumber({
    super.key,
    required this.numbers,
    required this.onSelect,
    required this.showSelectResult,
    required this.selectedNumbers,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();

    var items = numbers.asMap().entries.map((entry) {
      int index = entry.key;
      var isSelected = checkIsAlreadySelected(selectedNumbers, index);
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
        Text(
          '請選擇三個',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10),
        GameBoard(
          items: items,
          onSelect: (index) {
            onSelect(index, numbers[index]);
          },
          showSelectResult: showSelectResult,
          selectedItems: selectedNumbers,
        ),
        SizedBox(height: 10),
        ContentHint(),
      ],
    );
  }
}
