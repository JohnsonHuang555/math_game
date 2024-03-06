import 'package:basic/helpers/math_symbol.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../helpers/game_risk.dart';
import '../style/palette.dart';

class GameBoard extends StatelessWidget {
  final List<Widget> items;
  final List<SelectedItem> selectedItems;
  final Function(int index) onSelect;
  final bool showSelectResult;
  const GameBoard({
    super.key,
    required this.items,
    required this.onSelect,
    required this.showSelectResult,
    required this.selectedItems,
  });

  List<Widget> getGameCard(BuildContext context) {
    final palette = context.read<Palette>();

    return List.generate(9, (index) {
      var isChecked = checkIsAlreadySelected(selectedItems, index);
      return GestureDetector(
        onTap: () {
          onSelect(index);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color:
                  isChecked ? palette.selectedItem : palette.ink,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: showSelectResult
                ? items[index]
                : SvgPicture.asset(
                    'assets/icons/question.svg',
                    width: 70,
                    height: 70,
                    color: isChecked
                        ? palette.selectedItem
                        : palette.ink,
                  ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3, //決定每列數量
      childAspectRatio: 1,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: getGameCard(context),
    );
  }
}
