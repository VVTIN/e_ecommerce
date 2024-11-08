import 'package:ecommerce/config/const.dart';
import 'package:ecommerce/model/currentUser.dart';
import 'package:ecommerce/pages/paymentPage.dart';
import 'package:ecommerce/widget/cart/quantity_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/controller/cart_controller.dart';
import 'package:ecommerce/model/product.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: Obx(() {
        if (cartController.cart.isEmpty) {
          return Center(child: Text('Giỏ hàng trống!'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: cartController.cart.length,
          itemBuilder: (context, index) {
            final cartItem = cartController.cart[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          '$baseUrl${cartItem.product.images[0]}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error, color: Colors.red),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            cartItem.product.discount != null
                                ? '${cartItem.product.name} (giảm ${cartItem.product.discount}%)'
                                : cartItem.product.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),

                          // Price
                          Text(
                            'Giá: ${NumberFormat('###,###,###').format(cartItem.price)} VND',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Quantity
                          QuantityButton(
                            onPressedMinus: () {
                              if (cartItem.quantity.value > 1) {
                                cartItem.quantity.value--;
                              } else {
                                cartController.cart.removeAt(index);
                              }
                            },
                            onPressedAdd: () {
                              cartItem.quantity.value++;
                            },
                            qty: () => Text(
                              '${cartItem.quantity.value}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        double totalAmount = 0;
        for (var item in cartController.cart) { 
          double finalPrice =
              item.price - (item.price * (item.product.discount ?? 0) / 100);
          totalAmount += finalPrice * item.quantity.value;
        }
        return Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Tổng: ${NumberFormat('###,###,###').format(totalAmount)} VND',
                  style: const TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => PaymentPage(userId: CurrentUser().id!));
                },
                child: const Text('Thanh toán', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        );
      }),
    );
  }
}
