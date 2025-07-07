import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/models/portfolio_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PortfolioController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var portfolioloading = false.obs;

  // For Mobile: store File list
  var imageFiles = <io.File>[].obs;
var addPortfolioLoading = false.obs;
  var portfolioList = <PortfolioModel>[].obs;

  // For Web: store bytes list
  var imageBytesList = <Uint8List>[].obs;
  var imageNames = <String>[].obs;

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  var selectedServiceNames = <String>[].obs;
  var serviceNames = <String>[].obs;


  @override
  void onInit() {
    super.onInit();
            fetchServiceNames();

    getPortfolios();

  }
Future<void> fetchServiceNames() async {
    try {
      var url = Uri.parse('http://localhost:5000/api/services/getservices');
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

        selectedServiceNames.value =
            names.length >= 2 ? names.sublist(0, 2) : names;

        print("Fetched service names: $serviceNames");
        print("Initially selected services: $selectedServiceNames");
      } else {
        print("Failed to load service names. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching service names: $e");
    }
  }


  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      if (kIsWeb) {
        for (var image in pickedImages) {
          Uint8List bytes = await image.readAsBytes();
          imageBytesList.add(bytes);
          imageNames.add(image.name);
        }
      } else {
        imageFiles.addAll(pickedImages.map((e) => io.File(e.path)));
      }
    }
  }

  void removeImage(int index) {
    if (kIsWeb) {
      imageBytesList.removeAt(index);
      imageNames.removeAt(index);
    } else {
      imageFiles.removeAt(index);
    }
  }
Future<void> addPortfolio() async {
  addPortfolioLoading.value = true;
  if (!formKey.currentState!.validate()) return;

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    portfolioloading.value = true;

    var uri = Uri.parse("http://localhost:5000/api/portfolios/createportfolio");

    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = "Bearer ${token!}";

    request.fields['title'] = titleCtrl.text;
    request.fields['description'] = descCtrl.text;

    // ✅ send services list
    request.fields['services'] = jsonEncode(selectedServiceNames);

    if (kIsWeb) {
      for (int i = 0; i < imageBytesList.length; i++) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'images',
            imageBytesList[i],
            filename: imageNames[i],
          ),
        );
      }
    } else {
      for (var file in imageFiles) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images',
            file.path,
          ),
        );
      }
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      var portfolio = PortfolioModel.fromJson(jsonResponse['data']);

      Get.back();
      Get.snackbar("Success", "Portfolio created!");
      getPortfolios();
      print(portfolio.images);
    } else {
      Get.snackbar("Error", "Failed to create portfolio");
    }
  } catch (e) {
    print("Error: $e");
    Get.snackbar("Error", e.toString());
  } finally {
    addPortfolioLoading.value = false;
  }
}

  Future<void> getPortfolios() async {
  try {
    portfolioloading.value = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('token');
    if (authToken == null || authToken.isEmpty) {
      Get.snackbar("Error", "Token not found. Please login again.");
      return;
    }

    var url = Uri.parse("http://localhost:5000/api/portfolios/getportfolios");

    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $authToken",
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<dynamic> list = jsonResponse['data'];
print("Sending services: ${jsonEncode(selectedServiceNames)}");

      List<PortfolioModel> portfolios =
          list.map((item) => PortfolioModel.fromJson(item)).toList();

      portfolioList.value = portfolios;
      print("Fetched portfolios: ${portfolioList.length}");
    } else {
      Get.snackbar("Error", "Failed to fetch portfolios");
    }
  } catch (e) {
    print("Error: $e");
    Get.snackbar("Error", e.toString());
  } finally {
    portfolioloading.value = false;
  }
}




}
