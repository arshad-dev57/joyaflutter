import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class vendorprofilescreen extends StatelessWidget {
  // Dummy data (replace with real user data)
  final String userImage = "https://i.pravatar.cc/300";
  final String name = "Terry Melton";
  final String email = "melton89@gmail.com";
  final String phone = "+1 201 555-0123";
  final String address = "70 Rainey Street, Apartment 146,\nAustin TX 78701";

  const vendorprofilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.black;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "profile_title".tr,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            children: [
              /// User Image
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

              /// User Details Container
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
                    /// Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "profile_personal_info".tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    _buildInfoTile(Icons.person, "profile_name".tr, name),
                    _buildInfoTile(Icons.email, "profile_email".tr, email),
                    _buildInfoTile(Icons.phone, "profile_phone".tr, phone),
                    _buildInfoTile(Icons.location_on, "profile_address".tr, address),
                  ],
                ),
              ),

              /// Logout Button
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
                    print("Logout tapped");
                  },
                  child: Text(
                    "profile_logout".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
}
