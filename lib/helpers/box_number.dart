import 'dart:math';

int getNumber(List<int> numbers) {
  final random = Random();
  final index = random.nextInt(numbers.length);
  return numbers[index];
}

List<int> createBoxNumbers() {
  final details = {
    1: 10,
    2: 8,
    3: 7,
    4: 6,
    5: 5,
    6: 4,
    7: 4,
    8: 3,
    9: 2,
    0: 2,
    -9: 2,
    -8: 3,
    -7: 4,
    -6: 4,
    -5: 5,
    -4: 6,
    -3: 7,
    -2: 8,
    -1: 10,
  };

  List<int> totalNumbers = [];
  details.forEach((key, value) {
    for (var i = 0; i < value; i++) {
      totalNumbers.add(key);
    }
  });

  List<int> result = [];
  for (int i = 0; i < 9; i++) {
    result.add(getNumber(totalNumbers));
  }

  return result;
}
