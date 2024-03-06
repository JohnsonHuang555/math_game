import 'package:basic/helpers/math_symbol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../style/palette.dart';

class StepCombineFormula extends StatelessWidget {
  final List<SelectedItem> currentSelectedItems;
  final Function() onSelectAnswer;
  // final bool showSelectResult;
  const StepCombineFormula({
    super.key,
    // required this.onSelect,
    // required this.showSelectResult,
    required this.currentSelectedItems,
    required this.onSelectAnswer,
  });

  List<Widget> _getBoardItems() {
    List<Widget> items = [];
    return items;
  }

  List<Widget> _getCurrentSelectItems(Palette palette) {
    return currentSelectedItems.map((e) {
      // print(e);
      return GestureDetector(
        onTap: () {},
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  // color:
                  //     isChecked ? palette.selectedItem : palette.ink,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            e.mathSymbol != null
                ? convertMathSymbolToIcon(e.mathSymbol!, false, palette)
                : Text(
                    e.number.toString(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ],
        ),
      );
      // if (e.mathSymbol != null) {
      //   return Text('?');
      // }
      // if (e.number == null) {
      //   return Text('?');
      // }
      // return Text('?');
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
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 240,
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
              children: _getBoardItems(),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          '= ?',
          style: TextStyle(
            fontSize: 44,
          ),
        ),
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
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: _getCurrentSelectItems(palette),
          ),
        ),
      ],
    );
  }
}
