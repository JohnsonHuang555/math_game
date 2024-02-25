import 'package:flutter/material.dart';

/// 道具列表元件
class ItemList extends StatelessWidget {
  const ItemList({super.key});

  List<Widget> getItemList() {
    return List.generate(
      4,
      (index) => Container(
        width: 50,
        height: 50,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: getItemList(),
    );
  }
}
