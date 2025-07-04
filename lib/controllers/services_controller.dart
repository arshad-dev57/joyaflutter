import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:joya_app/models/ad_model.dart';
import 'package:joya_app/models/servides_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicesController extends GetxController {
  var isLoading = false.obs;
  var servicesList = <ServiceModel>[].obs;
  var isLoadingAds = false.obs;
  var adsList = <AdModel>[].obs;

  var serviceNames = <String>[].obs;
  var selectedServiceNames = <String>[].obs;   // ✅ NEW

  @override
  void onInit() {
    fetchServices();
    fetchServiceNames();
    fetchAds();
    super.onInit();
  }

  Future<void> fetchAds() async {
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var url = Uri.parse('http://localhost:5000/api/ad/getads');

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

  /// ✅ Fetch service names + set default selected services
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

        // ✅ Example: automatically select first 2 services
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

  Future<void> fetchServices() async {
    isLoading.value = true;
    try {
      var url = Uri.parse('http://localhost:5000/api/services/getservices');
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
}
