import 'package:ecommerce/config/config_loading.dart';

import 'package:ecommerce/controller/cart_controller.dart';
import 'package:ecommerce/controller/category_controller.dart';
import 'package:ecommerce/controller/dashboard_controller.dart';
import 'package:ecommerce/controller/home_controller.dart';
import 'package:ecommerce/controller/product_controller.dart';
import 'package:ecommerce/model/banner.dart';
import 'package:ecommerce/pages/auth/authencation.dart';
import 'package:ecommerce/theme/appTheme.dart';
import 'package:ecommerce/widget/payment/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/DB_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  Stripe.publishableKey = Publishablekey;
  await Stripe.instance.applySettings();

  await Hive.initFlutter();

  await DatabaseHelper().database;
//register adapter
  Hive.registerAdapter(BannerModelAdapter());

  Get.put(HomeController());
  Get.put(ProductController());
  Get.put(CategoryController());
  Get.put(DashboardController());
  Get.put(CartController());

  ConfigLoading();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      builder: EasyLoading.init(),
      home: const AuthencationPage(),
    );
  }
}
