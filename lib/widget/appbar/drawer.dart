import 'package:ecommerce/MainPage.dart';
import 'package:ecommerce/pages/categoryPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://images.joseartgallery.com/100736/what-kind-of-art-is-popular-right-now.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 5,
                      bottom: 10,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            'https://st.quantrimang.com/photos/image/072015/22/avatar.jpg'),
                      ),
                    ),
                    Positioned(
                      right: 45,
                      bottom: 10,
                      child: Text(
                        'Tên của bạn',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
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
              // Add more items here
            ],
          ),
        ],
      ),
    );
  }
}
