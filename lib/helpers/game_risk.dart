import 'dart:math';

import './math_symbol.dart';

// ignore: constant_identifier_names
const MAX_RISK = 10;

int createGameRisk() {
  var random = Random();
  return random.nextInt(MAX_RISK) + 1;
}

bool checkIsAlreadySelected(List<SelectedItem> selectedItems, int targetIndex) {
  var alreadySelected = selectedItems
      .singleWhere((element) => element.index == targetIndex, orElse: () {
    return SelectedItem(index: -1);
  });
  if (alreadySelected.index == -1) {
    return false;
  }
  return true;
}
