import 'package:ecommerce/config/const.dart';
import 'package:ecommerce/controller/controller.dart';
import 'package:ecommerce/controller/home_controller.dart';
import 'package:ecommerce/pages/product/productDetailPage.dart';
import 'package:ecommerce/widget/home/products/popularProduct_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/category.dart';

class ListPopularProduct extends StatefulWidget {
  const ListPopularProduct({super.key});

  @override
  State<ListPopularProduct> createState() => _ListPopularProductState();
}

class _ListPopularProductState extends State<ListPopularProduct> {
  final HomeController homeController = HomeController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeController.isPopularProductLoading.value) {
        return PopularProductLoading();
      }

      return SizedBox(
        height: 155,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homeController.popularProductList.length,
          itemBuilder: (context, index) {
            final product = homeController.popularProductList[index];
            return GestureDetector(
              onTap: () {
                Get.to(
                  () => ProductDetailPage(
                    product: productController.listProduct[product.id!],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                width: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      baseUrl + product.images.first,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
