import 'package:basic/helpers/math_symbol.dart';

// 內容物
class ContainHintItem {
  int count;
  MathSymbol? mathSymbol;
  int? number;
  ContainHintItem({
    required this.count,
    this.mathSymbol,
    this.number,
  });
}
