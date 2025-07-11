import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:joya_app/controllers/language_controller.dart';
import 'package:joya_app/splash_view.dart';
import 'package:joya_app/utils/app_translation.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final languageController = Get.put(LanguageController());
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          translations: AppTranslations(),
          locale: const Locale('en'),
          fallbackLocale: const Locale('en'),
          theme: ThemeData(
            fontFamily: 'Poppins', 
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: SplashView(),
        );
      },
    );
  }
}
