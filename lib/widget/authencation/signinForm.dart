import 'package:ecommerce/MainPage.dart';
import 'package:ecommerce/data/DB_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/currentUser.dart';
import '../../pages/auth/resetPasswordPage.dart';
import '../setting/profile_user.dart';
import 'buttonSign.dart';
import 'divider.dart';
import 'SocialButton.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  bool _obscured = true;
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _login() async {
    var user = await _dbHelper.getUser(_emailCtrl.text);
    if (user.isNotEmpty && user[0]['password'] == _passwordCtrl.text) {
      CurrentUser()
          .setUser(user[0]['id'], user[0]['username'], user[0]['email']);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email hoặc mật khẩu không đúng!")));
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        // Thay đổi từ ListView sang SingleChildScrollView
        padding:
            const EdgeInsets.only(top: 190.0, bottom: 20, right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào, ',
              style: TextStyle(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Tiếp tục đăng nhập! ',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 23),

            // Email
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            TextFormField(
              controller: _passwordCtrl,
              obscureText: _obscured,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                prefixIcon: const Icon(Icons.password),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscured = !_obscured;
                    });
                  },
                  icon: Icon(
                    _obscured ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),

            // Quên mật khẩu
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.to(() => ForgotPasswordPage());
                },
                child: const Text(
                  'Quên mật khẩu?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            // Button đăng nhập
            ButtonSign(text: 'Đăng nhập', onPressed: _login),
            const SizedBox(height: 16.0),

            // Divider
            const DividerOR(),
            const SizedBox(height: 16.0),

            // Button xã hội
            const SocialButton(),
          ],
        ),
      ),
    );
  }
}
