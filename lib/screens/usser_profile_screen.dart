import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/userprofile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileController controller = Get.put(UserProfileController());
String? userrole;
  @override
  void initState() {
    super.initState();
    controller.fetchUserProfile();
    userrolefunction();
  }
Future<void> userrolefunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('role');
    if (name != null && name.isNotEmpty) {
      setState(() {
        userrole = name;
      });
    } else {
      setState(() {
        userrole = 'Unknown';
      });
    }
  }
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
            fontSize: 18.sp,
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
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
            child: Column(
              children: [
                /// Avatar
                CircleAvatar(
                  radius: 50.r,
                  backgroundImage: AssetImage("assets/user.jpg"),
                ),

                SizedBox(height: 20.h),

                /// Info Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "profile_personal_info".tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      /// Info Tiles
                      _buildInfoTile(Icons.person, "profile_name".tr, profile.name),
                      _buildInfoTile(Icons.email, "profile_email".tr, profile.email),
                      _buildInfoTile(Icons.phone, "profile_phone".tr, profile.phone ?? "N/A"),
                      _buildInfoTile(Icons.roller_shades, "profile_role".tr, profile.role),
if(userrole == "user")
                      _buildInfoTile(Icons.payment, "profile_payment_status".tr, profile.paymentstatus),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
                Center(
  child: OutlinedButton.icon(
    style: OutlinedButton.styleFrom(
      minimumSize: Size(160.w, 40.h),
      side: BorderSide(
        color: Colors.grey.shade400,
        width: 1.2.w,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    ),
    onPressed: () {
      controller.logoutUser();
      print("Logout tapped");
    },
    icon: Icon(
      Icons.logout,
      color: Colors.black,
      size: 16.sp,
    ),
    label: Text(
      "profile_logout".tr,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontSize: 13.sp,
      ),
    ),
  ),
),

              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        leading: Icon(
          icon,
          color: Colors.black,
          size: 18.sp,
        ),
        title: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12.5.sp,
          ),
        ),
        subtitle: Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 11.sp,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            height: 160.h,
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
