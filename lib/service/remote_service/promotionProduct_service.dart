import 'package:ecommerce/config/const.dart';
import 'package:http/http.dart' as http;

class PromotionProduct {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/promotion-products';

  Future<dynamic> get() async {
    var response = await client
        .get(Uri.parse('$remoteUrl?populate[product][populate]=images'));
    return response;
  }
}
