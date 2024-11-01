import 'package:ecommerce/data/DB_helper.dart';
import 'package:ecommerce/pages/auth/authencation.dart';
import 'package:ecommerce/service/remote_service/auth_service.dart';
import 'package:ecommerce/widget/setting/account_card.dart';
import 'package:ecommerce/widget/setting/account_delete.dart';
import 'package:ecommerce/widget/setting/address/addressWidget.dart';
import 'package:ecommerce/widget/setting/change_password.dart';
import 'package:ecommerce/widget/setting/notification_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/currentUser.dart';
import '../widget/setting/avatar.dart';
import '../widget/setting/profile_user.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<void> logout() async {
    AuthService().logoutUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthencationPage()),
    );
  }

  Future<Map<String, dynamic>?> _getProfile() async {
    final userId = CurrentUser().id;
    if (userId == null) return null;
    return await DatabaseHelper()
        .getUserById(userId)
        .then((result) => result.isNotEmpty ? result.first : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://images.joseartgallery.com/100736/what-kind-of-art-is-popular-right-now.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),
          const Positioned(top: 130, left: 10, child: AvatarUser()),
          Positioned(
            top: 160,
            left: 100,
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _getProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final username = snapshot.data?['username'] ?? 'Tên người dùng';
                return Text(
                  username,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 190),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      AccountCard(
                        text: 'Địa điểm',
                        onClick: () => Get.to(() => const AddressWidget()),
                      ),
                      const SizedBox(height: 10),
                      AccountCard(
                        text: 'Thông tin cá nhân',
                        onClick: () => Get.to(() => const ProfileUser()),
                      ),
                      AccountCard(
                        text: 'Thông báo',
                        onClick: () => Get.to(() => const NotificationSetting()),
                      ),
                      AccountCard(
                        text: 'Thay đổi mật khẩu',
                        onClick: () => Get.to(() => const ChangePassword()),
                      ),
                      AccountCard(
                        text: 'Xóa tài khoản',
                        onClick: () => Get.to(() => const AccountDelete()),
                      ),
                      AccountCard(
                        text: CurrentUser().id != null
                            ? 'Đăng xuất'
                            : 'Đăng nhập',
                        onClick: () {
                          if (CurrentUser().id == null) {
                            Get.to(() => const AuthencationPage());
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Yêu cầu xác nhận'),
                                  content: const Text(
                                      'Bạn có chắc chắn muốn đăng xuất không?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Đóng hộp thoại
                                      },
                                      child: const Text('Hủy',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await logout(); // Đăng xuất
                                      },
                                      child: const Text('Đăng xuất',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}