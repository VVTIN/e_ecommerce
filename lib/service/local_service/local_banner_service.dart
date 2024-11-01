import 'package:ecommerce/model/banner.dart';
import 'package:hive/hive.dart';

class LocalBannerService {
  late Box<BannerModel> _bannerBox;

  Future<void> init() async {
    _bannerBox = await Hive.openBox<BannerModel>('Banners');
  }

  Future<void> assignAllBanners({required List<BannerModel> banners}) async {
    await _bannerBox.clear();
    await _bannerBox.addAll(banners);
  }

  List<BannerModel> getBanners() => _bannerBox.values.toList();
}
