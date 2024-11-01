import 'package:ecommerce/config/const.dart';
import 'package:ecommerce/controller/controller.dart';
import 'package:ecommerce/model/category.dart';

import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key, required this.category});
  final Category category;
  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool selected = false;

  void _onTap() {
    setState(() {
      selected = !selected;
    });
  }

  void _onSeeMoreTap() {
    dashboardController.updateIndex(1);
    productController.searchTextEditController.text = widget.category.name;
    productController.searchValue.value = 'cat:${widget.category.name}';
    productController.getProductByCategory(id: widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: InkWell(
        onTap: _onTap,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: selected ? 200 : 140,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(baseUrl + widget.category.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: const Alignment(-1, 0),
                      child: Text(
                        widget.category.name,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                      ),
                      child: InkWell(
                        onTap: _onSeeMoreTap,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            'Xem thêm',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
