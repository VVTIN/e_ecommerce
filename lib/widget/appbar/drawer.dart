import 'package:ecommerce/MainPage.dart';
import 'package:ecommerce/pages/categoryPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../data/DB_helper.dart';
import '../../model/currentUser.dart';
import '../notification/notification_api.dart';
import '../setting/avatar.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  //Notification
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSetting();
  }

  // Tải cài đặt thông báo từ SharedPreferences
  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  // Lưu cài đặt thông báo vào SharedPreferences
  Future<void> _saveNotificationSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
  }

  // Hàm kiểm tra và hiển thị thông báo
  void showNotification(String message) {
    if (_notificationsEnabled) {
      // Hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      print("Thông báo bị tắt.");
    }
  }

//usernam
  Future<Map<String, dynamic>?> _getProfile() async {
    final userId = CurrentUser().id;
    if (userId == null) return null;
    return await DatabaseHelper()
        .getUserById(userId)
        .then((result) => result.isNotEmpty ? result.first : null);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://images.joseartgallery.com/100736/what-kind-of-art-is-popular-right-now.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned(top: 5, left: 100, child: AvatarUser()),
                    Positioned(
                      bottom: 15,
                      left: 100,
                      child: FutureBuilder<Map<String, dynamic>?>(
                        future: _getProfile(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          final username =
                              snapshot.data?['username'] ?? 'Tên người dùng';
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
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Get.to(() => const MainPage());
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Danh mục'),
                onTap: () {
                  Get.to(() => const CategoryPage());
                },
              ),
              SwitchListTile(
                title: Row(
                  children: [
                    Icon(Icons.notifications),
                    SizedBox(width: 13),
                    Text(
                      'Bật/tắt thông báo',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                    _saveNotificationSetting(value);
                  });

                  if (_notificationsEnabled) {
                    showNotification("Chào mừng bạn đã bật thông báo!");
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
