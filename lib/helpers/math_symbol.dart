import 'package:basic/style/palette.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum MathSymbol {
  plus,
  minus,
  times,
  divide,
  square,
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
        var plus = _createBoxes(MathSymbol.plus, 4);
        var minus = _createBoxes(MathSymbol.minus, 5);
        return [...plus, ...minus];
      case 3:
        var plus = _createBoxes(MathSymbol.plus, 3);
        var minus = _createBoxes(MathSymbol.minus, 4);
        var times = _createBoxes(MathSymbol.times, 1);
        var divide = _createBoxes(MathSymbol.divide, 1);
        return [...plus, ...minus, ...times, ...divide];
      case 4:
        var plus = _createBoxes(MathSymbol.plus, 2);
        var minus = _createBoxes(MathSymbol.minus, 3);
        var times = _createBoxes(MathSymbol.times, 2);
        var divide = _createBoxes(MathSymbol.divide, 2);
        return [...plus, ...minus, ...times, ...divide];
      case 5:
        var plus = _createBoxes(MathSymbol.plus, 1);
        var minus = _createBoxes(MathSymbol.minus, 2);
        var times = _createBoxes(MathSymbol.times, 3);
        var divide = _createBoxes(MathSymbol.divide, 3);
        return [...plus, ...minus, ...times, ...divide];
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
        var plus = _createBoxes(MathSymbol.square, 6);
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
    MathSymbol.square: SvgPicture.asset(
      'assets/icons/two_squared.svg',
      width: size * 1.5,
      height: size * 1.5,
      color: isSelected ? palette.selectedItem : palette.ink,
    )
  };
  return mathSymbolMap[mathSymbol] as Widget;
}

class SelectedItem {
  int index;
  MathSymbol? mathSymbol;
  int? number;
  SelectedItem({required this.index, this.mathSymbol, this.number});
}
