import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/config/const.dart';
import 'package:flutter/material.dart';

class ProductCarouselSlide extends StatefulWidget {
  const ProductCarouselSlide({super.key, required this.images});
  final List<String> images;
  @override
  State<ProductCarouselSlide> createState() => _ProductCarouselSlideState();
}

class _ProductCarouselSlideState extends State<ProductCarouselSlide> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.images
              .map((e) => Container(
                    color: Colors.white,
                    child: Image.network(
                      baseUrl + e,
                      fit: BoxFit.contain,
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayAnimationDuration: Duration(seconds: 2),
            autoPlayInterval: Duration(seconds: 10),
          ),
        )
      ],
    );
  }
}
