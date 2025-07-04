import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/models/review_model.dart';
import 'package:joya_app/models/vendormodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:joya_app/controllers/services_controller.dart';
class AllVendorsController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final serviceController = Get.put(ServicesController());

  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
var reviewloading = false.obs;
  var isSubmitting = false.obs;
var vendors = <VendorModel>[].obs;
var isLoadingVendors = false.obs;
var reviewList = <ReviewModel>[].obs;
var getReviewsLoading = false.obs;
  RxString language = "English".obs;
  RxString role = "Vendor".obs;

  Rx<File?> imageFile = Rx<File?>(null);
  Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null);
  RxString imageBase64 = "".obs;
  var urlLinks = <Map<String, dynamic>>[].obs;
  final socialNameCtrl = TextEditingController();
  final socialUrlCtrl = TextEditingController();
  Rx<File?> socialImageFile = Rx<File?>(null);
  Rx<Uint8List?> socialImageBytes = Rx<Uint8List?>(null);
  RxString socialImageBase64 = "".obs;

  /// Pick main vendor image (web or mobile)
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        imageBytes.value = bytes;
        imageBase64.value = base64Encode(bytes);
      } else {
        final file = File(pickedFile.path);
        imageFile.value = file;
        final bytes = await file.readAsBytes();
        imageBase64.value = base64Encode(bytes);
      }
    }
  }

  Future<void> pickSocialIconImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        socialImageBytes.value = bytes;
        socialImageBase64.value = base64Encode(bytes);
      } else {
        final file = File(pickedFile.path);
        socialImageFile.value = file;
        final bytes = await file.readAsBytes();
        socialImageBase64.value = base64Encode(bytes);
      }
    }
  }

  /// Add one social link
  void addSocialLink() async {
    if (socialNameCtrl.text.isEmpty ||
        socialUrlCtrl.text.isEmpty ||
        (kIsWeb
            ? socialImageBytes.value == null
            : socialImageFile.value == null)) {
      Get.snackbar(
        "Error",
        "All fields are required for social link",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String imageBase64Str;
    if (kIsWeb) {
      imageBase64Str = base64Encode(socialImageBytes.value!);
    } else {
      final bytes = await socialImageFile.value!.readAsBytes();
      imageBase64Str = base64Encode(bytes);
    }

    urlLinks.add({
      "name": socialNameCtrl.text.trim(),
      "url": socialUrlCtrl.text.trim(),
      "image": imageBase64Str,
    });

    // Clear social link fields
    socialNameCtrl.clear();
    socialUrlCtrl.clear();
    socialImageFile.value = null;
    socialImageBytes.value = null;
    socialImageBase64.value = "";
  }

  /// Submit the vendor form to API
  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      print("Form invalid");
      return;
    }

    isSubmitting.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var url = Uri.parse('http://localhost:5000/api/vendors/create');

      // Build payload
      Map<String, dynamic> payload = {
        "firstname": firstNameCtrl.text.trim(),
        "lastname": lastNameCtrl.text.trim(),
        "username": usernameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "phone_number": phoneCtrl.text.trim(),
        "code": codeCtrl.text.trim(),
        "country": countryCtrl.text.trim(),
        "description": descriptionCtrl.text.trim().isNotEmpty
            ? descriptionCtrl.text.trim()
            : null,
        "services": serviceController.selectedServiceNames,
        "url": urlLinks,
        "image": imageBase64.value.isNotEmpty ? imageBase64.value : null,
      };

      // Remove null fields
      payload.removeWhere((key, value) => value == null);

      /// ✅ SAFE PAYLOAD LOGGING
      final payloadCopy = Map<String, dynamic>.from(payload);

      // Remove base64 image
      payloadCopy.remove("image");

      if (payloadCopy.containsKey("url")) {
        payloadCopy["url"] = (payloadCopy["url"] as List)
            .map((item) {
              final copy = Map<String, dynamic>.from(item);
              copy.remove("image");
              return copy;
            })
            .toList();
      }

      print("Safe Payload for debugging: ${jsonEncode(payloadCopy)}");

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonData = jsonDecode(response.body);
        if (jsonData["success"] == true) {
          Get.snackbar(
            "Success",
            jsonData["message"] ?? "Vendor created successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          clearForm();
        } else {
          Get.snackbar(
            "Error",
            jsonData["message"] ?? "Something went wrong",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to create vendor. Status: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print("Failed Response: ${response.body}");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Exception: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearForm() {
    firstNameCtrl.clear();
    lastNameCtrl.clear();
    usernameCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();
    codeCtrl.clear();
    countryCtrl.clear();
    descriptionCtrl.clear();
    serviceController.selectedServiceNames.clear();
    urlLinks.clear();
    imageFile.value = null;
    imageBytes.value = null;
    imageBase64.value = "";
    socialNameCtrl.clear();
    socialUrlCtrl.clear();
    socialImageFile.value = null;
    socialImageBytes.value = null;
    socialImageBase64.value = "";
  }

  Future<void> fetchVendors({
  required String country,
  required String service,
}) async {
  try {
    isLoadingVendors.value = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse(
      'http://localhost:5000/api/vendors/getmyvendors?service=$service&country=$country',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["success"] == true) {
        final List data = jsonData["data"];
print("Fetched ${data.length} vendors from server.");
        vendors.value = data
            .map((item) => VendorModel.fromJson(item))
            .toList();

        print("Fetched ${vendors.length} vendors from server.");
      } else {
        print("Failed to fetch vendors. Status: ${response.statusCode}");
        Get.snackbar(
          "Error",
          jsonData["message"] ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      print("Failed to fetch vendors. Status: ${response.statusCode}");
      Get.snackbar(
        "Error",
        "Failed to fetch vendors. Status: ${response.statusCode}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print("Fetch Vendors Exception: $e");
    Get.snackbar(
      "Error",
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoadingVendors.value = false;
  }
}



Future<void> addReview({
  required String vendorId,
  required String comment,
  required int rating,
}) async {
  try {
    reviewloading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      Get.snackbar(
        "Error",
        "Token missing. Please login again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    var url = Uri.parse('http://localhost:5000/api/reviews/create');

    var body = jsonEncode({
      "vendorId": vendorId,
      "comment": comment,
      "rating": rating,
    });

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 201) {
      var jsonData = jsonDecode(response.body);
      var review = ReviewModel.fromJson(jsonData["data"]);
      print("Review Added => ${review.comment}");
      Get.snackbar(
        "Success",
        "Review added successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Failed to add review",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print("Error while adding review: $e");
    Get.snackbar(
      "Error",
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    reviewloading.value = false;
  }
}
Future<void> getReviews(String vendorId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('http://localhost:5000/api/reviews/$vendorId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List data = jsonResponse["data"];

      List<ReviewModel> reviews = data
          .map((item) => ReviewModel.fromJson(item))
          .toList();

      reviewList.value = reviews;
      print("Fetched ${reviews.length} reviews");
    } else {
      print("Failed to fetch reviews. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error while fetching reviews: $e");
  }
}



}
