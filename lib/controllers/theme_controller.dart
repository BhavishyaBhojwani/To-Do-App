import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void switchTheme(bool value) {
    if (isDarkMode.value != value) {
      isDarkMode.value = value;
      Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    }
  }
}
