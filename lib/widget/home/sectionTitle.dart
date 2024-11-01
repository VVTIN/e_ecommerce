import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.text});
  final String title;
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 19.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: const TextStyle(color: Colors.black38),
            ),
          )
        ],
      ),
    );
  }
}
