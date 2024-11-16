import 'dart:convert';

import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/service/remote_service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();

  final RxList<ProductModel> listProduct =
      List<ProductModel>.empty(growable: true).obs;
  RxBool isProductLoading = false.obs;

  RxString searchValue = ''.obs;
  TextEditingController searchTextEditController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getProduct();
  }

  void getProduct() async {
    try {
      isProductLoading(true);
      var result = await ProductService().get();
      if (result != null) {
        listProduct.assignAll(productFromJson(result.body));
      }
    } finally {
      isProductLoading(false);
    }
  }

 void createProduct(ProductModel product) async {
  try {
    isProductLoading(true);

    // Convert product to map and log data
    var data = product.toMap();
    print('Request Body: $data');

    // Make API request
    var result = await ProductService().create(data);
    print('Response: ${result.body}');

    if (result.statusCode == 200 || result.statusCode == 201) {
       getProduct();
      Get.snackbar('Thành công', 'Sản phẩm đã được thêm!');
    } else {
      final errorResponse = jsonDecode(result.body);
      final errorMessage =
          errorResponse['error']['message'] ?? 'Lỗi không xác định';
      Get.snackbar('Lỗi', 'Không thể thêm sản phẩm. Chi tiết: $errorMessage');
    }
  } catch (e) {
    print('Error: $e');
    Get.snackbar('Lỗi', 'Đã xảy ra lỗi. Thử lại sau.');
  } finally {
    isProductLoading(false);
  }
}
void deleteProduct(int id) async {
  try {
    isProductLoading(true);

    var result = await ProductService().delete(id);
    print('Delete Response: ${result.body}');

    if (result.statusCode == 200 || result.statusCode == 204) {
      getProduct(); // Tải lại danh sách sản phẩm
      Get.snackbar('Thành công', 'Sản phẩm đã được xóa!');
    } else {
      final errorResponse = jsonDecode(result.body);
      final errorMessage =
          errorResponse['error']['message'] ?? 'Lỗi không xác định';
      Get.snackbar('Lỗi', 'Không thể xóa sản phẩm. Chi tiết: $errorMessage');
    }
  } catch (e) {
    print('Error: $e');
    Get.snackbar('Lỗi', 'Đã xảy ra lỗi khi xóa sản phẩm. Thử lại sau.');
  } finally {
    isProductLoading(false);
  }
}



  void getProductByName({required String keyword}) async {
    try {
      isProductLoading(true);
      var result = await ProductService().getByName(keyword: keyword);
      if (result != null) {
        listProduct.assignAll(productFromJson(result.body));
      }
    } finally {
      isProductLoading(false);
    }
  }

  void getProductByCategory({required int id}) async {
    try {
      isProductLoading(true);
      var result = await ProductService().getByCategory(id: id);
      if (result != null) {
        listProduct.assignAll(productFromJson(result.body));
      }
    } finally {
      isProductLoading(false);
    }
  }
}
