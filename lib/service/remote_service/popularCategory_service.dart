import 'package:ecommerce/config/const.dart';
import 'package:http/http.dart' as http;

class PopularCategoryService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/popular-categories';

  Future<dynamic> get() async {
    var response = await client.get(Uri.parse(
        '$remoteUrl?populate[category][populate]=images&pagination[start]=0&pagination[limit]=6'));
    return response;
  }
}
