// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class StripeService {
//   static String apiBase = 'https://api.stripe.com/v1';
//   static final String paymentApiUrl =
//       '${StripeService.apiBase}/payment_intents';

//   static String secretKey =
//       'sk_test_51QDrUIK0B49ZiSt2P9CY32etW3zXl6BlgGuFaK2edFdPrxhM6PxZ1AxUHTj1OMqyC6Xg7C8uc1pDk6Ud3piI13e100Q7kVfk1P';

//   static Map<String, String> headers = {
//     "Authorization": "Bearer ${StripeService.secretKey}",
//     "Content-Type": "application/x-www-form-urlencoded"
//   };

//   static init() {
//     Stripe.publishableKey =
//         'pk_test_51QDrUIK0B49ZiSt2A6yC4PbGvZL5taThDjVHduT0ESG8Rtzt74ES1hsOmNXOOfPpQmbbXdFsw86m98PpRaERQ8ku00gMnI5h9P';
//   }

//   static Future<Map<String, dynamic>> createPaymentIntent(
//       String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//         'payment_method_types[]': 'card', // Chỉ định đúng kiểu
//       };

//       var response = await http.post(
//         Uri.parse(StripeService.paymentApiUrl),
//         body: body,
//         headers: StripeService.headers,
//       );

//       if (response.statusCode != 200) {
//         throw Exception('Lỗi từ Stripe: ${response.body}');
//       }

//       return jsonDecode(response.body);
//     } catch (e) {
//       throw Exception('Không thể tạo ý định thanh toán: $e');
//     }
//   }

//   static Future<void> initPaymentSheet(String amount, String currency) async {
//     try {
//       final paymentIntent = await createPaymentIntent(amount, currency);
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntent['client_secret'],
//           merchantDisplayName: 'Dear programmer',
//           style: ThemeMode.system,
//         ),
//       );
//     } catch (e) {
//       throw Exception('Không thể khởi tạo bảng thanh toán: $e');
//     }
//   }

//   static Future<void> presentPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//     } catch (e) {
//       throw Exception('Không thể hiển thị bảng thanh toán: $e');
//     }
//   }
// }
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future createPaymentIntent({
  required String name,
  required String pin,
  required String city,
  required String state,
  required String country,
  required String address,
  required String currency,
  required String amount,
}) async {
  final url = Uri.parse("https://api.stripe.com/v1/payment_intents");
  final secretKey = dotenv.env['STRIPE_PUBLISH_KEY']!;
  final body = {
    'amount': amount,
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'description': "Test Donation",
    'shipping[name]': name,
    'shipping[address][line1]': address,
    'shipping[address][postal_code]': pin,
    'shipping[address][city]': city,
    'shipping[address][state]': state,
    'shipping[address][country]': country,
  };

  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $secretKey",
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: body,
  );

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    print(json);
    return json;
  } else {
    print("error in calling payment intent");
  }
}
