import 'package:basic/helpers/contain_hint_item.dart';
import 'package:basic/helpers/current_playing_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

import '../helpers/box_number.dart';
import '../helpers/game_risk.dart';
import '../helpers/math_symbol.dart';

class GameState extends ChangeNotifier {
  // 遊戲階段
  int _step = 1;
  // 當前符號
  List<MathSymbol> _boxSymbols = [];
  // 當前數字
  List<int> _boxNumbers = [];

  // 顯示選完的結果
  bool _showSelectResult = false;
  // 已選擇的符號
  List<SelectedItem> _selectedSymbols = [];
  // 已選擇的數字
  List<SelectedItem> _selectedNumbers = [];
  // 已選擇的算式項目
  final List<SelectedItem> _selectedFormulaItems = [];

  // 是否遊戲結束
  bool _gameOver = false;

  GameState(CurrentPlayingData? data) {
    if (data != null) {
      _step = data.step;
      _boxSymbols = data.boxSymbols;
      _boxNumbers = data.boxNumbers;
      _selectedSymbols = data.selectedSymbols;
      _selectedNumbers = data.selectedNumbers;
    } else {
      _boxSymbols = createMathSymbols();
      _boxNumbers = createBoxNumbers();
    }
  }

  int get step => _step;
  List<MathSymbol> get boxSymbols => _boxSymbols;
  List<int> get boxNumbers => _boxNumbers;
  bool get showSelectResult => _showSelectResult;
  List<SelectedItem> get selectedSymbols => _selectedSymbols;
  List<SelectedItem> get selectedNumbers => _selectedNumbers;
  List<SelectedItem> get selectedFormulaItems => _selectedFormulaItems;
  bool get gameOver => _gameOver;

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

  // 符號提示內容物
  List<ContainHintItem> get containHintSymbolItems {
    final symbolMap = <MathSymbol, int>{
      MathSymbol.plus: 0,
      MathSymbol.minus: 0,
      MathSymbol.times: 0,
      MathSymbol.divide: 0,
    };
    for (final symbol in _boxSymbols) {
      symbolMap[symbol] = symbolMap[symbol]! + 1;
    }
    return symbolMap.entries
        .where((x) => x.value != 0)
        .map((e) => ContainHintItem(count: e.value, mathSymbol: e.key))
        .toList();
  }

  // 數字提示內容物
  List<ContainHintItem> get containHintNumberItems {
    final numberMap = <int, int>{};
    for (final number in _boxNumbers) {
      if (numberMap[number] == null) {
        numberMap[number] = 1;
      } else {
        numberMap[number] = numberMap[number]! + 1;
      }
    }
    final items = numberMap.entries
        .map((e) => ContainHintItem(count: e.value, number: e.key))
        .toList();

    items.sort((a, b) => a.number!.compareTo(b.number!));
    return items;
  }

  String getCurrentAnswer(String currentScore) {
    String result = currentScore;
    if (_selectedFormulaItems.isEmpty) {
      return '?';
    }
    for (final element in _selectedFormulaItems) {
      if (element.mathSymbol != null) {
        switch (element.mathSymbol) {
          case MathSymbol.plus:
            result += '+';
            break;
          case MathSymbol.minus:
            result += '-';
            break;
          case MathSymbol.times:
            result += '*';
            break;
          case MathSymbol.divide:
            result += '/';
            break;
          default:
            break;
        }
      } else {
        if (element.number! < 0) {
          final val = element.number.toString();
          result += '($val)';
        } else {
          result += element.number.toString();
        }
      }
    }
    try {
      final answer = result.interpret();
      return answer.toInt().toString();
    } catch (e) {
      return '?';
    }
  }

  void handleNextStep() {
    if (_step == 1 && _selectedSymbols.length != 3) {
      return;
    }
    if (_step == 2 && _selectedSymbols.length != 3) {
      return;
    }
    _showSelectResult = true;
    Future.delayed(Duration(milliseconds: 2000), () {
      _showSelectResult = false;
      _step = _step + 1;
      notifyListeners();
    });
    notifyListeners();
  }

  void handleSelectMathSymbol(int index, MathSymbol mathSymbol) {
    if (showSelectResult) {
      return;
    }
    final isSelected = checkIsAlreadySelected(_selectedSymbols, index);
    if (!isSelected && _selectedSymbols.length < 3) {
      _selectedSymbols.add(SelectedItem(index: index, mathSymbol: mathSymbol));
    } else {
      _selectedSymbols.removeWhere((element) => element.index == index);
    }
    notifyListeners();
  }

  void handleSelectNumber(int index, int number) {
    if (showSelectResult) {
      return;
    }
    final isSelected = checkIsAlreadySelected(_selectedNumbers, index);
    if (!isSelected && _selectedNumbers.length < 3) {
      _selectedNumbers.add(SelectedItem(index: index, number: number));
    } else {
      _selectedNumbers.removeWhere((element) => element.index == index);
    }
    notifyListeners();
  }

  void handleSelectAnswer(SelectedItem item) {
    final isSelected =
        checkIsAlreadySelected(_selectedFormulaItems, item.index);
    if (!isSelected) {
      _selectedFormulaItems.add(item);
    } else {
      _selectedFormulaItems
          .removeWhere((element) => element.index == item.index);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedFormulaItems.clear();
    notifyListeners();
  }

  bool checkFormula() {
    // 沒有選不合法
    if (_selectedFormulaItems.isEmpty) {
      return false;
    }
    // 第 1, 3, 5 個必須要是符號
    if (_selectedFormulaItems[0].mathSymbol == null ||
        _selectedFormulaItems[2].mathSymbol == null ||
        _selectedFormulaItems[4].mathSymbol == null) {
      return false;
    }
    // 第 2, 4, 6 個必須要是符號
    if (_selectedFormulaItems[1].number == null ||
        _selectedFormulaItems[3].number == null ||
        _selectedFormulaItems[5].number == null) {
      return false;
    }
    return true;
  }

  void setGameOver() {
    _gameOver = true;
  }
}
