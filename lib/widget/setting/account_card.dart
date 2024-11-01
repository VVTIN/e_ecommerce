import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key, required this.text, required this.onClick});
  final String text;
  final Function() onClick;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          return onClick();
        },
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(width: 1, color: Colors.grey),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 0.1,
                blurRadius: 7,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const Icon(Icons.keyboard_arrow_left_outlined)
            ],
          ),
        ),
      ),
    );
  }
}
