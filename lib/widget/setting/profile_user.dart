import 'package:ecommerce/MainPage.dart';
import 'package:ecommerce/data/DB_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/currentUser.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); 
  }

  Future<void> _loadUserProfile() async {
    final userProfile =
        await dbHelper.getUserById(CurrentUser().id!); 
    if (userProfile.isNotEmpty) {
      usernameController.text = userProfile.first['username'];
      emailController.text = userProfile.first['emailAddress'];
      phoneController.text = userProfile.first['phone'];
    }
  }

  Future<void> _saveProfileChanges() async {
    final updatedUserData = {
      'username': usernameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
    };

    try {
      await dbHelper.updateUser(CurrentUser().id!, updatedUserData);
      Get.snackbar('Thành công', 'Cập nhật thông tin thành công');
      Get.to(() => const MainPage());
    } catch (e) {
      Get.snackbar('Lỗi', 'Lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông Tin Cá Nhân')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
             const Image(
                image: AssetImage('assets/images/Profile Interface-bro.png'),
                fit: BoxFit.contain,
                height: 250),
            const SizedBox(height: 20),
            TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                    labelText: 'Tên người dùng',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))))),
            const SizedBox(height: 20),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))))),
            const SizedBox(height: 20),
            TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))))),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _saveProfileChanges, 
                child: const Text('Lưu Thay Đổi')),
          ],
        ),
      ),
    );
  }
}
