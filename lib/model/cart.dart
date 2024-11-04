import 'package:get/get.dart';

import 'product.dart';

class Cart {
  final ProductModel product;
  final RxInt quantity;
  final double price;
  final int count;

  Cart({
    required this.product,
    required int quantity,
    required this.price,
    this.count = 1,
  }) : quantity = quantity.obs;

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      product: ProductModel.fromMap(map),
      quantity: map['quantity'],
      price: map['price'],
      count: map['count'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'quantity': quantity.value,
      'price': price,
      'count': count,
    };
  }
}
