import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameBoard extends StatelessWidget {
  final List<Widget> items;
  final Function(int index) onSelect;
  const GameBoard({super.key, required this.items, required this.onSelect});

  List<Widget> getGameCard() {
    return List.generate(
      9,
      (index) => GestureDetector(
        onTap: () {
          onSelect(index);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: items[index],
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
