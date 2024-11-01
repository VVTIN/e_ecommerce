// import 'dart:convert';

// import 'package:ecommerce/model/user.dart';
// import 'package:ecommerce/pages/auth/authencation.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<bool> saveUser(User objUser) async {
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String strUser = jsonEncode(objUser);
//     prefs.setString('user', strUser);
//     print("Luu thanh cong: $strUser");
//     return true;
//   } catch (e) {
//     print(e);
//     return false;
//   }
// }

// Future<bool> logOut(BuildContext context) async {
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('user', '');
//     print("Logout thành công");
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const AuthencationPage()),
//         (route) => false);
//     return true;
//   } catch (e) {
//     print(e);
//     return false;
//   }
// }

// //
// Future<User> getUser() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   String strUser = pref.getString('user')!;
//   return User.fromJson(jsonDecode(strUser));
// }
