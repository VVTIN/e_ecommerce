import 'package:ecommerce/config/const.dart';
import 'package:ecommerce/controller/controller.dart';
import 'package:ecommerce/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/category.dart';
import 'popularCategory_loading.dart';

class ListCategories extends StatefulWidget {
  const ListCategories({super.key});

  @override
  State<ListCategories> createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  final HomeController homeController = HomeController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading indicator when data is being fetched
      if (homeController.isPopularCategoryLoading.value) {
        return PopularCategoryLoading();
      }

      return SizedBox(
        height: 170,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            childAspectRatio: 0.65,
            crossAxisSpacing: 10,
            mainAxisSpacing: 5,
          ),
          scrollDirection: Axis.horizontal, // Scroll horizontally
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling
          itemCount:
              homeController.popularCategoryList.length, // Number of categories
          itemBuilder: (context, index) {
            final category = homeController.popularCategoryList[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  dashboardController.updateIndex(1);
                  productController.searchTextEditController.text =
                      category.name;
                  productController.searchValue.value = 'cat:${category.name}';
                  productController.getProductByCategory(
                      id: categoryController.categoryList[index].id);
                },
                child: GridTile(
                  footer: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(baseUrl + category.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
