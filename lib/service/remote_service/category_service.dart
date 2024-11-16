import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/const.dart';

class CategoryService {
  var client = http.Client();
  var remoteUrl = '$baseUrl/api/categories';

  Future<dynamic> get() async {
    var response = await client.get(Uri.parse('$remoteUrl?populate=images'));
    return response;
  }

  Future<dynamic> create(Map<String, dynamic> data) async {
    var response = await client.post(
      Uri.parse(remoteUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({"data": data}),
    );
    return response;
  }

  Future<dynamic> update(String categoryId, Map<String, dynamic> data) async {
    var response = await client.put(
      Uri.parse('$remoteUrl/$categoryId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({"data": data}),
    );
    return response;
  }

  Future<http.Response> delete(String id) async {
    var response = await client.delete(
      Uri.parse('$remoteUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print('Delete response status: ${response.statusCode}');
    print('Delete response body: ${response.body}');
    return response;
  }
}
