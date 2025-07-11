import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joya_app/models/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:joya_app/screens/login_screnn.dart';
import 'package:joya_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileController extends GetxController {
  var isLoading = false.obs;
  var userProfile = Rxn<UserProfileModel>();

  @override
  void onInit() {
    fetchUserProfile();
    super.onInit();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var url = Uri.parse('$baseUrl/users/profile');

      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        userProfile.value = UserProfileModel.fromJson(jsonData['data']);

        print("Profile fetched: ${userProfile.value?.name}");
        print("profile fetched: ${userProfile.value?.phone}");
      } else {
        print("Failed to fetch profile. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logoutUser() async {
    isLoading.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var url = Uri.parse('$baseUrl/users/logout');

      var response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
        await prefs.remove('role');

        Get.snackbar(
          'Success',
          'Logged out successfully!',
          backgroundColor:
              Get.theme.snackBarTheme.backgroundColor ?? Colors.green.shade100,
        );

        Get.to(LoginScreen());
      } else {
        print('Logout failed: ${response.body}');
        Get.snackbar(
          'Error',
          'Logout failed!',
          backgroundColor:
              Get.theme.snackBarTheme.backgroundColor ?? Colors.red.shade100,
        );
      }
    } catch (e) {
      print('Error logging out: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor:
            Get.theme.snackBarTheme.backgroundColor ?? Colors.red.shade100,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
