import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/controllers/services_controller.dart';
import 'package:joya_app/utils/colors.dart';

class AdminServiceScreen extends StatelessWidget {
  final ServicesController controller = Get.put(ServicesController());

  AdminServiceScreen({super.key}) {
    controller.fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          "Service Management",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Title and Create Button
            Row(
              children: [
                Expanded(
                  child: Text(
                    "All Wedding Services",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCreateServiceDialog(context),
                  icon: Icon(Icons.add, size: 20, color: Colors.white),
                  label: Text(
                    "Create",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                )
              ],
            ),

            const SizedBox(height: 24),

            Expanded(
              child: Obx(() {
                final services = controller.servicesList;

                if (services.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.miscellaneous_services_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "No services found.",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: services.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final s = services[index];

                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            s.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade100,
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        title: Text(
                          s.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade300,
                          ),
                          onPressed: () {
                            controller.deleteService(s.id);
                          },
                        ),
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
  }

  void _showCreateServiceDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final ServicesController controller = Get.find();
    XFile? pickedImage;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Create Service",
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
                    /// Title field
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Service Title",
                        labelStyle: TextStyle(color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    SizedBox(height: 16),

                    /// Image Picker
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final result =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (result != null) {
                          setState(() => pickedImage = result);
                        }
                      },
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withOpacity(0.6),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: pickedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo,
                                      size: 40, color: primaryColor),
                                  SizedBox(height: 8),
                                  Text(
                                    "Tap to select image",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : kIsWeb
                                ? FutureBuilder<Uint8List>(
                                    future: pickedImage!.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child:
                                                CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text("Error loading image"));
                                      } else {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.memory(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                          ),
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
                    onPressed: controller.createServiceLoading.value
                        ? null
                        : () async {
                            if (titleController.text.isEmpty ||
                                pickedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("Fill title & pick an image."),
                                ),
                              );
                              return;
                            }

                            final bytes = await pickedImage!.readAsBytes();

                            await controller.createService(
                              title: titleController.text,
                              webImageBytes: kIsWeb ? bytes : null,
                              mobileImageFile: !kIsWeb
                                  ? File(pickedImage!.path)
                                  : null,
                            );

                            if (!controller.createServiceLoading.value) {
                              Navigator.pop(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      elevation: 4,
                    ),
                    child: controller.createServiceLoading.value
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
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
