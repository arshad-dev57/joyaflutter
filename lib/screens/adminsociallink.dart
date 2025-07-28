import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/controllers/paymentlinkcontroller.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:get/get.dart';

class AdminPaymentLinksScreen extends StatefulWidget {
  const AdminPaymentLinksScreen({super.key});

  @override
  State<AdminPaymentLinksScreen> createState() =>
      _AdminPaymentLinksScreenState();
}

class _AdminPaymentLinksScreenState extends State<AdminPaymentLinksScreen> {
  final List<Map<String, dynamic>> paymentLinks = [];
  final PaymentLinkController controller = Get.put(PaymentLinkController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroungcolor,

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset("assets/Arrow.svg", height: 32.h),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "Socail Links".tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    _showCreateServiceDialog(context);
                  },
                  child: Container(
                    height: 40.h,
                    width: 70.w,
                
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Create".tr,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12.sp,
                          ),
                        ),
                        Icon(Icons.add, size: 12.sp, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Obx(() {
              if (controller.paymentLinks.isEmpty) {
                return Center(child: Text("No Social links yet."));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.paymentLinks.length,
                  itemBuilder: (context, index) {
                    final link = controller.paymentLinks[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          color: backgroungcolor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                link.imageUrl,
                                height: 26,
                                width: 26,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Icon(Icons.link, size: 24),
                              ),
                            ),
                            SizedBox(width: 12),
                              
                        Container(
    height: 32,
    width: 32,
    decoration: BoxDecoration(
      color: primaryColor.withOpacity(0.2),
      shape: BoxShape.circle,
    ),
    child: PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: primaryColor, size: 18),
      color: Colors.red.shade50,
      offset: Offset(0, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 1,
          padding: EdgeInsets.zero,
          height: 26, 

          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, color: Colors.red, size: 16),
                SizedBox(width: 6),
                Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          controller.deletePaymentLink(link.id);
        }
      },
      constraints: BoxConstraints(
        minWidth: 50.w,
        maxWidth: 70.w,
      ),
    ),
  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Create Social Link".tr,
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
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Social Link".tr,
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
                        final result = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
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
                        child:
                            pickedImage == null
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: primaryColor,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Tap to select icon".tr,
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
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text("Error loading image".tr),
                                      );
                                    } else {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
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
                  child: Text("Cancel".tr, style: TextStyle(color: primaryColor)),
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.createServiceLoading.value
                            ? null
                            : () async {
                              if (titleController.text.isEmpty ||
                                  pickedImage == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Fill title & pick an image".tr,
                                    ),
                                  ),
                                );
                                return;
                              }

                              final bytes = await pickedImage!.readAsBytes();

                              await controller.createpayment(
                                title: titleController.text,
                                webImageBytes: kIsWeb ? bytes : null,
                                mobileImageFile:
                                    !kIsWeb ? File(pickedImage!.path) : null,
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
                        horizontal: 20,
                        vertical: 14,
                      ),
                      elevation: 4,
                    ),
                    child:
                        controller.createServiceLoading.value
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              "Create".tr,
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
