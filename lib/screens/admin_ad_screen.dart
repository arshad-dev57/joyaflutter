import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/controllers/services_controller.dart';
import 'package:joya_app/utils/colors.dart';
import '../models/ad_model.dart';

class adminaddscreen extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final ServicesController serviceController = Get.put(ServicesController());

  adminaddscreen({super.key}) {
    serviceController.fetchAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Ads Management",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            /// Search & Create Ad button
            Row(
              children: [
                Expanded(
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(12),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search ads...",
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: Icon(Icons.add, size: 20),
                  label: Text("Create Ad"),
                  onPressed: () {
                    showCreateAdDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "All Ads:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
            ),
            SizedBox(height: 16),

            /// Ads List
            Expanded(
              child: Obx(() {
                final ads = serviceController.adsList;

                if (ads.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported, size: 60, color: Colors.grey.shade400),
                        SizedBox(height: 12),
                        Text(
                          "No ads available.",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    final ad = ads[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                ad.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey.shade200,
                                  child: Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ad.uploadedByUsername,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    ad.id,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                              onPressed: () {
                                serviceController.deleteAd(ad.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void showCreateAdDialog(BuildContext context) {
    final ServicesController controller = Get.find();
    XFile? pickedImage;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                "Create Ad",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final result = await picker.pickImage(source: ImageSource.gallery);
                        if (result != null) {
                          setState(() {
                            pickedImage = result;
                          });
                        }
                      },
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(color: primaryColor.withOpacity(0.4), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: pickedImage == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload, size: 40, color: primaryColor),
                                    SizedBox(height: 10),
                                    Text(
                                      "Tap to select image",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : kIsWeb
                                ? FutureBuilder<Uint8List>(
                                    future: pickedImage!.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text("Failed to load image"));
                                      } else {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                                        );
                                      }
                                    },
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(pickedImage!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.createadloading.value
                        ? null
                        : () async {
                            if (pickedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Please select an image")),
                              );
                              return;
                            }

                            final bytes = await pickedImage!.readAsBytes();

                            await controller.createAd(
                              webImageBytes: kIsWeb ? bytes : null,
                              mobileImageFile: !kIsWeb ? File(pickedImage!.path) : null,
                            );

                            if (!controller.createadloading.value) {
                              Navigator.pop(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: controller.createadloading.value
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            "Create",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
