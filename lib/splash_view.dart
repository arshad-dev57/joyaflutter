import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/splash_controller.dart';
import 'package:joya_app/utils/colors.dart';
class SplashView extends StatelessWidget {
   SplashView({super.key});
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: backgroungcolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/joya.png',),fit: BoxFit.cover,),
        ],
      ),
    );
  }
}