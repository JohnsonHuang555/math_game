import 'dart:math';

import 'package:basic/style/palette.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum MathSymbol {
  plus,
  minus,
  times,
  divide,
}

MathSymbol getSymbol(List<MathSymbol> symbols) {
  var random = Random();
  var index = random.nextInt(symbols.length);
  return symbols[index];
}

List<MathSymbol> createMathSymbols() {
  var details = {
     MathSymbol.plus: 25,
     MathSymbol.minus: 25,
     MathSymbol.times: 25,
     MathSymbol.divide: 25,
  };

  List<MathSymbol> totalSymbols = [];
  details.forEach((key, value) {
    for (var i = 0; i < value; i++) {
      totalSymbols.add(key);
    }
  });

  List<MathSymbol> result = [];
  for (int i = 0; i < 9; i++) {
    result.add(getSymbol(totalSymbols));
  }

  return result;
}

Widget convertMathSymbolToIcon({
  required MathSymbol mathSymbol,
  required bool isSelected,
  required Palette palette,
  required double size,
}) {
  var mathSymbolMap = <MathSymbol, Widget>{
    MathSymbol.plus: FaIcon(
      FontAwesomeIcons.plus,
      size: size,
      color: isSelected ? palette.selectedItem : palette.ink,
    ),
    MathSymbol.minus: FaIcon(
      FontAwesomeIcons.minus,
      size: size,
      color: isSelected ? palette.selectedItem : palette.ink,
    ),
    MathSymbol.times: FaIcon(
      FontAwesomeIcons.xmark,
      size: size,
      color: isSelected ? palette.selectedItem : palette.ink,
    ),
    MathSymbol.divide: FaIcon(
      FontAwesomeIcons.divide,
      size: size,
      color: isSelected ? palette.selectedItem : palette.ink,
    ),
  };
  return mathSymbolMap[mathSymbol] as Widget;
}

class SelectedItem {
  int index;
  MathSymbol? mathSymbol;
  int? number;
  SelectedItem({required this.index, this.mathSymbol, this.number});
}
