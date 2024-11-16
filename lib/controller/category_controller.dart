import 'dart:convert';

import 'package:ecommerce/model/category.dart';
import 'package:ecommerce/service/remote_service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController instance = Get.find();
  RxList<Category> categoryList = List<Category>.empty(growable: true).obs;
  RxBool isCategoryLoading = false.obs;

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }

  void getCategories() async {
    try {
      isCategoryLoading(true);
      var result = await CategoryService().get();
      if (result != null) {
        categoryList.assignAll(categoryFromJson(result.body));
      }
    } finally {
      isCategoryLoading(false);
    }
  }

  void postCategories(String name, int images) async {
    try {
      isCategoryLoading(true);

      var data = {
        "name": name,
        "images": images,
      };

      var result = await CategoryService().create(data);

      if (result.statusCode == 200 || result.statusCode == 201) {
        getCategories();
        print("Category created successfully: ${result.body}");
      } else {
        print(
            "Failed to create category: ${result.statusCode} - ${result.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isCategoryLoading(false);
    }
  }

  Future<void> fetchCategories() async {
  try {
    isCategoryLoading(true);
    var response = await CategoryService().get();
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      categoryList.value = (data['data'] as List)
          .map((item) => Category.categoryFromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  } catch (e) {
    print('Error fetching categories: $e');
  } finally {
    isCategoryLoading(false);
  }
}

}
