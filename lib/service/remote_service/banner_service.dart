import 'package:ecommerce/config/const.dart';
import 'package:http/http.dart' as http;

class BannerService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/banners';

  Future<dynamic> get() async {
    var response = await client.get(Uri.parse('$remoteUrl?populate=image'));
    return response;
  }
}
