import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/controllers/services_controller.dart';
import '../models/ad_model.dart';

class adminaddscreen extends StatelessWidget {
  final TextEditingController imageUrlController = TextEditingController();
  final ServicesController serviceController = Get.put(ServicesController());

  adminaddscreen({super.key}) {
    serviceController.fetchAds(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ads Management")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(
                      labelText: "search ads",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                  showCreateAdDialog(context  );
                  },
                  child: const Text("Create Ad"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "All Ads:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                final ads = serviceController.adsList;
                if (ads.isEmpty) {
                  return const Center(child: Text("No ads available."));
                }
                return ListView.builder(
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    AdModel ad = ads[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(ad.imageUrl, width: 50, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
                        title: Text(ad.uploadedByUsername),
                        subtitle: Text("Email: ${ad.uploadedByEmail}"),
                        trailing: Text(ad.createdAt.toLocal().toString().split(".")[0]),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }void showCreateAdDialog(BuildContext context) {
  final ServicesController controller = Get.find();
  XFile? pickedImage;

  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text("Create Ad"),
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
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: pickedImage == null
                        ? const Center(child: Text("Tap to select image"))
                        : kIsWeb
                            ? FutureBuilder<Uint8List>(
                                future: pickedImage!.readAsBytes(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return const Center(child: Text("Failed to load image"));
                                  } else {
                                    return Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              )
                            : Image.file(
                                File(pickedImage!.path),
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            Obx(() => ElevatedButton(
                  onPressed: controller.createadloading.value
                      ? null
                      : () async {
                          if (pickedImage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select an image")),
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
                  child: controller.createadloading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Create"),
                )),
          ],
        );
      });
    },
  );
}



}