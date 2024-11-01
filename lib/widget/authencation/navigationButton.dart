import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton(
      {super.key, required this.isSelectedColor, required this.pageController});
  final PageController pageController;
  final bool isSelectedColor;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: kToolbarHeight * 2,
      left: MediaQuery.of(context).size.width * 0.18,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              pageController.animateToPage(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelectedColor ? Colors.blue : Colors.blue[50],
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            child: Text(
              'Đăng nhập',
              style: TextStyle(
                color: isSelectedColor ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: !isSelectedColor ? Colors.blue : Colors.blue[50],
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 28.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            child: Text(
              'Đăng ký',
              style: TextStyle(
                color: !isSelectedColor ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
