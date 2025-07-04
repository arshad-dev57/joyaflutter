import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:joya_app/screens/user_homeview.dart';
import 'package:joya_app/screens/vendor_homeview.dart';
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
    var url = Uri.parse('http://localhost:5000/api/users/login');

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
      var role = data['data']['role'];
      var countryList = data['data']['country'];

      // Optional: Join country list into comma-separated string
      var countryString = "";
      if (countryList != null && countryList is List) {
        countryString = countryList.join(", ");
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('role', role);
      await prefs.setString('country', countryString);

      print("Token Saved: $token");
      print("User Role: $role");
      print("Country Saved: $countryString");

      Get.snackbar('Success', 'Login successful!');

      if (role.toLowerCase() == 'vendor') {
        Get.offAll(() => VendorHomeScreen());
      } else {
        Get.offAll(() => HomeScreen());
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
