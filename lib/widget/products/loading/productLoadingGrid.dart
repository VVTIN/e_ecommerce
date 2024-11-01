import 'package:ecommerce/widget/products/loading/productLoadingCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProductLoadingGrid extends StatelessWidget {
  const ProductLoadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(10),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => const ProductLoadingCard(),
    );
  }
}
