import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecommerce/controller/dashboard_controller.dart';
import 'package:ecommerce/controller/product_controller.dart';
import 'package:ecommerce/pages/categoryPage.dart';
import 'package:ecommerce/pages/historyPage.dart';
import 'package:ecommerce/pages/homePage.dart';
import 'package:ecommerce/pages/accountPage.dart';
import 'package:ecommerce/pages/productPage.dart';
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
    return GetBuilder<DashboardController>(
      builder: (controller) => Scaffold(
        backgroundColor: Colors.grey.shade100,
        drawer: DrawerWidget(),
        //appbar
        appBar: controller.tabIndex == 0 || controller.tabIndex == 1
            ? HomeAppBar(
                openDrawer: openDrawer,
                onSearchSubmitted: (value) {
                  ProductController.instance.getProductByName(keyword: value);
                  setState(() {
                    controller.tabIndex = 1;
                  });
                },
              )
            : null,
        body: IndexedStack(
          index: controller.tabIndex,
          children: const [
            HomePage(),
            ProductPage(),
            HistoryPage(),
            AccountPage(),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          items: const [
            Icon(
              Icons.home,
              size: 33,
              color: Colors.white,
            ),
            Icon(
              Icons.category,
              size: 33,
              color: Colors.white,
            ),
            Icon(
              Icons.history,
              size: 33,
              color: Colors.white,
            ),
            Icon(
              Icons.person,
              size: 33,
              color: Colors.white,
            ),
          ],
          onTap: (index) {
            setState(() {
              controller.tabIndex = index;
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
