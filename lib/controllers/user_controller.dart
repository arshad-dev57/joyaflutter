import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UsersController extends GetxController {
  var usersList = <UserModel>[].obs;
  var filteredList = <UserModel>[].obs;
  var isLoading = false.obs;
  var updateLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedRole = 'All'.obs;
var totalUsers = 0.obs;
var totalVendors = 0.obs;
var totalServices = 0.obs;
var totalAds = 0.obs;
var totalPaymentLinks = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }
    final ImagePicker _picker = ImagePicker();

int getCountByRole(String role) {
  if (role.toLowerCase() == 'all') return usersList.length;
  return usersList.where((user) => user.role.toLowerCase() == role.toLowerCase()).length;
}
 void filterUsers() {
  final query = searchQuery.value.toLowerCase();
  final role = selectedRole.value.toLowerCase();

  filteredList.value = usersList.where((user) {
    final matchesQuery =
        (user.firstname.toLowerCase().contains(query)) ||
        (user.lastname.toLowerCase().contains(query)) ||
        (user.email.toLowerCase().contains(query)) ||
        (user.phone.toLowerCase().contains(query));

    final matchesRole =
        role == 'all' || user.role.toLowerCase() == role;

    return matchesQuery && matchesRole;
  }).toList();
}


 Future<void> fetchAllUsers() async {
  try {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/users/getallusers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      totalUsers.value = body['usercount'] ?? 0;
      totalVendors.value = body['vendorcount'] ?? 0;
      totalServices.value = body['servicescount'] ?? 0;
      totalAds.value = body['adcount'] ?? 0;
      totalPaymentLinks.value = body['paymentlinkcount'] ?? 0;
      usersList.value = data.map((user) => UserModel.fromJson(user)).toList();
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

 Future<void> deleteUser(String userId) async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = Uri.parse("$baseUrl/users/deleteuser/$userId");

      final response = await http.delete(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        usersList.removeWhere((user) => user.id == userId);

        Get.snackbar(
          "Success",
          "User deleted successfully.",
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchAllUsers();
      } else {
        print("Failed to delete user. ${response.body}");
        
        Get.snackbar(
          "Error",
          "Failed to delete user. ${response.body}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Exception: ${e.toString()}");
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserPaymentStatus(String userId, String paymentStatus) async {
  try {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$baseUrl/users/updatepaymentstatus'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userId': userId,
        'paymentStatus': paymentStatus, 
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Payment status updated to $paymentStatus.',
        snackPosition: SnackPosition.BOTTOM,
      );

      await fetchAllUsers();
    } else {
      final error = jsonDecode(response.body);
      Get.snackbar('Error', error['message'] ?? 'Failed to update status');
      print("Error: ${response.body}");
    }
  } catch (e) {
    Get.snackbar('Error', e.toString());
    print("Exception: ${e.toString()}");
  } finally {
    isLoading.value = false;
  }
}

Rx<XFile?> selectedImage = Rx<XFile?>(null);

Future<void> pickImage() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    selectedImage.value = image;
  } else {
    Get.snackbar("No Image", "Image not selected");
  }
}

  Future<void> updateProfileImage({
    required Uint8List? webImageBytes,
    required File? mobileImageFile,
    required String userId,
  }) async {
    try {
      updateLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar("Auth Error", "User token not found");
        return;
      }

      final uri = Uri.parse("$baseUrl/users/updateuserimage/$userId");
      var request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';

      if (kIsWeb && webImageBytes != null) {
        final multipartFile = http.MultipartFile.fromBytes(
          'image',
          webImageBytes,
          filename: 'profile_image_web.jpg',
        );
        request.files.add(multipartFile);
      } else if (!kIsWeb && mobileImageFile != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'profile_picture',
          mobileImageFile.path,
        );
        request.files.add(multipartFile);
      } else {
        Get.snackbar("Error", "No image selected");
        return;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("✅ Ad created");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('image', response.body);
        Get.snackbar("Success", "Profile image updated successfully");
      } else {
        print("❌ Failed to create ad: ${response.body}");
      }
    } catch (e) {
      print("❌ Error creating ad: $e");
    } finally {
      updateLoading.value = false;
    }
  }

  }
