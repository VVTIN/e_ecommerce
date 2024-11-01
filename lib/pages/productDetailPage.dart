import 'package:ecommerce/controller/controller.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/widget/products/view/productCarouselSlide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // quantity
  NumberFormat formatter = NumberFormat('00');
  int qty = 1;
  int tagIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Calculate final price based on the selected tag
    num price = widget.product.tags[tagIndex].price;
    num discount = widget.product.discount ?? 0;
    double finalPrice = price - (price * (discount / 100));

    // Format price
    final formattedPrice = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    ).format(finalPrice);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // carousel
            ProductCarouselSlide(images: widget.product.images),
            const SizedBox(height: 10),

            // name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                widget.product.name,
                style: TextStyle(
                  fontSize: 26,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Giá: $formattedPrice VND',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // quantity and size/color selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // quantity
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            if (qty > 1) {
                              setState(() {
                                qty--;
                              });
                            }
                          },
                          child: const Icon(CupertinoIcons.minus),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          formatter.format(qty),
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff00008B),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: const Offset(0, 3),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  qty++;
                                });
                              },
                              child: const Icon(CupertinoIcons.add),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),

                  // size or color selection
                  Container(
                    width: 190,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (tagIndex > 0) {
                              setState(() {
                                tagIndex--;
                              });
                            }
                          },
                          child: Icon(
                            Icons.keyboard_arrow_left_sharp,
                            size: 32,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            widget.product.tags[tagIndex].title,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (tagIndex != (widget.product.tags.length - 1)) {
                              setState(() {
                                tagIndex++;
                              });
                            }
                          },
                          child: Icon(
                            Icons.keyboard_arrow_right_sharp,
                            size: 32,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // product description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Mô tả sản phẩm',
                style: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                widget.product.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 4,
              ),
            ),
          ],
        ),
      ),

      // bottom navigation button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            final currentPrice = widget.product.tags[tagIndex].price;
            if (cartController.cart.any((item) =>
                item.product.id == widget.product.id &&
                item.product.tags[tagIndex] == tagIndex)) {
              cartController.updateQuantity(widget.product, qty);
            } else {
              cartController.addToCart(widget.product, qty, currentPrice);
            }
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Đã thêm vào giỏ hàng')));
            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              'Thêm vào giỏ hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
