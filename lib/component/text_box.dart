import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final VoidCallback onPressed;
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: onPressed,
              ),
            ],
          ),
          Text(text),
        ],
      ),
    );
  }
}
