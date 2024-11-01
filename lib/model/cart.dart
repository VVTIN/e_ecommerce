import 'package:ecommerce/model/product.dart';
import 'package:get/get.dart';

class Cart {
  final ProductModel product;
  final RxInt quantity;
  final num price;
  int count;

  Cart({
    required this.product,
    required int quantity,
    required this.price,
    this.count = 0,
  }) : quantity = quantity.obs;
}
