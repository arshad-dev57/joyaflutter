import 'package:get/get.dart';
import 'package:joya_app/screens/admin_all_vendors_screen.dart';
import 'package:joya_app/screens/admin_home_view.dart';
import 'package:joya_app/screens/login_screnn.dart';
import 'package:joya_app/screens/user_homeview.dart';
import 'package:joya_app/screens/vendor_homeview.dart';
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

    await Future.delayed(const Duration(seconds: 3));

    if (token == null || token.isEmpty) {
      Get.offAll(() => LoginScreen());
    } else {
      if (role == 'vendor') {
        Get.offAll(() => VendorHomeScreen());
      } else {
        Get.offAll(() => HomeScreen());
      }
    }
  }
}
