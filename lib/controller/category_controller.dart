import 'package:ecommerce/model/category.dart';
import 'package:ecommerce/service/remote_service/category_service.dart';
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
}
