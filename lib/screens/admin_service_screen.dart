import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/controllers/services_controller.dart';
import 'package:joya_app/utils/colors.dart';

class AdminServiceScreen extends StatelessWidget {
  final ServicesController controller = Get.put(ServicesController());
  final TextEditingController searchController = TextEditingController();
  AdminServiceScreen({super.key}) {
    controller.fetchServices();
  }
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
                    "Services".tr,
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
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40.h,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search".tr,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14.sp,
                          ),
                          prefixIcon: SvgPicture.asset(
                            "assets/Magnifer.svg",
                            height: 12.h,
                          ),
                          filled: true,
                          fillColor:
                              Colors
                                  .transparent, // or backgroungcolor if needed
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300, // light gray border
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  InkWell(
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

                  // ElevatedButton.icon(
                  //   onPressed: () => _showCreateServiceDialog(context),
                  //   icon: Icon(Icons.add, size: 20, color: Colors.white),
                  //   label: Text(
                  //     "Create",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 12.sp,
                  //     ),
                  //   ),
                  //   style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 12,
                  //       vertical: 8,
                  //     ),
                  //     backgroundColor: primaryColor,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(16),
                  //     ),
                  //     elevation: 4,
                  //   ),
                  // )
                ],
              ),
            ),

            const SizedBox(height: 12),

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
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        // color: Color(0xffE8E3FF),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade400),
                       
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  s.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder:
                                      (_, __, ___) => Container(
                                        color: Colors.grey.shade200,
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    s.title,
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
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
          controller.deleteService(s.id);
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
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 12.h),
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
                "Create Service".tr,
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
                        labelText: "Service Title".tr,
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
                        final result = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
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
                                      "Tap to select image".tr,
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
