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
  final List<SelectedItem> _selectedSymbols = [];
  // 已選擇的數字
  final List<SelectedItem> _selectedNumbers = [];
  // 已選擇的算式項目
  final List<SelectedItem> _selectedFormulaItems = [];

  int get step => _step;
  int? get risk => _risk;
  List<MathSymbol> get boxSymbols => _boxSymbols;
  List<int> get boxNumbers => _boxNumbers;
  bool get showSelectResult => _showSelectResult;
  List<SelectedItem> get selectedSymbols => _selectedSymbols;
  List<SelectedItem> get selectedNumbers => _selectedNumbers;
  List<SelectedItem> get selectedFormulaItems => _selectedFormulaItems;

  List<SelectedItem> get currentSelectedItems {
    return [..._selectedSymbols, ..._selectedNumbers]
        .asMap()
        .entries
        .map((entry) {
      int index = entry.key;
      return SelectedItem(
        index: index,
        mathSymbol: entry.value.mathSymbol,
        number: entry.value.number,
      );
    }).toList();
  }

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
      _step = _step + 1;
      notifyListeners();
    });
    notifyListeners();
  }

  void handleSelectMathSymbol(int index, MathSymbol mathSymbol) {
    var isSelected = checkIsAlreadySelected(_selectedSymbols, index);
    if (!isSelected && _selectedSymbols.length < 3) {
      _selectedSymbols.add(SelectedItem(index: index, mathSymbol: mathSymbol));
    } else {
      _selectedSymbols.removeWhere((element) => element.index == index);
    }
    notifyListeners();
  }

  void handleSelectNumber(int index, int number) {
    var isSelected = checkIsAlreadySelected(_selectedNumbers, index);
    if (!isSelected && _selectedNumbers.length < 3) {
      _selectedNumbers.add(SelectedItem(index: index, number: number));
    } else {
      _selectedNumbers.removeWhere((element) => element.index == index);
    }
    notifyListeners();
  }

  void handleSelectAnswer(SelectedItem item) {
    var isSelected = checkIsAlreadySelected(_selectedFormulaItems, item.index);
    if (!isSelected) {
      _selectedFormulaItems.add(item);
    } else {
      _selectedFormulaItems.removeWhere((element) => element.index == item.index);
    }
    notifyListeners();
  }
}
