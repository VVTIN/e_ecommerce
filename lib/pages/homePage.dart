import 'package:ecommerce/controller/controller.dart';
import 'package:ecommerce/pages/product/productPage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../widget/home/carousel/carouselSlider.dart';
import '../widget/home/categories/listCategories.dart';
import '../widget/home/products/listPopularProduct.dart';
import '../widget/home/products/listPromotionProduct.dart';
import '../widget/home/sectionTitle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = HomeController.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
          child: Column(
        children: [
          //carousel
          const CarouselSliderBanner(),
          const SizedBox(height: 8.0),

          //Content
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            decoration: const BoxDecoration(
              color: Color(0xffCAE1FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                //

                // list of categories
                SectionTitle(
                  title: 'Danh mục ',
                  onPressed: () {},
                  text: '',
                ),
                const ListCategories(),
                const SizedBox(height: 5.0),

                // list of popular products
                SectionTitle(
                  title: 'Sản phẩm nổi bật',
                  onPressed: () {},
                  text: 'Xem thêm >',
                ),
                const ListPopularProduct(),
                const SizedBox(height: 5.0),

                // list of promotion products
                SectionTitle(
                  title: 'Sản phẩm khuyến mãi',
                  onPressed: () {},
                  text: '',
                ),
                const ListPromotionProduct(),
                const SizedBox(height: 5.0),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
