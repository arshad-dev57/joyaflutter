import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:joya_app/models/ad_model.dart';
import 'package:joya_app/models/servides_model.dart';
import 'package:joya_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicesController extends GetxController {
  var isLoading = false.obs;
  var isLoadingAds = false.obs;

  var servicesList = <ServiceModel>[].obs;
  var adsList = <AdModel>[].obs;
  var createadloading = false.obs;

  /// 🟡 New Single-Select variables
  var serviceNames = <String>[].obs;
  var selectedServiceNames = <String>[].obs;
  var selectedServiceName = ''.obs;

  @override
  void onInit() {
    fetchServices();
    fetchServiceNames();
    fetchAds();
    super.onInit();
  }

  var createServiceLoading = false.obs;

  Future<void> createService({
    required String title,
    required Uint8List? webImageBytes,
    required File? mobileImageFile,
  }) async {
    createServiceLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/services/createservice'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['title'] = title;

      if (kIsWeb && webImageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'imageUrl',
            webImageBytes,
            filename: 'web_image.jpg',
          ),
        );
      } else if (mobileImageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'imageUrl',
            mobileImageFile.path,
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        await fetchServices();
        Get.snackbar("Success", "Service created successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to create service",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      createServiceLoading.value = false;
    }
  }

  Future<void> fetchAds() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var url = Uri.parse('$baseUrl/ad/getads');

      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<AdModel> loadedAds = [];

        for (var item in jsonData['data']) {
          loadedAds.add(AdModel.fromJson(item));
        }
        adsList.value = loadedAds;
        print("Fetched ads: ${adsList.length}");
      } else {
        print("Failed to load ads. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching ads: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchServiceNames() async {
    try {
      var url = Uri.parse('$baseUrl/services/getservices');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<String> names = [];

        for (var item in jsonData['data']) {
          if (item['title'] != null) {
            names.add(item['title'].toString());
          }
        }

        serviceNames.value = names;

        /// Set single selected name
        if (names.isNotEmpty) {
          selectedServiceName.value = names.first;
        } else {
          selectedServiceName.value = "";
        }

        /// Multi-select default
        selectedServiceNames.value =
            names.length >= 2 ? names.sublist(0, 2) : names;

        print("Fetched service names: $serviceNames");
        print("Initially selected services (multi): $selectedServiceNames");
        print("Initially selected service (single): $selectedServiceName");
      } else {
        print("Failed to load service names. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching service names: $e");
    }
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    try {
      var url = Uri.parse('$baseUrl/services/getservices');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        List<ServiceModel> loadedServices = [];

        for (var item in jsonData['data']) {
          loadedServices.add(ServiceModel.fromJson(item));
        }

        servicesList.value = loadedServices;

        print("Fetched services: ${servicesList.length}");
      } else {
        print("Failed to load services. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching services: $e");
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> createAd({
    required Uint8List? webImageBytes,
    required File? mobileImageFile,
  }) async {
    try {
      createadloading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar("Auth Error", "User token not found");
        return;
      }

      final uri = Uri.parse("$baseUrl/ad/createads");
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      if (kIsWeb && webImageBytes != null) {
        final multipartFile = http.MultipartFile.fromBytes(
          'image',
          webImageBytes,
          filename: 'ad_image_web.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      } else if (!kIsWeb && mobileImageFile != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'image',
          mobileImageFile.path,
        );
        request.files.add(multipartFile);
      } else {
        Get.snackbar("Error", "No image selected");
        return;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        print("✅ Ad created");
        fetchAds();
      } else {
        print("❌ Failed to create ad: ${response.body}");
      }
    } catch (e) {
      print("❌ Error creating ad: $e");
    } finally {
      createadloading.value = false;
    }
  }

  Future<void> deleteAd(String adId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar("Auth Error", "User token not found");
        return;
      }

      final uri = Uri.parse("$baseUrl/ad/delete/$adId");
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("✅ Ad deleted");
        fetchAds();
      } else {
        print("❌ Failed to delete ad: ${response.body}");
      }
    } catch (e) {
      print("❌ Error deleting ad: $e");
    }
  }
  Future<void>deleteService(String serviceId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar("Auth Error", "User token not found");
        return;
      }

      final uri = Uri.parse("$baseUrl/services/deleteservice/$serviceId");
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("✅ Service deleted");
        fetchServices();
      } else {
        print("❌ Failed to delete service: ${response.body}");
      }
    } catch (e) {
      print("❌ Error deleting service: $e");
    }
  }
}
