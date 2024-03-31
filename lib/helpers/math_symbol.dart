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
  final random = Random();
  final index = random.nextInt(symbols.length);
  return symbols[index];
}

List<MathSymbol> createMathSymbols() {
  final details = {
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
  final mathSymbolMap = <MathSymbol, Widget>{
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

  SelectedItem.fromJson(
    Map<String, dynamic> json,
  )    // This Function helps to convert our Map into our User Object
  : index = json['index'] as int,
        mathSymbol = json['mathSymbol'] != null
            ? getMathSymbol(json['mathSymbol'] as String)
            : null,
        number = json['number'] != null ? json['number'] as int : null;

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'mathSymbol': mathSymbol?.toString(),
      'number': number ?? number,
    };
  }
}

MathSymbol getMathSymbol(String mathSymbolStr) {
  MathSymbol symbol = MathSymbol.values
      .firstWhere((element) => element.toString() == mathSymbolStr);
  return symbol;
}
