import 'package:basic/helpers/game_risk.dart';
import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
  int? _risk;


  int? get risk => _risk;

  GameState() {
    _risk = createGameRisk();

  }
}