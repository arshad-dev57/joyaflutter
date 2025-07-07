import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/controllers/services_controller.dart';

class AdminServiceScreen extends StatelessWidget {
  final ServicesController controller = Get.put(ServicesController());

  AdminServiceScreen({super.key}) {
    controller.fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Management")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "All Wedding Services",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _showCreateServiceDialog(context),
                  child: const Text("Create Service"),
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                final services = controller.servicesList;
                if (services.isEmpty) {
                  return const Center(child: Text("No services found."));
                }
                return ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final s = services[index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          s.imageUrl,
                          width: 60,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        title: Text(s.title),
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

  void _showCreateServiceDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final ServicesController controller = Get.find();
    XFile? pickedImage;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Create Service"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final result = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (result != null) {
                        setState(() => pickedImage = result);
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
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return const Center(
                                          child: Text("Error loading image"));
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
                    onPressed: controller.createServiceLoading.value
                        ? null
                        : () async {
                            if (titleController.text.isEmpty ||
                                pickedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Fill title & pick image")),
                              );
                              return;
                            }

                            final bytes = await pickedImage!.readAsBytes();

                            await controller.createService(
                              title: titleController.text,
                              webImageBytes: kIsWeb ? bytes : null,
                              mobileImageFile:
                                  !kIsWeb ? File(pickedImage!.path) : null,
                            );

                            if (!controller.createServiceLoading.value) {
                              Navigator.pop(context);
                            }
                          },
                    child: controller.createServiceLoading.value
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
