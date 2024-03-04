import 'dart:math';

List<int> createBoxNumbers(int? risk) {
  if (risk != null) {
    switch (risk) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
        var numbers = _createBoxes(5);
        return numbers;
      default:
        return [];
    }
  }
  return [];
}

/// 產生九個隨機數字
List<int> _createBoxes(int range) {
  List<int> numbers = [];

  for (var i = 0; i < 9; i++) {
    var random = Random();
    numbers.add(random.nextInt(range) + 1);
  }
  return numbers;
}
