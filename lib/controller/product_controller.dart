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
