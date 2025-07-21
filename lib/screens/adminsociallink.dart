import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/controllers/paymentlinkcontroller.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:get/get.dart';

class AdminPaymentLinksScreen extends StatefulWidget {
  const AdminPaymentLinksScreen({super.key});

  @override
  State<AdminPaymentLinksScreen> createState() => _AdminPaymentLinksScreenState();
}

class _AdminPaymentLinksScreenState extends State<AdminPaymentLinksScreen> {
  final List<Map<String, dynamic>> paymentLinks = [];
  final PaymentLinkController controller = Get.put(PaymentLinkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text("Social Links", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () => _showCreateServiceDialog(context),
            icon: Icon(Icons.add, color: Colors.white),
          )
        ],
      ),
      body: Padding(
  padding: EdgeInsets.all(16),
  child: Obx(() {
    if (controller.paymentLinks.isEmpty) {
      return Center(child: Text("No Social links yet."));
    }

    return ListView.builder(
      itemCount: controller.paymentLinks.length,
      itemBuilder: (context, index) {
        final link = controller.paymentLinks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(link.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: EdgeInsets.all(12),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    link.link, // ✅ not 'title'
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            ],
          ),
        );
      },
    );
  }),
)

    );
  }

  void _showCreateServiceDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    XFile? pickedImage;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.95),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                "Create Social Link",
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Social Link",
                        labelStyle: TextStyle(color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final result = await picker.pickImage(source: ImageSource.gallery);
                        if (result != null) {
                          setState(() => pickedImage = result);
                        }
                      },
                      child: Container(
                        height: 100,
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
                                  Icon(Icons.add_a_photo, size: 40, color: primaryColor),
                                  SizedBox(height: 8),
                                  Text(
                                    "Tap to select icon",
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
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text("Error loading image"));
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
                  child: Text("Cancel", style: TextStyle(color: primaryColor)),
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

                            await controller.createpayment(
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
