import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ecommerce/service/remote_service/stripe_servive.dart';

import '../MainPage.dart';
import '../controller/controller.dart'; // Import your main page

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _addressController = TextEditingController();
  String _selectedPaymentMethod = 'PayPal';

  void _payWithStripe() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanh toán qua Stripe thành công!')),
      );
    } catch (e) {
      print("Stripe payment error: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Thanh toán qua Stripe thất bại! \n Chi tiết: ${e.toString()}')),
      );
    }
  }

  void _payWithPayPal() {
    // Clear the cart items'
    cartController.clearCart();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đặt hàng thành công!')),
    );

    // Navigate back to MainPage after a delay to allow the user to see the success message
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false,
      );
    });
  }

  void _submitPayment() {
    String address = _addressController.text;
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập địa chỉ giao hàng.')));
      return;
    }

    if (_selectedPaymentMethod == 'PayPal') {
      _payWithPayPal();
    } else {
      _payWithStripe();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập địa chỉ giao hàng:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(hintText: 'Địa chỉ giao hàng'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Chọn phương thức thanh toán:',
              style: TextStyle(fontSize: 18),
            ),
            RadioListTile(
              title: const Text('Thanh toán tiền mặt'),
              value: 'PayPal',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value as String;
                });
              },
            ),
            RadioListTile(
              title: const Text('Thẻ tín dụng'),
              value: 'Credit Card',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value as String;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitPayment,
                child: const Text('Xác nhận '),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
