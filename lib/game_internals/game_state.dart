import 'dart:math';

import '../helpers/box_number.dart';
import '../helpers/game_risk.dart';
import '../helpers/math_symbol.dart';
import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
  // 遊戲階段
  int step = 1;
  // 遊戲風險
  int? _risk;
  // 當前符號
  List<MathSymbol> _boxSymbols = [];
  // 當前數字
  List<int> _boxNumbers = [];

  // 已選擇的符號
  List<SelectedMathSymbol> _selectSymbols = [];
  // 已選擇的數字
  List<int> _selectNumbers = [];

  int? get risk => _risk;
  List<MathSymbol> get boxSymbols => _boxSymbols;
  List<int> get boxNumbers => _boxNumbers;
  List<SelectedMathSymbol> get selectSymbols => _selectSymbols;
  List<int> get selectNumbers => _selectNumbers;

  GameState() {
    _risk = createGameRisk();
    _boxSymbols = _shuffleArray(createMathSymbols(_risk));
    _boxNumbers = _shuffleArray(createBoxNumbers(_risk));
  }

  List<T> _shuffleArray<T>(List<T> array) {
    var random = Random();
    for (var i = array.length - 1; i > 0; i--) {
      var j = random.nextInt(i + 1);
      var temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }

    return array;
  }

  void handleSelectMathSymbol(int index, MathSymbol mathSymbol) {
    var isAlreadySelected = _selectSymbols.singleWhere((element) => element.index == index, orElse: () {
      return SelectedMathSymbol(index: -1, mathSymbol: mathSymbol);
    });
    if (isAlreadySelected.index == -1) {
      _selectSymbols.add(SelectedMathSymbol(index: index, mathSymbol: mathSymbol));
    } else {
      _selectSymbols.removeWhere((element) => element.index == index);
    }
    print(_selectSymbols.length);
    notifyListeners();
  }
}
