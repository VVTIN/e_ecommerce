import 'package:ecommerce/data/DB_helper.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/currentUser.dart';
import 'package:ecommerce/model/order.dart';
import 'package:ecommerce/model/product.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  var cart = <Cart>[].obs;
  var totalAmount = 0.obs;

  double calculateTotalAmount() {
    double total = 0.0;
    for (var item in cart) {
      total += item.price * item.quantity.value;
    }
    totalAmount.value = total.toInt();
    return total;
  }

  void clearCart() {
    cart.clear();
    totalAmount.value = 0;
  }

  void addToCart(ProductModel product, int quantity, double price) async {
    await DatabaseHelper.dataService.addCart(
        Cart(product: product, quantity: quantity, price: price),
        CurrentUser().id!);
    var exist = cart.firstWhereOrNull((item) => item.product.id == product.id);
    if (exist != null) {
      exist.quantity.value += quantity;
    } else {
      cart.add(Cart(product: product, quantity: quantity, price: price));
    }
    calculateTotalAmount();
  }

  void updateQuantity(ProductModel product, int quantity) {
    var exist = cart.firstWhereOrNull((item) => item.product.id == product.id);
    if (exist != null) {
      exist.quantity.value = quantity;
      calculateTotalAmount();
    }
  }

  int get cartCount => cart.length;

  int get totalQuantity =>
      cart.fold(0, (sum, item) => sum + item.quantity.value);

  Future<List<CartItem>> getCartItems(int userId) async {
    final db = await DatabaseHelper.dataService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cart',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return CartItem(
        productId: maps[i]['productId'] ?? 0,
        productName: maps[i]['productName'] ?? '',
        price: maps[i]['price'] ?? 0.0,
        quantity: maps[i]['quantity'] ?? 0,
      );
    });
  }
   
}
