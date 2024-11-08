import 'package:ecommerce/config/const.dart';
import 'package:ecommerce/model/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../pages/product/productDetailPage.dart';

class Productcard extends StatelessWidget {
  const Productcard({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    // Format price
    double price = product.tags.first.price;
    final formattedPrice = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    ).format(price);
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Material(
        elevation: 8,
        shadowColor: Colors.grey.shade300,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 6,
                child: Center(
                  child: Image.network(
                    baseUrl + product.images.first,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Giá : ${formattedPrice} VND',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
