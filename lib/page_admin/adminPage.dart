import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommerce/MainPage.dart';
import 'package:ecommerce/page_admin/history/history_list.dart';
import 'package:ecommerce/page_admin/product/product_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../data/DB_helper.dart';
import '../model/currentUser.dart';
import '../pages/auth/authencation.dart';
import '../service/remote_service/auth_service.dart';
import '../widget/setting/avatar.dart';
import 'category/category_list.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int selectedIndex = 0;

  Future<Map<String, dynamic>?> _getProfile() async {
    final userId = CurrentUser().id;
    if (userId == null) return null;
    return await DatabaseHelper()
        .getUserById(userId)
        .then((result) => result.isNotEmpty ? result.first : null);
  }

  Future<void> logout() async {
    AuthService().logoutUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthencationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
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
              title: const Text('Trang người dùng'),
              onTap: () {
                Get.to(() => const MainPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng xuất'),
              onTap: () async {
                await logout(); 
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: const [ProductList(), CategoryList(), HistoryList()],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.production_quantity_limits, size: 33, color: Colors.white),
          Icon(Icons.category, size: 33, color: Colors.white),
          Icon(Icons.history, size: 33, color: Colors.white),
        ],
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        backgroundColor: Colors.transparent,
        color: Theme.of(context).primaryColor,
        height: 53,
      ),
    );
  }
}
