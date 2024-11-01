import 'package:ecommerce/model/currentUser.dart';
import 'package:flutter/material.dart';

import '../MainPage.dart';
import '../controller/controller.dart';
import '../data/DB_helper.dart';

class PaymentPage extends StatefulWidget {
  final int userId; // Add userId as a parameter to identify the user

  PaymentPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _addressController = TextEditingController();
  String _selectedPaymentMethod = 'PayPal';
  bool _useDefaultAddress = true; // Toggle for using default or entering a new address
  Map<String, dynamic>? _defaultAddress; // To hold the default address data

  @override
  void initState() {
    super.initState();
    _getDefaultAddress(); // Get the default address when the page initializes
  }

  Future<void> _getDefaultAddress() async {
    // Fetch the default address for the specific userId
    _defaultAddress = await DatabaseHelper.dataService.getDefaultAddress(widget.userId);
    
    // Check if the default address is null or empty
    if (_defaultAddress == null || 
        _defaultAddress!['address'] == null || 
        _defaultAddress!['address'].isEmpty) {
      setState(() {
        _useDefaultAddress = false; // Disable the default address option if it doesn't exist
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có địa chỉ mặc định. Vui lòng nhập địa chỉ giao hàng.')),
      );
    } else {
      setState(() {
        // Default address is available; keep the checkbox enabled
      });
    }
  }

  void _payWithStripe() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanh toán qua Stripe thành công!')),
      );
    } catch (e) {
      print("Stripe payment error: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thanh toán qua Stripe thất bại! \n Chi tiết: ${e.toString()}')),
      );
    }
  }

  void _payWithPayPal() {
    cartController.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đặt hàng thành công!')),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false,
      );
    });
  }

  void _submitPayment() {
    // Determine which address to use
    String address = _useDefaultAddress 
        ? (_defaultAddress?['address'] ?? '') 
        : _addressController.text;

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập địa chỉ giao hàng.')));
      return; // Exit if address is empty
    }

    // Proceed with payment based on the selected method
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
        title: const Text('Phương thức thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn địa chỉ giao hàng:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Checkbox(
                  value: _useDefaultAddress,
                  onChanged: (value) {
                    setState(() {
                      _useDefaultAddress = value ?? true;
                      if (_useDefaultAddress) {
                        _addressController.clear(); // Clear address field when using default
                      }
                    });
                  },
                ),
                const Text('Sử dụng địa chỉ mặc định'),
              ],
            ),
            if (!_useDefaultAddress) // Show this only if not using the default address
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
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
