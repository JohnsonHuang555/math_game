import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum MathSymbol {
  plus,
  minus,
  times,
  divide,
  // ...
}

List<MathSymbol> createMathSymbols(int? risk) {
  if (risk != null) {
    switch (risk) {
      case 1:
        var plus = _createBoxes(MathSymbol.plus, 6);
        var minus = _createBoxes(MathSymbol.minus, 3);
        return [...plus, ...minus];
      case 2:
        var plus = _createBoxes(MathSymbol.plus, 6);
        var minus = _createBoxes(MathSymbol.minus, 3);
        return [...plus, ...minus];
      case 3:
        var plus = _createBoxes(MathSymbol.plus, 6);
        var minus = _createBoxes(MathSymbol.minus, 3);
        return [...plus, ...minus];
      case 4:
        var plus = _createBoxes(MathSymbol.plus, 6);
        var minus = _createBoxes(MathSymbol.minus, 3);
        return [...plus, ...minus];
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
        var plus = _createBoxes(MathSymbol.plus, 6);
        var minus = _createBoxes(MathSymbol.minus, 3);
        return [...plus, ...minus];
      default:
        return [];
    }
  }
  return [];
}

List<T> _createBoxes<T>(T symbol, int count) {
  List<T> arr = [];
  for (var i = 0; i < count; i++) {
    arr.add(symbol);
  }
  return arr;
}

Widget convertMathSymbolToIcon(MathSymbol mathSymbol) {
  var mathSymbolMap = <MathSymbol, Widget>{
    MathSymbol.plus: FaIcon(
      FontAwesomeIcons.plus,
      size: 40,
    ),
    MathSymbol.minus: FaIcon(
      FontAwesomeIcons.minus,
      size: 40,
    ),
    MathSymbol.times: FaIcon(
      FontAwesomeIcons.xmark,
      size: 40,
    ),
    MathSymbol.divide: FaIcon(
      FontAwesomeIcons.divide,
      size: 40,
    ),
  };
  return mathSymbolMap[mathSymbol] as Widget;
}

class SelectedMathSymbol {
  int index;
  MathSymbol mathSymbol;
  SelectedMathSymbol({required this.index, required this.mathSymbol});
}
