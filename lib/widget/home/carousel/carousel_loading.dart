import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CarouselLoading extends StatelessWidget {
  const CarouselLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: AspectRatio(
            aspectRatio: 12 / 7,
            child: Container(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
