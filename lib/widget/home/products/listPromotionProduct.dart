import 'package:ecommerce/controller/controller.dart';
import 'package:ecommerce/controller/home_controller.dart';
import 'package:ecommerce/pages/productDetailPage.dart';
import 'package:ecommerce/widget/home/products/popularProduct_loading.dart';
import 'package:ecommerce/widget/home/products/promotionProduct_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/const.dart';

class ListPromotionProduct extends StatefulWidget {
  const ListPromotionProduct({super.key});

  @override
  State<ListPromotionProduct> createState() => _ListPromotionProductState();
}

class _ListPromotionProductState extends State<ListPromotionProduct> {
  final HomeController homeController = HomeController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeController.isPromotionProductLoading.value) {
        return const PromotionProductLoading();
      }

      return Container(
        height: 960,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 5 / 6,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: homeController.promotionProductList.length,
          itemBuilder: (context, index) {
            final product = homeController.promotionProductList[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(
                      product: productController.listProduct[index],
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: 240,
                    padding: const EdgeInsets.all(8),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          baseUrl + product.images.first,
                          width: 90,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          maxLines: 1,
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
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 3.0,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        '-${product.discount} %',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
