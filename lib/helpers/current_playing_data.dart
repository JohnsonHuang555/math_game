import 'dart:convert';

import '../../helpers/math_symbol.dart';

class CurrentPlayingData {
  final int step;
  final List<MathSymbol> boxSymbols;
  final List<int> boxNumbers;
  final List<SelectedItem> selectedSymbols;
  final List<SelectedItem> selectedNumbers;
  CurrentPlayingData({
    required this.step,
    required this.boxSymbols,
    required this.boxNumbers,
    required this.selectedSymbols,
    required this.selectedNumbers,
  });

  CurrentPlayingData.fromJson(
    Map<String, dynamic> json,
  )    // This Function helps to convert our Map into our User Object
  : step = json['step'] as int,
        boxSymbols = (json['boxSymbols'] as List<dynamic>)
            .map((e) => getMathSymbol(jsonDecode(e as String) as String))
            .toList(),
        boxNumbers = (json['boxNumbers'] as List<dynamic>)
            .map((e) => jsonDecode(e as String) as int)
            .toList(),
        selectedSymbols = (json['selectedSymbols'] as List<dynamic>)
            .map((e) => SelectedItem.fromJson(
                jsonDecode(e as String) as Map<String, dynamic>))
            .toList(),
        selectedNumbers = (json['selectedNumbers'] as List<dynamic>)
            .map((e) => SelectedItem.fromJson(
                jsonDecode(e as String) as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() {
    // This Function helps to convert our User Object into a Map.
    return {
      'step': step,
      'boxSymbols': boxSymbols.map((e) => jsonEncode(e.toString())).toList(),
      'boxNumbers': boxNumbers.map((e) => jsonEncode(e)).toList(),
      'selectedSymbols': selectedSymbols.map((e) => jsonEncode(e)).toList(),
      'selectedNumbers': selectedNumbers.map((e) => jsonEncode(e)).toList(),
    };
  }
}
