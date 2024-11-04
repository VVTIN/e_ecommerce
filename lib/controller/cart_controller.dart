import 'package:ecommerce/data/DB_helper.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/product.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  var cart = <Cart>[].obs;
  var totalAmount = 0.obs; // This is an RxInt

  // Method to calculate total amount based on cart items
  double calculateTotalAmount() {
    double total = 0.0;
    for (var item in cart) {
      total += item.price * item.quantity.value; // Assuming each item has a price and quantity
    }
    totalAmount.value = total.toInt(); // Update the observable total amount
    return total; // Return the total amount
  }

  // Clear the cart
  void clearCart() {
    cart.clear(); // Example method to clear the cart
    totalAmount.value = 0; // Reset total amount
  }

  // Add product to cart
  void addToCart(ProductModel product, int quantity, double price) async {
    var exist = cart.firstWhereOrNull((item) => item.product.id == product.id);
    if (exist != null) {
      // If the product already exists, update its quantity
      exist.quantity.value += quantity;
    } else {
      // If the product does not exist, add it to the cart
      cart.add(Cart(product: product, quantity: quantity, price: price));
    }
    // Update the total amount after adding/updating the product
    calculateTotalAmount(); // Ensure the total amount is updated
  }

  // Update quantity of product in cart
  void updateQuantity(ProductModel product, int quantity) {
    var exist = cart.firstWhereOrNull((item) => item.product.id == product.id);
    if (exist != null) {
      exist.quantity.value = quantity;
      calculateTotalAmount(); // Update total when quantity is changed
    }
  }

  // Count product in icons cart
  int get cartCount => cart.length;

  // Total price of cart temporary
  int get totalQuantity =>
      cart.fold(0, (sum, item) => sum + item.quantity.value);
}
