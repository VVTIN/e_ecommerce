import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void ConfigLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = true;
}
