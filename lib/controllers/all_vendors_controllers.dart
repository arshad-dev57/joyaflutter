import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:joya_app/controllers/services_controller.dart';
import 'package:joya_app/models/portfolio_model.dart';
import 'package:joya_app/models/review_model.dart';
import 'package:joya_app/models/vendormodel.dart';
import 'package:joya_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final paymentlinkCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final searchController = TextEditingController();
  final passwordCtrl = TextEditingController();
  var reviewloading = false.obs;
  var isSubmitting = false.obs;
  var vendors = <VendorModel>[].obs;
  var isLoadingVendors = false.obs;
  var reviewList = <ReviewModel>[].obs;
  RxString language = "English".obs;
  RxString role = "Vendor".obs;
  var submitloading = false.obs;

  Rx<File?> imageFile = Rx<File?>(null);
  Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null);

  Rx<File?> socialImageFile = Rx<File?>(null);
  Rx<Uint8List?> socialImageBytes = Rx<Uint8List?>(null);

  var urlLinks = <Map<String, dynamic>>[].obs;
  final socialNameCtrl = TextEditingController();
  var allVendors = <VendorModel>[];      // ✅ ADD THIS LINE

  final socialUrlCtrl = TextEditingController();

void filterVendors(String query) {
  if (query.isEmpty) {
    vendors.assignAll(allVendors);
  } else {
    vendors.assignAll(
      allVendors.where((v) {
        final name = "${v.firstname} ${v.lastname}".toLowerCase();
        final email = v.email.toLowerCase();
        final phone = v.phoneNumber.toLowerCase();
        final services = v.services.join(" ").toLowerCase();

        return name.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase()) ||
            phone.contains(query.toLowerCase()) ||
            services.contains(query.toLowerCase());
      }),
    );
  }
}


  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        imageBytes.value = await pickedFile.readAsBytes();
        imageFile.value = null;
        print("[WEB] Picked image bytes length: ${imageBytes.value?.length}");
      } else {
        imageFile.value = File(pickedFile.path);
        imageBytes.value = null;
        print("[MOBILE] Picked image path: ${imageFile.value?.path}");
      }
    }
  }

  Future<void> pickSocialIconImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        socialImageBytes.value = await pickedFile.readAsBytes();
        socialImageFile.value = null;
        print(
          "[WEB] Picked social icon bytes length: ${socialImageBytes.value?.length}",
        );
      } else {
        socialImageFile.value = File(pickedFile.path);
        socialImageBytes.value = null;
        print(
          "[MOBILE] Picked social icon path: ${socialImageFile.value?.path}",
        );
      }
    }
  }

  void addSocialLink() {
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

    urlLinks.add({
      "name": socialNameCtrl.text.trim(),
      "url": socialUrlCtrl.text.trim(),
      "file": kIsWeb ? socialImageBytes.value : socialImageFile.value,
    });

    socialNameCtrl.clear();
    socialUrlCtrl.clear();
    socialImageFile.value = null;
    socialImageBytes.value = null;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isSubmitting.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print("[Token Error] Token is missing.");
        Get.snackbar(
          "Error",
          "Login token not found",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final uri = Uri.parse('$baseUrl/vendors/create');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      final fields = {
        "firstname": firstNameCtrl.text.trim(),
        "lastname": lastNameCtrl.text.trim(),
        "username": usernameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "paymentlink": paymentlinkCtrl.text.trim(),
        "phone_number": phoneCtrl.text.trim(),
        "code": codeCtrl.text.trim(),
        "country": countryCtrl.text.trim(),
        "description": descriptionCtrl.text.trim(),
        "services": jsonEncode(serviceController.selectedServiceNames),
        'password' : passwordCtrl.text.trim(),
      };

      print("[DEBUG] Fields to be sent:");
      fields.forEach((k, v) => print("  $k: $v"));
      request.fields.addAll(fields);
      List<Map<String, dynamic>> socialLinks =
          urlLinks.map((item) {
            return {"name": item["name"], "url": item["url"]};
          }).toList();

      request.fields["url"] = jsonEncode(socialLinks);
      print("[DEBUG] URL field: ${request.fields["url"]}");
      if (kIsWeb && imageBytes.value != null) {
        print("[DEBUG] Attaching main image from bytes (web)...");
        final multipartFile = http.MultipartFile.fromBytes(
          'image',
          imageBytes.value!,
          filename: 'vendor_image_web.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      } else if (!kIsWeb && imageFile.value != null) {
        print("[DEBUG] Attaching main image from file (mobile)...");
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.value!.path),
        );
      } else {
        print("[DEBUG] No main image selected.");
      }

      for (int i = 0; i < urlLinks.length; i++) {
        var fileOrBytes = urlLinks[i]["file"];
        if (fileOrBytes != null) {
          if (kIsWeb && fileOrBytes is Uint8List) {
            print("[DEBUG] Attaching social icon $i from bytes (web)");
            final multipartFile = http.MultipartFile.fromBytes(
              'social_images',
              fileOrBytes,
              filename: "social_$i.png",
              contentType: MediaType('image', 'png'),
            );
            request.files.add(multipartFile);
          } else if (!kIsWeb && fileOrBytes is File) {
            print("[DEBUG] Attaching social icon $i from file (mobile)");
            request.files.add(
              await http.MultipartFile.fromPath(
                'social_images',
                fileOrBytes.path,
                filename: "social_$i.png",
              ),
            );
          } else {
            print("[DEBUG] Social icon $i is missing or invalid.");
          }
        }
      }

      print("[DEBUG] Sending request...");
      final response = await request.send();

      final responseBody = await response.stream.bytesToString();
      print("[DEBUG] Response status: ${response.statusCode}");
      print("[DEBUG] Response body: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(responseBody);
        if (decoded["success"] == true) {
            String newVendorId = decoded['data']['createdBy'];
            print("New Vendor ID: $newVendorId");
prefs.setString('vendorId', newVendorId);
          Get.snackbar(
            "Success",
            decoded["message"] ?? "Vendor created",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          await Future.delayed(const Duration(seconds: 2));
          Get.back();
          clearForm();
        } else {
          Get.snackbar(
            "Error",
            decoded["message"] ?? "Something went wrong",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed. Status: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      print("[Exception] $e");
      print("[StackTrace] $stack");
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
    socialNameCtrl.clear();
    socialUrlCtrl.clear();
    socialImageFile.value = null;
    socialImageBytes.value = null;
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
      '$baseUrl/vendors/getmyvendors?service=$service&country=$country',
    );
    print("url: $url");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["success"] == true) {
        final List data = jsonData["data"];
        vendors.value =
            data.map((item) => VendorModel.fromJson(item)).toList();

        // ✅ STEP 2 - add this:
        allVendors = vendors.toList();

        print("vendors: $vendors");
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

      var url = Uri.parse('$baseUrl/reviews/create');

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
        getReviews(vendorId);
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

      final url = Uri.parse('$baseUrl/reviews/$vendorId');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List data = jsonResponse["data"];

        List<ReviewModel> reviews =
            data.map((item) => ReviewModel.fromJson(item)).toList();

        reviewList.value = reviews;
        print("Fetched ${reviews.length} reviews");
      } else {
        print("Failed to fetch reviews. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while fetching reviews: $e");
    }
  }

  Future<void> fetchAllVendors() async {
    try {
      isLoadingVendors.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = Uri.parse('$baseUrl/vendors/getallvendors');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData["success"] == true) {
          final List data = jsonData["data"];
          vendors.value =
              data.map((item) => VendorModel.fromJson(item)).toList();

          print("Fetched all ${vendors.length} vendors.");
        } else {
          Get.snackbar(
            "Error",
            jsonData["message"] ?? "Something went wrong",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          print("Failed to fetch vendors: ${jsonData["message"]}");
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch vendors. Status: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print("Failed to fetch vendors. Status: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Exception in fetchAllVendors: $e");
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

  Future<void> updateVendor(String vendorId) async {
    isSubmitting.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          "Error",
          "Login token not found",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final uri = Uri.parse('$baseUrl/vendors/update/$vendorId');
      final request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';

      final fields = {
        "firstname": firstNameCtrl.text.trim(),
        "lastname": lastNameCtrl.text.trim(),
        "username": usernameCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "phone_number": phoneCtrl.text.trim(),
        "code": codeCtrl.text.trim(),
        "country": countryCtrl.text.trim(),
        "description": descriptionCtrl.text.trim(),
        "services": jsonEncode(serviceController.selectedServiceNames),
      };

      request.fields.addAll(fields);

      // Prepare social links
      List<Map<String, dynamic>> socialLinks =
          urlLinks.map((item) {
            return {
              "name": item["name"],
              "url": item["url"],
              "_id": item["_id"], // keep existing _id for updates
            };
          }).toList();

      request.fields["url"] = jsonEncode(socialLinks);

      // Add main image
      if (kIsWeb && imageBytes.value != null) {
        final multipartFile = http.MultipartFile.fromBytes(
          'image',
          imageBytes.value!,
          filename: 'vendor_image_web.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      } else if (!kIsWeb && imageFile.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.value!.path),
        );
      }

      // Add social icons
      for (int i = 0; i < urlLinks.length; i++) {
        var fileOrBytes = urlLinks[i]["file"];
        if (fileOrBytes != null) {
          if (kIsWeb && fileOrBytes is Uint8List) {
            final multipartFile = http.MultipartFile.fromBytes(
              'social_images',
              fileOrBytes,
              filename: "social_$i.png",
              contentType: MediaType('image', 'png'),
            );
            request.files.add(multipartFile);
          } else if (!kIsWeb && fileOrBytes is File) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'social_images',
                fileOrBytes.path,
                filename: "social_$i.png",
              ),
            );
          }
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("[DEBUG] Update Response status: ${response.statusCode}");
      print("[DEBUG] Update Response body: $responseBody");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        if (decoded["success"] == true) {
          Get.snackbar(
            "Success",
            decoded["message"] ?? "Vendor updated",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          await Future.delayed(const Duration(seconds: 2));
          Get.back();
          clearForm();
        } else {
          Get.snackbar(
            "Error",
            decoded["message"] ?? "Something went wrong",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed. Status: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      print("[Exception] $e");
      print("[StackTrace] $stack");
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  var userPortfolios = [].obs;
  var loadingPortfolios = false.obs;

  Future<void> fetchUserPortfolios() async {
  try {
    loadingPortfolios.value = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/portfolios/getallportfolios');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData["success"] == true) {
        List portfoliosRaw = jsonData["data"];

        userPortfolios.value = portfoliosRaw.map((item) {
          return {
            "title": item["title"] ?? "",
            "id": item["_id"] ?? "",
            "image": (item["images"] != null && item["images"].isNotEmpty)
                ? item["images"][0]
                : "",
          };
        }).toList();

        print("🔎 Fetched ${userPortfolios.length} portfolios:");
        userPortfolios.forEach((p) {
          print("🆔 ID: ${p["id"]}");
          print("📛 Title: ${p["title"]}");
          print("🖼️ Image: ${p["image"]}");
          print("----------------------");
        });
      } else {
        Get.snackbar(
          "Error",
          jsonData["message"] ?? "Failed to fetch portfolios",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Failed to fetch portfolios. Status: ${response.statusCode}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print("❌ Exception while fetching portfolios: $e");
    Get.snackbar(
      "Error",
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    loadingPortfolios.value = false;
  }
}


  Future<void> linkPortfolioToVendor(
      {
      required String portfolioId,
      required String vendorId,
    }
  ) async {
    try {
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

      final url = Uri.parse('$baseUrl/vendors/linkportfolio');
      var body = jsonEncode({
        "portfolioId": portfolioId,
        "vendorId": vendorId,
      });

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["success"] == true) {
          // ✅ Update the vendor's linkedPortfolios in local vendors list
          int index = vendors.indexWhere((v) => v.id == vendorId);
          if (index != -1) {
            vendors[index] = vendors[index].copyWith(
              linkedPortfolios:
                  (jsonData["data"] as List)
                      .map((e) => PortfolioModel.fromJson(e))
                      .toList(),
            );
            vendors.refresh();
          }

          Get.snackbar(
            "Success",
            "Portfolio linked successfully!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Error",
            jsonData["message"] ?? "Link failed",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Link failed: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  var linkedPortfolios = <PortfolioModel>[].obs;
  var loadingLinkedPortfolios = false.obs;
  Future<void> fetchLinkedPortfolios(String vendorId) async {
    try {
      loadingLinkedPortfolios.value = true;

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

      final url = Uri.parse('$baseUrl/vendors/getlinkedportfolios/$vendorId');
      print("📌 Vendor ID: $vendorId");
      print("🌐 URL: $url");

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      print("🔁 Response Status Code: ${response.statusCode}");
      print("📦 Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["success"] == true && jsonData["data"] is List) {
          final List portfoliosRaw = jsonData["data"];

          linkedPortfolios.value =
              portfoliosRaw
                  .map<PortfolioModel>((item) => PortfolioModel.fromJson(item))
                  .toList();

          print("✅ Linked Portfolios Fetched: ${linkedPortfolios.length}");
          for (var p in linkedPortfolios) {
            print("• ID: ${p.id}");
            print("• Title: ${p.title}");
          }
        } else {
          print("❌ API responded with success=false or invalid data structure");
          Get.snackbar(
            "Error",
            jsonData["message"] ?? "Invalid response format",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print("❌ HTTP Status Error: ${response.statusCode}");
        print("❌ Response Body: ${response.body}");
        Get.snackbar(
          "Error",
          "Failed to fetch linked portfolios. Status: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, s) {
      print("🔥 Exception in fetchLinkedPortfolios: $e");
      print("📌 Stacktrace: $s");
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      loadingLinkedPortfolios.value = false;
    }
  }
}
