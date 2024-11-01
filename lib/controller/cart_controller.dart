import 'package:ecommerce/data/DB_helper.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/product.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  var cart = <Cart>[].obs;

  //
  //add product to cart
  void addToCart(ProductModel product, int quantity, num price) async {
    var exist = cart.firstWhereOrNull((item) => item.product.id == product.id);
    if (exist != null) {
      exist.quantity.value += quantity;
    } else {
      cart.add(Cart(product: product, quantity: quantity, price: price));
    }
  }

//update quantity of product in cart
  void updateQuantity(ProductModel product, int quantity) {
    var exist = cart.firstWhereOrNull((item) => item.product.id == product.id);
    if (exist != null) {
      exist.quantity.value = quantity;
    }
  }

  // Clear all items from cart
  void clearCart() {
    cart.clear();
    
  }

  //count product in icons cart
  int get cartCount => cart.length;

  //total price of cart temporary
  int get totalQuantity =>
      cart.fold(0, (sum, item) => sum + item.quantity.value);
}
