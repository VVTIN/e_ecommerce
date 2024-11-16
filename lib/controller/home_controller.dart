import 'package:ecommerce/model/banner.dart';
import 'package:ecommerce/model/category.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/service/local_service/local_banner_service.dart';
import 'package:ecommerce/service/remote_service/banner_service.dart';
import 'package:ecommerce/service/remote_service/category_service.dart';
import 'package:ecommerce/service/remote_service/popularCategory_service.dart';
import 'package:ecommerce/service/remote_service/popularProduct_service.dart';
import 'package:ecommerce/service/remote_service/promotionProduct_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  //banner
  RxList<BannerModel> bannerList = List<BannerModel>.empty(growable: true).obs;
  RxBool isBannerLoading = false.obs;
  final LocalBannerService localBannerService = LocalBannerService();

//categoty
  RxList<Category> popularCategoryList =
      List<Category>.empty(growable: true).obs;
  RxBool isPopularCategoryLoading = false.obs;

//product
  RxList<ProductModel> popularProductList =
      List<ProductModel>.empty(growable: true).obs;
  RxBool isPopularProductLoading = false.obs;

  RxList<ProductModel> promotionProductList =
      List<ProductModel>.empty(growable: true).obs;
  RxBool isPromotionProductLoading = false.obs;

  @override
  void onInit() async {
    await localBannerService.init();
    getBanners();
    getPopularCategories();
    getPopularProducts();
    getPromotionProducts();
    super.onInit();
  }

//banner
  void getBanners() async {
    try {
      isBannerLoading(true);
      if (localBannerService.getBanners().isNotEmpty) {
        bannerList.assignAll(localBannerService.getBanners());
      }
      var result = await BannerService().get();
      if (result != null) {
        bannerList.assignAll(bannerListFromJson(result.body));
        localBannerService.assignAllBanners(
          banners: bannerListFromJson(result.body),
        );
      }
    } finally {
      isBannerLoading(false);
    }
  }

//category
  void getPopularCategories() async {
    try {
      isPopularCategoryLoading(true);
      var result = await PopularCategoryService().get();
      popularCategoryList.assignAll(popularCategoryFromJson(result.body));
    } finally {
      isPopularCategoryLoading(false);
    }
  }



//product
  void getPopularProducts() async {
    try {
      isPopularProductLoading(true);
      var result = await PopularProductService().get();
      popularProductList.assignAll(popularProductFromJson(result.body));
    } finally {
      isPopularProductLoading(false);
    }
  }

  void getPromotionProducts() async {
    try {
      isPromotionProductLoading(true);
      var result = await PromotionProduct().get();
      promotionProductList.assignAll(promotionProductFromJson(result.body));
    } finally {
      isPromotionProductLoading(false);
    }
  }
}
