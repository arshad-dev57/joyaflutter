import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/userprofile_controller.dart';
import 'package:shimmer/shimmer.dart';

class UserProfileScreen extends StatelessWidget {
  // Dummy data (replace with real user data)

   UserProfileScreen({super.key});
final UserProfileController controller = Get.put(UserProfileController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "profile_title".tr,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
     body: Obx(() {
  if (controller.isLoading.value) {
    return _buildShimmerProfile();
  }

  final profile = controller.userProfile.value;

  if (profile == null) {
    return Center(
      child: Text("No profile data"),
    );
  }

  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60.r,
                backgroundImage: AssetImage("assets/user.jpg"),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "profile_personal_info".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _buildInfoTile(Icons.person, "profile_name".tr, profile.name),
                _buildInfoTile(Icons.email, "profile_email".tr, profile.email),
                _buildInfoTile(Icons.phone, "profile_phone".tr, profile.phone ?? "N/A"),
                _buildInfoTile(Icons.roller_shades, "profile_role".tr, profile.role),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.5.w,
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () {
                controller.logoutUser();
                print("Logout tapped");
              },
              child: Text(
                "profile_logout".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}),

    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Icon(
          icon,
          color: Colors.black,
          size: 24.sp,
        ),
        title: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        subtitle: Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.sp,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: Colors.grey,
        ),
        onTap: () {
          print("Tapped $label");
        },
      ),
    );
  }

Widget _buildShimmerProfile() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
    child: Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: CircleAvatar(
            radius: 60.r,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
        SizedBox(height: 24.h),
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ],
    ),
  );
}

}
