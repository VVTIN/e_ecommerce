import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart'as http;
import 'package:path/path.dart';

import 'keys.dart';
class PaymentAPI{
   Future<Map<String, dynamic>?> makeIntentForPayment(
      int amountToBeCharged, String currency) async {
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
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(
              content: Text('Không thể tạo thanh toán. Vui lòng thử lại.')),
        );
        return null;
      }
    } catch (error) {
      print("Error in makeIntentForPayment: $error");
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(
            content: Text(
                'Đã xảy ra lỗi khi tạo thanh toán. Vui lòng kiểm tra lại.')),
      );
      return null;
    }
  }

//

}