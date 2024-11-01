import 'package:ecommerce/controller/product_controller.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/widget/products/view/productCard.dart';
import 'package:ecommerce/widget/products/loading/productLoadingGrid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products});
  final List<ProductModel> products;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => Productcard(product: products[index]),
    );
  }
}
