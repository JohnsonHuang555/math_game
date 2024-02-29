import 'package:flutter/material.dart';

class ContentHint extends StatelessWidget {
  const ContentHint({super.key});

  List<Widget> getHints() {
    // TODO: from provider
    return List.generate(
      4,
      (index) => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          // Icon,
          Icon(
            Icons.remove,
            size: 16,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '內容物',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.only(left: 130, right: 130),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: getHints(),
          ),
        ),
      ],
    );
  }
}
