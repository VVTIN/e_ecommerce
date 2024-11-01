// custom_app_bar.dart
import 'package:ecommerce/controller/controller.dart';
import 'package:ecommerce/pages/cartPage.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function openDrawer;
  final Function(String) onSearchSubmitted;

  const HomeAppBar({
    Key? key,
    required this.openDrawer,
    required this.onSearchSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.sort_rounded,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Obx(
          () => TextField(
            controller: productController.searchTextEditController,
            autofocus: false,
            onSubmitted: (value) => onSearchSubmitted(value),
            onChanged: (value) {
              productController.searchValue.value = value;
            },
            decoration: InputDecoration(
                hintText: 'Tìm kiếm...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                suffixIcon: productController.searchValue.value.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          productController.searchValue.value = '';
                          productController.searchTextEditController.clear();
                          productController.getProduct();
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Color(0xff00008B),
                        ),
                      )
                    : null),
          ),
        ),
      ),
      actions: [
        Obx(
          () => badges.Badge(
            badgeAnimation: const badges.BadgeAnimation.rotation(),
            badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
            badgeContent: Text(
              '${cartController.totalQuantity}', 
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: InkWell(
              onTap: () {
                
                  Get.to(() => CartPage());
                
              },
              child: const Tooltip(
                // Tooltip for accessibility
                message: 'View Cart',
                child: Icon(
                  Icons.shopping_cart_checkout,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
