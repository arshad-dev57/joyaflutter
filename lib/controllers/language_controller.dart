import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  final Rx<Locale> currentLocale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  void changeLanguage(Locale locale) async {
    currentLocale.value = locale;
    Get.updateLocale(locale);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  void _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('language_code');
    if (code != null) {
      currentLocale.value = Locale(code);
      Get.updateLocale(currentLocale.value);
    }
  }
}
