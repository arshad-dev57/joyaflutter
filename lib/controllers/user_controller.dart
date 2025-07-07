import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UsersController extends GetxController {
  var usersList = <UserModel>[].obs;
  var filteredList = <UserModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedRole = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  void filterUsers() {
    final query = searchQuery.value.toLowerCase();
    final role = selectedRole.value;

    filteredList.value = usersList.where((user) {
      final matchesQuery =
          (user.firstname.toLowerCase().contains(query)) ||
          (user.lastname.toLowerCase().contains(query)) ||
          (user.email.toLowerCase().contains(query)) ||
          (user.phone.toLowerCase().contains(query));

      final matchesRole =
          role == 'All' || user.role.toLowerCase() == role.toLowerCase();

      return matchesQuery && matchesRole;
    }).toList();
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('http://localhost:5000/api/users/getallusers'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'];

        usersList.value =
            data.map((user) => UserModel.fromJson(user)).toList();

        filterUsers();
      } else {
        Get.snackbar('Error', 'Failed to load users');
        print("Error: ${response.body}");
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
      print("Exception: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
