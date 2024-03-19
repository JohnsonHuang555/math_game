import 'dart:math';

int getNumber(List<int> numbers) {
  var random = Random();
  var index = random.nextInt(numbers.length);
  return numbers[index];
}

List<int> createBoxNumbers() {
  var details = {
    1: 17,
    2: 16,
    3: 14,
    4: 13,
    5: 12,
    6: 10,
    7: 8,
    8: 5,
    9: 3,
    0: 2,
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
