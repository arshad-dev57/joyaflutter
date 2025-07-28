import 'package:get/get.dart';
import 'package:joya_app/screens/admin_home_view.dart';
import 'package:joya_app/screens/login_screnn.dart';
import 'package:joya_app/screens/user_homeview.dart';
import 'package:joya_app/screens/vendor_homeview.dart';
import 'package:joya_app/screens/disclaimer_screen.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }
Future<void> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? role = prefs.getString('role');
  bool hasAcceptedDisclaimer = prefs.getBool('disclaimerAccepted') ?? false;

  await Future.delayed(const Duration(seconds: 3));

  if (!hasAcceptedDisclaimer) {
    Get.offAll(() => DisclaimerScreen(),
        transition: Transition.cupertino, duration: Duration(milliseconds: 500));
  } else if (token == null || token.isEmpty) {
    Get.offAll(() => LoginScreen(),
        transition: Transition.fadeIn, duration: Duration(milliseconds: 500));
  } else {
    if (role == 'vendor') {
      Get.offAll(() => VendorHomeScreen(),
          transition: Transition.rightToLeft, duration: Duration(milliseconds: 500));
    } else if (role == 'admin') {
      Get.offAll(() => AdminDashboardScreen(),
          transition: Transition.rightToLeftWithFade, duration: Duration(milliseconds: 500));
    } else {
      Get.offAll(() => HomeScreen(),
          transition: Transition.rightToLeft, duration: Duration(milliseconds: 500));
    }
  }
}
}
