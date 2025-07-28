import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/controllers/services_controller.dart';
import 'package:joya_app/utils/colors.dart';

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
    
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),
                 Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  InkWell(onTap: () {
                    Get.back();
                  }, child: SvgPicture.asset("assets/Arrow.svg", height: 32.h)),
                  SizedBox(width: 12.w),
                  Text(
                    "Adds".tr,
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
    //               Expanded(
    //                 child: Container(
    //                   height: 40.h,
    //                   child: TextField(
    //                     controller: searchController,
    //                     decoration:InputDecoration(
    //   hintText: "Search",
    //   hintStyle: TextStyle(
    //     color: Colors.grey.shade400,
    //     fontSize: 14.sp,
    //   ),
    //   prefixIcon: SvgPicture.asset("assets/Magnifer.svg", height: 12.h),
    //   filled: true,
    //   fillColor: Colors.transparent, // or backgroungcolor if needed
    //   contentPadding: EdgeInsets.symmetric(vertical: 12.h),
    //   enabledBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(8.r),
    //     borderSide: BorderSide(
    //       color: Colors.grey.shade300, // light gray border
    //       width: 1,
    //     ),
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(12.r),
    //     borderSide: BorderSide(
    //       color: Colors.grey.shade400,
    //       width: 1,
    //     ),
    //   ),
    // ),
    //                   ),
    //                 ),
    //               ),
                  SizedBox(width: 6.w),
                  InkWell(
                    onTap: () {
                      showCreateAdDialog(context);
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
                      )
                    ),
                  ),
                ],
              ),
            ),
          
            SizedBox(height: 12.h),
                
        Expanded(
        child: Obx(() {
          final ads = serviceController.adsList;
                
          if (ads.isEmpty) {
                return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
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
        ),
                );
          }
                
          return ListView.builder(
                itemCount: ads.length,
                itemBuilder: (context, index) {
        final ad = ads[index];
                
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Background image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    ad.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  left: 16,
                  bottom: 12,
                  child: Text(
                    ad.uploadedByUsername,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.black45, blurRadius: 4),
                      ],
                    ),
                  ),
                ),
                
Positioned(
  top: 8,
  right: 8,
  child: Container(
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
          serviceController.deleteAd(ad.id);
        }
      },
      constraints: BoxConstraints(
        minWidth: 50.w,
        maxWidth: 70.w,
      ),
    ),
  ),
)



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
                "Create Ad".tr,
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
                                      "Tap to select image".tr,
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
                    "Cancel".tr,
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
