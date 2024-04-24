import 'package:flutter/material.dart';

/// 道具列表元件
class ItemList extends StatelessWidget {
  // final int step;
  // final Map<String, Item> items;
  // const ItemList({
  //   super.key,
  //   required this.step,
  //   required this.items,
  // });

  // List<Widget> getItemList(BuildContext context) {
  //   final palette = context.read<Palette>();
  //   final playerProgress = context.read<PlayerProgress>();
  //   final gameState = context.read<GameState>();

  //   final List<Item> stepOneAndTwoItems = items.entries
  //       .where((element) =>
  //           ['magnifier', 'elimination', 'reset_game'].contains(element.key))
  //       .map((e) => Item(
  //             id: e.value.id,
  //             title: e.value.title,
  //             description: e.value.description,
  //             imageUrl: e.value.imageUrl,
  //             count: e.value.count,
  //           ))
  //       .toList();
  //   final List<Item> stepThreeItems = items.entries
  //       .where((element) => [
  //             'symbol_controller',
  //             'number_controller',
  //             'reset_game'
  //           ].contains(element.key))
  //       .map((e) => Item(
  //             id: e.value.id,
  //             title: e.value.title,
  //             description: e.value.description,
  //             imageUrl: e.value.imageUrl,
  //             count: e.value.count,
  //           ))
  //       .toList();
  //   final List<Item> currentItems =
  //       step == 3 ? stepThreeItems.reversed.toList() : stepOneAndTwoItems;
  //   return List.generate(
  //     3,
  //     (index) => badges.Badge(
  //       onTap: () {
  //         if (currentItems[index].count < 1) {
  //           Dialogs.materialDialog(
  //             msg: 'watch_ads_to_award'.tr(),
  //             msgStyle: TextStyle(
  //               fontSize: 18,
  //             ),
  //             title: 'modal_hint'.tr(),
  //             titleStyle: TextStyle(
  //               fontSize: 22,
  //             ),
  //             msgAlign: TextAlign.end,
  //             context: context,
  //             actions: [
  //               BasicButton(
  //                 padding: 6.0,
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text(
  //                   'cancel',
  //                   style: TextStyle(
  //                     color: palette.ink,
  //                     fontSize: 16,
  //                   ),
  //                 ).tr(),
  //               ),
  //               BasicButton(
  //                 bgColor: Colors.blueGrey,
  //                 padding: 6.0,
  //                 onPressed: () {
  //                   // TODO: 播放廣告
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text(
  //                   'OK',
  //                   style: TextStyle(
  //                     color: palette.ink,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           );
  //           return;
  //         }
  //         // 使用道具彈窗
  //         Dialogs.materialDialog(
  //           msg: currentItems[index].description,
  //           msgStyle: TextStyle(
  //             fontSize: 18,
  //           ),
  //           title: currentItems[index].title,
  //           titleStyle: TextStyle(
  //             fontSize: 22,
  //           ),
  //           msgAlign: TextAlign.end,
  //           context: context,
  //           actions: [
  //             BasicButton(
  //               padding: 6.0,
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text(
  //                 'cancel',
  //                 style: TextStyle(
  //                   color: palette.ink,
  //                   fontSize: 16,
  //                 ),
  //               ).tr(),
  //             ),
  //             BasicButton(
  //               bgColor: Colors.blueGrey,
  //               padding: 6.0,
  //               onPressed: () {
  //                 gameState.useItem(currentItems[index].id);
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text(
  //                 'OK',
  //                 style: TextStyle(
  //                   color: palette.ink,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //       badgeContent: Text(
  //         currentItems[index].count < 1
  //             ? '+'
  //             : currentItems[index].count.toString(),
  //         style: TextStyle(
  //           color: palette.trueWhite,
  //         ),
  //       ),
  //       position: badges.BadgePosition.topEnd(top: -15),
  //       badgeStyle: badges.BadgeStyle(padding: EdgeInsets.all(10)),
  //       child: Container(
  //         width: 50,
  //         height: 50,
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             width: 2,
  //           ),
  //           borderRadius: BorderRadius.circular(6),
  //         ),
  //         child: Center(
  //           child: SvgPicture.asset(
  //             currentItems[index].imageUrl,
  //             width: 36,
  //             height: 36,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [],
    );
  }
}
