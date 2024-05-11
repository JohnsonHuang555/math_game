import 'package:basic/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardPlayer extends StatelessWidget {
  final int? rank;
  final String name;
  final String score;
  final bool highlight;
  const LeaderboardPlayer({
    super.key,
    required this.name,
    required this.score,
    required this.highlight,
    this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();

    return Row(
      children: [
        rank != null
            ? Center(
                child: Text(
                  rank.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: highlight ? palette.selectedItem : palette.ink,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        SizedBox(
          width: rank != null ? 30 : 0,
        ),
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: highlight ? palette.selectedItem : null,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            score,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: highlight ? palette.selectedItem : null,
            ),
          ),
        ),
      ],
    );
  }
}
