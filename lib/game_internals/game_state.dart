import 'dart:math';

import '../helpers/box_number.dart';
import '../helpers/game_risk.dart';
import '../helpers/math_symbol.dart';
import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
  // 遊戲階段
  int _step = 1;
  // 遊戲風險
  int? _risk;
  // 當前符號
  List<MathSymbol> _boxSymbols = [];
  // 當前數字
  List<int> _boxNumbers = [];

  // 顯示選完的結果
  bool _showSelectResult = false;
  // 已選擇的符號
  List<SelectedItem> _selectSymbols = [];
  // 已選擇的數字
  List<int> _selectNumbers = [];

  int get step => _step;
  int? get risk => _risk;
  List<MathSymbol> get boxSymbols => _boxSymbols;
  List<int> get boxNumbers => _boxNumbers;
  bool get showSelectResult => _showSelectResult;
  List<SelectedItem> get selectSymbols => _selectSymbols;
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

  void handleNextStep() {
    _showSelectResult = true;
    Future.delayed(Duration(milliseconds: 2000), () {
      _showSelectResult = false;
      // _step = _step + 1;
      notifyListeners();
    });
    notifyListeners();
  }

  void handleSelectMathSymbol(int index, MathSymbol mathSymbol) {
    var isAlreadySelected = _selectSymbols
        .singleWhere((element) => element.index == index, orElse: () {
      return SelectedItem(index: -1);
    });
    if (isAlreadySelected.index == -1 && _selectSymbols.length < 3) {
      _selectSymbols.add(SelectedItem(index: index, mathSymbol: mathSymbol));
    } else {
      _selectSymbols.removeWhere((element) => element.index == index);
    }
    notifyListeners();
  }
}
