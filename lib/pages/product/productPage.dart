import 'package:ecommerce/controller/product_controller.dart';
import 'package:ecommerce/widget/products/view/productGrid.dart';
import 'package:ecommerce/widget/products/loading/productLoadingGrid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = ProductController.instance;
    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.isProductLoading.value) {
              return const ProductLoadingGrid();
            } else {
              if (controller.listProduct.isNotEmpty) {
                return ProductGrid(products: controller.listProduct);
              } else {
                return Center(
                  child: Image.asset('assets/images/404 Error.png'),
                );
              }
            }
          }),
        ),
      ],
    ));
  }
}
