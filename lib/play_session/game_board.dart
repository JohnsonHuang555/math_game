import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  List<Widget> getGameCard() {
    return List.generate(
      9,
      (index) => Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            index.toString(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3, //決定每列數量
      childAspectRatio: 1,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: getGameCard(),
    );
  }
}
