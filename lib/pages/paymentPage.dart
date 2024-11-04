import 'package:ecommerce/model/currentUser.dart';
import 'package:ecommerce/widget/cart/payment/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../MainPage.dart';
import '../controller/controller.dart';
import '../data/DB_helper.dart';
import 'dart:convert';

class PaymentPage extends StatefulWidget {
  final int userId;

  PaymentPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _addressController = TextEditingController();
  String _selectedPaymentMethod = 'PayPal';
  bool _useDefaultAddress = true;
  Map<String, dynamic>? _defaultAddress;

  @override
  void initState() {
    super.initState();
    _getDefaultAddress();
  }

  Future<void> _getDefaultAddress() async {
    _defaultAddress = await DatabaseHelper.dataService.getDefaultAddress(widget.userId);
    if (_defaultAddress == null || _defaultAddress!['address'] == null || _defaultAddress!['address'].isEmpty) {
      setState(() {
        _useDefaultAddress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có địa chỉ mặc định. Vui lòng nhập địa chỉ giao hàng.')),
      );
    } else {
      setState(() {});
    }
  }

  double getAmount() {
    return cartController.calculateTotalAmount();
  }

  Map<String, dynamic>? intentPaymentData;

  Future<void> showPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((val) {
        intentPaymentData = null;
        cartController.clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thanh toán thành công!')),
        );

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainPage()),
            (Route<dynamic> route) => false,
          );
        });
      }).onError((errorMsg, sTrace) {
        if (kDebugMode) {
          print(errorMsg.toString() + sTrace.toString());
        }
      });
    } on StripeException catch (error) {
      if (kDebugMode) {
        print(error);
      }
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(content: Text('Đã hủy bỏ')),
      );
    } catch (errorMsg) {
      if (kDebugMode) {
        print(errorMsg);
      }
    }
  }

  Future<Map<String, dynamic>?> makeIntentForPayment(int amountToBeCharged, String currency) async {
    try {
      Map<String, dynamic> paymentInfo = {
        "amount": amountToBeCharged.toString(),
        "currency": currency,
        "payment_method_types[]": "card",
      };

      var responseFromStripeAPI = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: paymentInfo,
        headers: {
          'Authorization': 'Bearer $Secretkey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (responseFromStripeAPI.statusCode == 200) {
        return jsonDecode(responseFromStripeAPI.body); 
      } else {
        print("Failed to create payment intent: ${responseFromStripeAPI.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tạo thanh toán. Vui lòng thử lại.')),
        );
        return null;
      }
    } catch (error) {
      print("Error in makeIntentForPayment: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xảy ra lỗi khi tạo thanh toán. Vui lòng kiểm tra lại.')),
      );
      return null;
    }
  }

  Future<void> paymentSheetInitialization(int amountToBeCharged, String currency) async {
    try {
      intentPaymentData = await makeIntentForPayment(amountToBeCharged, currency);

      if (intentPaymentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            allowsDelayedPaymentMethods: true,
            paymentIntentClientSecret: intentPaymentData!["client_secret"],
            style: ThemeMode.dark,
            merchantDisplayName: "company ecommerce",
          ),
        );
        await showPaymentSheet();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tạo thanh toán. Vui lòng thử lại.')),
        );
      }
    } catch (errorMsg, s) {
      if (kDebugMode) {
        print("Error initializing payment sheet: $errorMsg \n$s");
      }
    }
  }

  void _payWithStripe() async {
    try {
      double amount = getAmount();
      int amountInCents = (amount ).toInt(); 

      

      await paymentSheetInitialization(amountInCents, "vnd");
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
    String address = _useDefaultAddress ? (_defaultAddress?['address'] ?? '') : _addressController.text;
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ giao hàng.')),
      );
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
        title: const Text('Phương thức thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chọn địa chỉ giao hàng:', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Checkbox(
                  value: _useDefaultAddress,
                  onChanged: (value) {
                    setState(() {
                      _useDefaultAddress = value ?? true;
                      if (_useDefaultAddress) {
                        _addressController.clear();
                      }
                    });
                  },
                ),
                const Text('Sử dụng địa chỉ mặc định'),
              ],
            ),
            if (!_useDefaultAddress)
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(hintText: 'Địa chỉ giao hàng'),
              ),
            const SizedBox(height: 20),
            const Text('Chọn phương thức thanh toán:', style: TextStyle(fontSize: 18)),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
