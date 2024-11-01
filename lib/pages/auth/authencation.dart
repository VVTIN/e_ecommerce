import 'package:ecommerce/widget/authencation/navigationButton.dart';
import 'package:ecommerce/widget/authencation/signinForm.dart';
import 'package:ecommerce/widget/authencation/signupForm.dart';
import 'package:flutter/material.dart';

class AuthencationPage extends StatefulWidget {
  const AuthencationPage({super.key});

  @override
  State<AuthencationPage> createState() => _AuthencationPageState();
}

class _AuthencationPageState extends State<AuthencationPage> {
  bool _isSelectedColor = true;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        _isSelectedColor = _pageController.page == 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: const [
              SigninForm(),
              SignupForm(),
            ],
          ),
          NavigationButton(
            isSelectedColor: _isSelectedColor,
            pageController: _pageController,
          )
        ],
      ),
    );
  }
}
