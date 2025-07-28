import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joya_app/controllers/user_controller.dart';
import 'package:joya_app/controllers/userprofile_controller.dart';
import 'package:joya_app/controllers/paymentlinkcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileController controller = Get.put(UserProfileController());
  final UsersController usersController = Get.put(UsersController());
    final PaymentLinkController paymentcontroller = Get.put(PaymentLinkController());

  XFile? pickedImage;

  String? userrole;
  String? userId;

  @override
  void initState() {
    super.initState();
    controller.fetchUserProfile();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('role');
    final userId = prefs.getString('userId');
    setState(() {
      userrole = name ?? 'Unknown';
      this.userId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroungcolor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) return _buildShimmer();

          final profile = controller.userProfile.value;
          if (profile == null) return Center(child: Text("No profile data"));

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child:  Column(
  children: [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Profile".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: Colors.black,
            ),
          ),
          // ElevatedButton(
          //   onPressed: controller.isLoading.value
          //       ? null
          //       : () async {
          //           if (pickedImage == null) {
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               SnackBar(content: Text("Please select an image")),
          //             );
          //             return;
          //           }
          //           final bytes = await pickedImage!.readAsBytes();
          //           await usersController.updateProfileImage(
          //             userId: userId!,
          //             webImageBytes: kIsWeb ? bytes : null,
          //             mobileImageFile: !kIsWeb ? File(pickedImage!.path) : null,
          //           );
          //         },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: primaryColor,
          //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //   ),
          //   child: usersController.updateLoading.value
          //       ? SizedBox(
          //           width: 20,
          //           height: 20,
          //           child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          //         )
          //       : Text(
          //           "Update",
          //           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          //         ),
          // ),
        ],
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: primaryColor.withOpacity(0.4), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Icon(Icons.person, size: 40, color: primaryColor),
                  ),
                ),
                // Positioned(
                //   bottom: 0,
                //   right: 0,
                //   child: GestureDetector(
                //     onTap: () async {
                //       final picker = ImagePicker();
                //       final result = await picker.pickImage(source: ImageSource.gallery);
                //       if (result != null) {
                //         setState(() {
                //           pickedImage = result;
                //         });
                //       }
                //     },
                //     child: CircleAvatar(
                //       radius: 12,
                //       backgroundColor: primaryColor,
                //       child: Icon(Icons.edit, color: Colors.white, size: 14),
                //     ),
                //   ),
                // )
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    profile.role,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.expand_more, color: Colors.white),
            ),
          ],
        ),
      ),
    ),
    SizedBox(height: 20.h),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Personal Information".tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
      ),
    ),
    SizedBox(height: 12.h),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Name:".tr, profile.name),
            _infoRow("Email:".tr, profile.email),
            _infoRow("Phone number:".tr, profile.phone ?? "+91 0000000000"),
            if (userrole == "user")
              _infoRow("Payment Status:".tr, profile.paymentstatus ?? ""),
          ],
        ),
      ),
    ),
   
    SizedBox(height: 12.h),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Align(alignment: Alignment.centerLeft, child: Text("About this app".tr, style: TextStyle( fontSize: 14.sp, color: Colors.black))),
    ),
    SizedBox(height: 12.h),
    Padding(
  padding: EdgeInsets.symmetric(horizontal: 12.w),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Container(
      height: 100.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Text(
            "Joya is a platform designed to connect users with event service providers such as venues, catering, photography, and more.".tr,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black.withOpacity(0.6),
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    ),
  ),
),
   Obx(() {
              if (paymentcontroller.paymentLinks.isEmpty) {
                return Center(child: Text("No Social links yet."));
              }
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 80.h,
                  width: 200.w,
                  child: ListView.builder(
                    itemCount: paymentcontroller.paymentLinks.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final link = paymentcontroller.paymentLinks[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                         
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () async {
  String url = link.link.trim();
  if (!url.startsWith("http")) {
    url = "https://" + url;
  }

  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    Get.snackbar("Error", "Could not launch $url");
  }
},
                                child: ClipRRect(
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
                              ),
                              SizedBox(width: 12),                          
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
    SizedBox(height: 12.h),
 Center(
      child: OutlinedButton.icon(
        onPressed: () {
          controller.logoutUser();
        },
        icon: Icon(Icons.logout, color: Colors.red, size: 16.sp),
        label: Text(
          "Logout",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red.shade200),
          backgroundColor: Colors.red.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        ),
      ),
    ),
    SizedBox(height: 12.h),
   
  ],
),
          );
        }),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 12.5.sp),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12.sp),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: CircleAvatar(radius: 40.r, backgroundColor: Colors.grey),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }
}
