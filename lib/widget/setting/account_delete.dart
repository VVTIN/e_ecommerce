import 'package:ecommerce/pages/auth/authencation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/DB_helper.dart';

class AccountDelete extends StatefulWidget {
  const AccountDelete({super.key});

  @override
  State<AccountDelete> createState() => _AccountDeleteState();
}

class _AccountDeleteState extends State<AccountDelete> {
  final _passwordController = TextEditingController();

  Future<void> _deleteAccount() async {
    try {
      await DatabaseHelper().deleteUserAccountWithPassword(
        _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xóa tài khoản thành công!")),
      );

      _passwordController.clear();
      Get.to(() => AuthencationPage());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Xoá tài khoản người dùng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image(
                image: AssetImage('assets/images/Inbox cleanup-bro.png'),
                fit: BoxFit.contain,
                height: 250),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Nhập mật khẩu",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _deleteAccount,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "Xác nhận",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
