import 'package:ecommerce/model/banner.dart';
import 'package:ecommerce/model/category.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/service/local_service/local_banner_service.dart';
import 'package:ecommerce/service/remote_service/banner_service.dart';
import 'package:ecommerce/service/remote_service/popularCategory_service.dart';
import 'package:ecommerce/service/remote_service/popularProduct_service.dart';
import 'package:ecommerce/service/remote_service/promotionProduct_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  RxList<BannerModel> bannerList = List<BannerModel>.empty(growable: true).obs;
  RxBool isBannerLoading = false.obs;
  final LocalBannerService localBannerService = LocalBannerService();

  RxList<Category> popularCategoryList =
      List<Category>.empty(growable: true).obs;
  RxBool isPopularCategoryLoading = false.obs;

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

  void getBanners() async {
    try {
      isBannerLoading(true);
      //local banner before api call
      if (localBannerService.getBanners().isNotEmpty) {
        bannerList.assignAll(localBannerService.getBanners());
      }
      //call api
      var result = await BannerService().get();
      if (result != null) {
        //assign api result
        bannerList.assignAll(bannerListFromJson(result.body));
        //save api to local db
        localBannerService.assignAllBanners(
          banners: bannerListFromJson(result.body),
        );
      }
    } finally {
      isBannerLoading(false);
    }
  }

  void getPopularCategories() async {
    try {
      isPopularCategoryLoading(true);
      var result = await PopularCategoryService().get();
      popularCategoryList.assignAll(popularCategoryFromJson(result.body));
    } finally {
      isPopularCategoryLoading(false);
    }
  }

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