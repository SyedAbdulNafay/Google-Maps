import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  final String text;
  const OverviewTab({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(
            Icons.location_on_outlined,
            color: Colors.blue,
          ),
          title: Text(text),
        )
      ],
    );
  }
}
