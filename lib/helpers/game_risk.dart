import 'dart:math';

// ignore: constant_identifier_names
const MAX_RISK = 10;

int createGameRisk() {
  var random = Random();
  return random.nextInt(MAX_RISK) + 1;
}
