import 'package:http/http.dart' as http;

import '../../config/const.dart';

class CategoryService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/categories';

  Future<dynamic> get() async {
    var response = await client.get(Uri.parse('$remoteUrl?populate=images'));
    return response;
  }
}
