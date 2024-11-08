import 'package:ecommerce/data/DB_helper.dart';
import 'package:ecommerce/pages/auth/authencation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String _password = '';
  String _message = '';

  void _checkEmail() async {
    var user = await _dbHelper.getUser(_emailCtrl.text);

    if (user.isNotEmpty) {
      setState(() {
        _password = user[0]['password']; // Lấy mật khẩu
      });
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Thông báo'),
          content: Text('Mật khẩu của bạn là: $_password'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthencationPage(),
                    ));
              },
              child: Text(
                'Đóng',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      );
    } else {
      setState(() {
        _message = 'Email không tồn tại!';
      });
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quên mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Image(
                image: AssetImage('assets/images/Forgot password-bro.png'),
                fit: BoxFit.cover,
                ),
            SizedBox(height: 20),
            Text(
              'Nhập email của bạn',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailCtrl,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkEmail,
                child: Text('Xác thực'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _message,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );  
  }
}
