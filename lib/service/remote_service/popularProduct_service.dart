import 'package:ecommerce/config/const.dart';
import 'package:http/http.dart' as http;

class PopularProductService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/popular-products';

  Future<dynamic> get() async {
    var response =
        client.get(Uri.parse('$remoteUrl?populate[product][populate]=images'));
    return response;
  }
}
