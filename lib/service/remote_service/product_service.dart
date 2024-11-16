import 'dart:convert';

import 'package:ecommerce/config/const.dart';
import 'package:http/http.dart' as http;

class ProductService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/products';

  Future<dynamic> get() async {
    var response = await client
        .get(Uri.parse('$remoteUrl?populate[images]=*&populate[tags]=*'));
    return response;
  }

  Future<dynamic> create(Map<String,dynamic> data) async {
    var response = await client.post(
      Uri.parse(remoteUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({"data":data})
    );
    return response;
  }
  Future<dynamic>delete(int id)async{
    var response = await client.delete(Uri.parse('$remoteUrl/$id'));
    return response;
  }

//search product
  Future<dynamic> getByName({required String keyword}) async {
    var response = await client.get(Uri.parse(
        '$remoteUrl?populate[0]=images&populate[1]=tags&filters[name][\$contains]=$keyword'));
    return response;
  }

//Select a category to display corresponding products.
  Future<dynamic> getByCategory({required int id}) async {
    var response = await client.get(Uri.parse(
        '$remoteUrl?populate[0]=images&populate[1]=tags&filters[category][id]=$id'));
    return response;
  }
}
