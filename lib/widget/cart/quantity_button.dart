import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuantityButton extends StatelessWidget {
  const QuantityButton(
      {super.key,
      required this.onPressedMinus,
      required this.onPressedAdd,
      required this.qty});
  final VoidCallback onPressedMinus;
  final VoidCallback onPressedAdd;
  final Function() qty;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.minus),
            onPressed: onPressedMinus,
          ),
          Obx(() => qty()),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onPressedAdd,
          ),
        ],
      ),
    );
  }
}
