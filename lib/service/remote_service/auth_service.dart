import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce/config/const.dart';

import 'package:http/http.dart' as http;

import '../../model/currentUser.dart';

// class AuthService {
//   var client = http.Client();

//   Future<dynamic> signUp(
//       {required String email, required String password}) async {
//     var body = {"username": email, "email": email, "password": password};
//     var respose = await client.post(
//         Uri.parse('$baseUrl/api/auth/local/register'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(body));
//     return respose;
//   }

//   // Future<dynamic> createProfile(
//   //     {required String fullName, required String token}) async {
//   //   var body = {"fullName": fullName};
//   //   var respose = await client.post(Uri.parse('$baseUrl/api/profiles'),
//   //       headers: {
//   //         "Content-Type": "application/json",
//   //         "Authorization": "Bearer $token",
//   //       },
//   //       body: jsonEncode(body));
//   //   return respose;
//   // }
// }

class AuthService {
  void logoutUser() {
    CurrentUser().clearUser();
  }
}
