import 'package:ecommerce/controller/controller.dart';
import 'package:ecommerce/widget/category/category_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh mục'),
      ),
      body: Obx(() {
        if (categoryController.categoryList.isNotEmpty) {
          return ListView.builder(
            itemCount: categoryController.categoryList.length,
            itemBuilder: (context, index) =>
                CategoryCard(category: categoryController.categoryList[index]),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
