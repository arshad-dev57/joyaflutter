import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' as io show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/portfolio_model.dart';

class PortfolioController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var portfolioloading = false.obs;
  var addPortfolioLoading = false.obs;
  var portfolioList = <PortfolioModel>[].obs;

  // Fields
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  // final serviceTypeCtrl = TextEditingController();
RxList<String> selectedServices = <String>[].obs;

  final highlightsCtrl = TextEditingController();
  final challengesCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final selfNoteCtrl = TextEditingController();
  final ratingsCtrl = TextEditingController();
  final videoLinkCtrl = TextEditingController();
  final clientTypeCtrl = TextEditingController();
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxBool isPracticeProject = false.obs;
  RxBool contactEnabled = true.obs;

  var skillsUsed = <String>[].obs;
  var equipmentUsed = <String>[].obs;

  // Image handling
  var imageFiles = <io.File>[].obs;
  var imageBytesList = <Uint8List>[].obs;
  var imageNames = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getPortfolios();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
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
    if (!formKey.currentState!.validate()) return;

    addPortfolioLoading.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var uri = Uri.parse("http://localhost:5000/api/portfolios/createportfolio");
      var request = http.MultipartRequest("POST", uri);
      request.headers['Authorization'] = "Bearer ${token!}";

      request.fields['title'] = titleCtrl.text;
      request.fields['description'] = descCtrl.text;
request.fields['serviceType'] = jsonEncode(selectedServices);
      request.fields['skillsUsed'] = jsonEncode(skillsUsed);
      request.fields['highlights'] = highlightsCtrl.text;
      request.fields['challengesFaced'] = challengesCtrl.text;
      request.fields['location'] = locationCtrl.text;
      request.fields['duration'] = durationCtrl.text;
      request.fields['selfNote'] = selfNoteCtrl.text;
      request.fields['ratings'] = ratingsCtrl.text;
      request.fields['clientType'] = clientTypeCtrl.text;
      request.fields['equipmentUsed'] = jsonEncode(equipmentUsed);
      request.fields['videoLinks'] = jsonEncode([videoLinkCtrl.text]);
      request.fields['contactEnabled'] = contactEnabled.value.toString();
      request.fields['isPracticeProject'] = isPracticeProject.value.toString();
      if (selectedDate.value != null) {
        request.fields['date'] = selectedDate.value!.toIso8601String();
      }

      // Attach images
      if (kIsWeb) {
        for (int i = 0; i < imageBytesList.length; i++) {
          request.files.add(http.MultipartFile.fromBytes(
            'images',
            imageBytesList[i],
            filename: imageNames[i],
          ));
        }
      } else {
        for (var file in imageFiles) {
          request.files.add(await http.MultipartFile.fromPath('images', file.path));
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        Get.back();
        Get.snackbar("Success", "Portfolio created!");
        getPortfolios();
      } else {
        Get.snackbar("Error", "Failed to create portfolio");
        print(response.body);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      addPortfolioLoading.value = false;
    }
  }

  Future<void> getPortfolios() async {
    try {
      portfolioloading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse("http://localhost:5000/api/portfolios/getportfolios"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        portfolioList.value = (body['data'] as List)
            .map((e) => PortfolioModel.fromJson(e))
            .toList();
      } else {
        Get.snackbar("Error", "Failed to fetch portfolios");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      portfolioloading.value = false;
    }
  }
}
