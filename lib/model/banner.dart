import 'dart:convert';
import 'dart:ui';
import '../config/const.dart';
import 'package:hive/hive.dart';

//chỉ ra path để lưu Adapter
part 'banner.g.dart';

List<BannerModel> bannerListFromJson(String value) => List<BannerModel>.from(
      json.decode(value)["data"].map((banner) => BannerModel.fromJson(banner)),
    );

@HiveType(typeId: 1)
class BannerModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String image;

  BannerModel({required this.id, required this.image});

  factory BannerModel.fromJson(Map<String, dynamic> data) => BannerModel(
        id: data["id"],
        image: baseUrl + data["image"]["url"],
      );
}
