import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:joya_app/screens/admin_home_view.dart';
import 'package:joya_app/screens/user_homeview.dart';
import 'package:joya_app/screens/vendor_homeview.dart';
import 'package:joya_app/utils/constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;

  var isLoading = false.obs;
Future<void> loginUser() async { 
  isLoading.value = true;
  try {
    var url = Uri.parse('$baseUrl/users/login');

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': userNameController.text,
        'password': passwordController.text,
      }),
    );
    print(response.body);
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var token = data['token'];
      var userId = data['data']['id'];
      var role = data['data']['role'];
      var firstname = data['data']['firstname'];
      var countryList = data['data']['country'];
      var image = data['data']['image'];
      var countryString = "";

      if (countryList != null && countryList is List) {
        countryString = countryList.join(", ");
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', token);
      await prefs.setString('role', role);
      await prefs.setString('country', countryString);
      await prefs.setString('userId', userId);
      await prefs.setString('username', firstname);

      if (image != null && image.toString().isNotEmpty) {
        await prefs.setString('image', image);
      } else {
        await prefs.remove('image'); // remove old one if exists
      }

      print("firstname: $firstname");
      print("Token Saved: $token");
      print("User Role: $role");
      print("Country Saved: $countryString");

      Get.snackbar('Success', 'Login successful!');

      if (role.toLowerCase() == 'vendor') {
        Get.offAll(() => VendorHomeScreen());
      } else if (role.toLowerCase() == 'user') {
        Get.offAll(() => HomeScreen());
      } else {
        Get.offAll(() => AdminDashboardScreen());
      }
    } else {
      print("status code: ${response.statusCode}");
      print('Login failed: ${response.body}');
      Get.snackbar('Error', 'Login failed!');
    }
  } catch (e) {
    print('Error: $e');
    Get.snackbar('Error', e.toString());
  } finally {
    isLoading.value = false;
  }
}


}
