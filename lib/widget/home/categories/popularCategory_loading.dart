import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PopularCategoryLoading extends StatelessWidget {
  const PopularCategoryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 5,
        ),
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              width: 185,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
      // child: ListView.builder(
      //   scrollDirection: Axis.horizontal,
      //   itemCount: 5,
      //   itemBuilder: (context, index) {
      //     return Shimmer.fromColors(
      //       baseColor: Colors.grey.shade300,
      //       highlightColor: Colors.white,
      //       child: Container(
      //         margin: const EdgeInsets.symmetric(horizontal: 5),
      //         decoration: BoxDecoration(
      //           color: Colors.grey,
      //           borderRadius: BorderRadius.circular(15),
      //         ),
      //         width: 185,
      //         child: ClipRRect(
      //           borderRadius: BorderRadius.circular(15),
      //           child: Container(
      //             color: Colors.grey,
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
