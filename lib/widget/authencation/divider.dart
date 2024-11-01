import 'package:flutter/material.dart';

class DividerOR extends StatelessWidget {
  const DividerOR({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Flexible(
          child: Divider(
            thickness: 0.6,
            indent: 50,
            endIndent: 10,
          ),
        ),
        Text(
          'Hoặc',
        ),
        Flexible(
          child: Divider(
            thickness: 0.6,
            indent: 10,
            endIndent: 50,
          ),
        )
      ],
    );
  }
}
