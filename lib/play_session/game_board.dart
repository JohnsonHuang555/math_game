import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../helpers/math_symbol.dart';
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
    final audioController = context.read<AudioController>();

    return List.generate(9, (index) {
      final isChecked = checkIsAlreadySelected(selectedItems, index);
      return AnimationConfiguration.staggeredGrid(
        position: index,
        duration: const Duration(milliseconds: 375),
        columnCount: 3,
        child: ScaleAnimation(
          child: FadeInAnimation(
            child: ZoomTapAnimation(
              onTap: () {
                audioController.playSfx(SfxType.buttonGaming);
                onSelect(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: isChecked ? palette.selectedItem : palette.ink,
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
                          color: isChecked ? palette.selectedItem : palette.ink,
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: 3, //決定每列數量
        childAspectRatio: 1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: getGameCard(context),
      ),
    );
  }
}
