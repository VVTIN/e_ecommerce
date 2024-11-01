import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/logos/google.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 24.0),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/logos/facebook.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
