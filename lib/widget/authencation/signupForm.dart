import 'package:ecommerce/MainPage.dart';
import 'package:ecommerce/data/DB_helper.dart';
import 'package:flutter/material.dart';

import 'buttonSign.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _userNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  bool _isObscure = true;
  bool _isConfirmPassObscure = true;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _register() async {
    if (_passwordCtrl.text != _confirmPasswordCtrl.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Mật khẩu không khớp!")));
      return;
    }

    await _dbHelper.createUser(
      _userNameCtrl.text,
      _emailCtrl.text,
      _passwordCtrl.text,
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Đăng ký thành công!")));

    // Điều hướng đến MainPage sau khi đăng ký thành công
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  @override
  void dispose() {
    _userNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Ngăn không cho đẩy lên
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
              top: 200.0, bottom: 20, right: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Xin chào, ',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Vui lòng nhập đầy đủ thông tin! ',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 23),
              TextFormField(
                controller: _userNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tên đăng nhập',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordCtrl,
                obscureText: _isConfirmPassObscure,
                decoration: InputDecoration(
                  labelText: 'Nhập lại mật khẩu',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isConfirmPassObscure = !_isConfirmPassObscure;
                      });
                    },
                    icon: Icon(_isConfirmPassObscure
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ButtonSign(text: 'Đăng ký', onPressed: _register),
            ],
          ),
        ),
      ),
    );
  }
}
