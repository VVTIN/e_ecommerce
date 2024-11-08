import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommerce/controller/dashboard_controller.dart';
import 'package:ecommerce/controller/product_controller.dart';
import 'package:ecommerce/model/currentUser.dart';
import 'package:ecommerce/pages/categoryPage.dart';
import 'package:ecommerce/pages/order/orderHistoryPage.dart';
import 'package:ecommerce/pages/homePage.dart';
import 'package:ecommerce/pages/accountPage.dart';
import 'package:ecommerce/pages/product/productPage.dart';
import 'package:ecommerce/widget/appbar/drawer.dart';
import 'package:ecommerce/widget/appbar/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the DashboardController instance
    final DashboardController controller = Get.find<DashboardController>();

    return GetBuilder<DashboardController>(
      init: controller, // Ensure it's initialized
      builder: (_) => Scaffold(
        backgroundColor: Colors.grey.shade100,
        drawer: DrawerWidget(),
        appBar: controller.tabIndex == 0 || controller.tabIndex == 1
            ? HomeAppBar(
                openDrawer: openDrawer,
                onSearchSubmitted: (value) {
                  ProductController.instance.getProductByName(keyword: value);
                  setState(() {
                    controller.updateIndex(1);
                  });
                },
              )
            : null,
        body: IndexedStack(
          index: controller.tabIndex,
          children: [
            HomePage(),
            ProductPage(),
            OrderHistoryPage(userId: CurrentUser().id ?? 0), // Add default user ID
            AccountPage(),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          items: const [
            Icon(Icons.home, size: 33, color: Colors.white),
            Icon(Icons.category, size: 33, color: Colors.white),
            Icon(Icons.history, size: 33, color: Colors.white),
            Icon(Icons.person, size: 33, color: Colors.white),
          ],
          onTap: (index) {
            setState(() {
              controller.updateIndex(index);
            });
          },
          backgroundColor: Colors.transparent,
          color: Theme.of(context).primaryColor,
          height: 53,
        ),
      ),
    );
  }
}

