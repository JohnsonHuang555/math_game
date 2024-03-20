import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

/// 道具列表元件
class ItemList extends StatelessWidget {
  const ItemList({super.key});

  List<Widget> getItemList() {
    return List.generate(
      3,
      (index) => badges.Badge(
        onTap: () {},
        badgeContent: Text(
          '1',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        position: badges.BadgePosition.topEnd(top: -15),
        badgeStyle: badges.BadgeStyle(padding: EdgeInsets.all(8)),
        child: Container(
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
