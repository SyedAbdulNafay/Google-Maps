import 'package:flutter/material.dart';

class ButtonsRow extends StatefulWidget {
  const ButtonsRow({super.key});

  @override
  State<ButtonsRow> createState() => _ButtonsRowState();
}

class _ButtonsRowState extends State<ButtonsRow> {
  List<Map<Icon, String>> buttons = [
    {
      const Icon(
        Icons.directions,
        color: Colors.white,
      ): "Directions"
    },
    {
      const Icon(
        Icons.bookmark_border,
        color: Colors.blue,
      ): "Save"
    },
    {
      const Icon(
        Icons.share,
        color: Colors.blue,
      ): "Share"
    },
    {
      const Icon(
        Icons.more_horiz,
        color: Colors.blue,
      ): "More"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          return Container(
              margin: EdgeInsets.only(
                left: 15,
                right: index == buttons.length - 1 ? 15 : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: index == 0 ? Colors.transparent : Colors.grey.shade300,
                ),
                color: index == 0 ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  buttons[index].keys.first,
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    buttons[index].values.first,
                    style: TextStyle(
                      color: index == 0 ? Colors.white : Colors.blue,
                    ),
                  )
                ],
              ));
        },
      ),
    );
  }
}
