import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:joya_app/models/payment_model.dart';
import 'package:joya_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentLinkController extends GetxController {
  var createServiceLoading = false.obs;
var paymentLinks = <PaymentLinkModel>[].obs;

@override
onInit() {
  fetchPaymentLinks();
  super.onInit();
}
  var isLoading = false.obs;


 Future<void> createpayment({
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
        Uri.parse('$baseUrl/payment/create'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['link'] = title;

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

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Service created successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
            fetchPaymentLinks();
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
Future<void> fetchPaymentLinks() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/payment/getpaymentlinks'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> linkList = data['data'];

      paymentLinks.value = linkList
          .map((item) => PaymentLinkModel.fromJson(item))
          .toList();
          print(  " paymentLinks $paymentLinks");
    } else {
      Get.snackbar("Error", "Failed to fetch payment links",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  } catch (e) {
    print("Error fetching payment links: $e");
    print(  " error $e");
    Get.snackbar("Error", e.toString(),
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}

 Future<void> deletePaymentLink(String id) async {
    try {
      isLoading.value = true;

      final response = await http.delete(
        Uri.parse('$baseUrl/payment/delete/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Deleted successfully");
        final json = jsonDecode(response.body);
        Get.snackbar("Success", json['message'] ?? "Deleted successfully");
        fetchPaymentLinks();
      } else {
        print("Failed to delete");
        final json = jsonDecode(response.body);
        Get.snackbar("Error", json['message'] ?? "Failed to delete");
      }
    } catch (e) {
      print("Error deleting payment link: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
