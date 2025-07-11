import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:joya_app/screens/admin_home_view.dart';
import 'package:joya_app/screens/login_screnn.dart';
import 'package:joya_app/screens/user_homeview.dart';
import 'package:joya_app/screens/vendor_homeview.dart';
import 'package:joya_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  var selectedLanguage = 'English'.obs;
  var selectedCountry = ''.obs;
  var selectedRole = 'user'.obs;
  var isPasswordVisible = false.obs;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final countries = ['Pakistan', 'Saudi Arabia', 'UAE', 'Egypt', 'Qatar'];
  final roles = ['user', 'vendor', 'admin'];

  var isLoading = false.obs;
  Future<void> registerUser() async {
    isLoading.value = true;

    try {
      var url = Uri.parse('$baseUrl/users/signup');

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': userNameController.text.trim(),
          'email': emailController.text.trim(),
          'country': selectedCountry.value,
          'language': selectedLanguage.value,
          'role': selectedRole.value,
          'firstname': firstNameController.text.trim(),
          'lastname': lastNameController.text.trim(),
          'phone': phoneController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 201 && data["success"] == true) {
        // Fetch token and role
        String? token = data["token"];
        String? role = data["data"]["role"];
        String? username = data["data"]["username"];
       
        print("token $token");
        print("role $role");
          var countrylist = data['data']['country'];
print("token $token");
print("role $role");

var countryString = "";
if (countrylist != null && countrylist is List) {
  countryString = countrylist.join(", ");
} else if (countrylist is String) {
  countryString = countrylist;
}

        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (countryString != null) {
          await prefs.setString("country", countryString);
        }
        if (token != null) {
          await prefs.setString('token', token);
        }
        if (role != null) {
          await prefs.setString('role', role);
        }
        if (username != null) {
          await prefs.setString('username', username);
        }

        Get.snackbar(
          'Success',
          data["message"] ?? 'Registration successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print("my user  ${data['message']}");
        await Future.delayed(Duration(seconds: 2));

        if (token == null || token.isEmpty) {
          Get.offAll(() => LoginScreen());
        } else {
          if (role == 'vendor') {
            Get.offAll(() => VendorHomeScreen());
          } else if (role == 'admin') {
            Get.offAll(() => AdminDashboardScreen());
          } else if (role == 'user') {
            Get.offAll(() => HomeScreen());
          } else {
            Get.offAll(() => LoginScreen());
          }
        }
      } else {
        String errorMsg = data['message'] ?? 'Registration failed';
        Get.snackbar(
          'Error',
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Registration error: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
