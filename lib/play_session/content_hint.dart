import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../helpers/math_symbol.dart';
import '../helpers/contain_hint_item.dart';
import '../style/palette.dart';

class ContentHint extends StatelessWidget {
  final List<ContainHintItem> containHintItems;
  const ContentHint({
    super.key,
    required this.containHintItems,
  });

  List<Widget> _getHints(Palette palette) {
    return List.generate(
      containHintItems.length,
      (index) => badges.Badge(
        badgeStyle: badges.BadgeStyle(
          shape: badges.BadgeShape.circle,
          badgeColor: palette.darkPen,
          padding: EdgeInsets.all(6),
          borderRadius: BorderRadius.circular(4),
          elevation: 0,
        ),
        badgeContent: Text(
          containHintItems[index].count.toString(),
          style: TextStyle(
            color: palette.trueWhite,
          ),
        ),
        position: badges.BadgePosition.topEnd(top: -15),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: containHintItems[index].mathSymbol != null
                ? convertMathSymbolToIcon(
                    mathSymbol: containHintItems[index].mathSymbol!,
                    isSelected: false,
                    palette: palette,
                    size: 14,
                  )
                : Text(
                    containHintItems[index].number!.toString(),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    double padding = 140;

    if (containHintItems.length <= 3) {
      padding = 120;
    } else if (containHintItems.length == 4) {
      padding = 100;
    } else if (containHintItems.length == 5) {
      padding = 90;
    } else if (containHintItems.length >= 6 && containHintItems.length < 8) {
      padding = 60;
    } else if (containHintItems.length >= 8 && containHintItems.length < 10) {
      padding = 40;
    }

    return Column(
      children: [
        FittedBox(
          child: const Text(
            'question_includes_content',
            style: TextStyle(
              fontSize: 18,
            ),
          ).tr(),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(left: padding, right: padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _getHints(palette),
          ),
        ),
      ],
    );
  }
}
