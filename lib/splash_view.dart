import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
   SplashView({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: Image(image: AssetImage('assets/splash-screen.png',),fit: BoxFit.cover,)),
        ],
      ),
    );
  }
}