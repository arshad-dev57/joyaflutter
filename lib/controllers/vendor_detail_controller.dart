// // vendor_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:joya_app/screens/all_vendors_screen.dart';

// class VendorController extends GetxController {
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final emailController = TextEditingController();
//   final countryController = TextEditingController();

//   void fillUserData(UserModel user) {
//     nameController.text = user.name;
//     phoneController.text = user.phone;
//     emailController.text = user.email;
//     countryController.text = user.country;
//   }

//   void clearForm() {
//     nameController.clear();
//     phoneController.clear();
//     emailController.clear();
//     countryController.clear();
//   }

//   void saveChanges() {
//     // TODO: implement update to Firestore or backend
//     Get.back(); // Close the dialog
//   }

//   @override
//   void onClose() {
//     nameController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//     countryController.dispose();
//     super.onClose();
//   }

//    var userName = 'Adeel Vendor'.obs;
//   var email = 'adeelvednor@gmail.com'.obs;
//   var phone = '12312312312'.obs;
//   var password = '1111'.obs;
//   var country = 'Kuwait'.obs;
//   var selectedLanguage = 'English'.obs;
//   var role = 'Vendor'.obs;
//   var selectedCategories = ['Photography', 'Event Planning'].obs;
//   var imageUrl = 'https://via.placeholder.com/150'.obs;
//   var firstName = 'Adeel'.obs;
//   var lastName = 'Vednor'.obs;

//   List<String> countries = ['Kuwait', 'Saudi Arabia', 'UAE'];
//   List<String> roles = ['Admin', 'Vendor', 'User'];
//   List<String> allCategories = ['Photography', 'Event Planning', 'Catering', 'Decor'];

//   void toggleCategory(String category) {
//     if (selectedCategories.contains(category)) {
//       selectedCategories.remove(category);
//     } else {
//       selectedCategories.add(category);
//     }
//   }
// }
