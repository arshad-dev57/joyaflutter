import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:joya_app/screens/login_screnn.dart';
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
  final roles = ['user', 'vendor'];
  
  var isLoading = false.obs;

  Future<void> registerUser() async {
    isLoading.value = true;

    try {
      var url = Uri.parse('http://localhost:5000/api/users/signup');

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': userNameController.text,
          'email': emailController.text,
          'country': selectedCountry.value,
          'language': selectedLanguage.value,
          'role': selectedRole.value,
          'firstname': firstNameController.text,
          'lastname': lastNameController.text,
          'phone': phoneController.text,
          'password': passwordController.text,
        }),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Registration successful!');

        Get.offAll(() => LoginScreen());
      } else {
        String errorMsg = data['message'] ?? 'Registration failed';
        Get.snackbar('Error', "error occurred in register");
      }
    } catch (e) {
      print('Registration error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
