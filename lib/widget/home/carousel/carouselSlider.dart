import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/controller/home_controller.dart';
import 'package:ecommerce/widget/home/carousel/carousel_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarouselSliderBanner extends StatelessWidget {
  const CarouselSliderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = HomeController.instance;
    return Obx(() {
      if (controller.isBannerLoading.value) {
        return CarouselLoading();
      }

      return Container(
        child: CarouselSlider(
          items: controller.bannerList.map((banner) {
            return Builder(
              builder: (context) {
                return Container(
                  child: Image.network(
                    banner.image,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayAnimationDuration: Duration(seconds: 2),
            autoPlayInterval: Duration(seconds: 10),
          ),
        ),
      );
    });
  }
}
