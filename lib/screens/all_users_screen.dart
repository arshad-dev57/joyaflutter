import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/user_controller.dart';
import 'package:joya_app/utils/colors.dart';

class AllUsersScreen extends StatelessWidget {
  AllUsersScreen({super.key});
  final UsersController controller = Get.put(UsersController());
  final roles = ['All', 'user', 'vendor', 'admin'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroungcolor,

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Row(
              children: [
                InkWell(onTap: () {
                  Get.back();
                }, child: SvgPicture.asset("assets/Arrow.svg")),
                SizedBox(width: 12.w),
                Text(
                  "Users",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40.h,
                      child: TextField(
                        onChanged: (val) {
                          controller.searchQuery.value = val;
                          controller.filterUsers();
                        },
                        decoration: InputDecoration(
                          hintText: "Search user...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12.sp,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 16.sp,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Obx(() {
                    return Container(
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        value: controller.selectedRole.value,
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                        items:
                            roles
                                .map(
                                  (role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(
                                      role[0].toUpperCase() + role.substring(1),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedRole.value = value;
                            controller.filterUsers();
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                if (controller.filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_off,
                          size: 64.sp,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No users found.',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(12.r),
                  itemCount: controller.filteredList.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final user = controller.filteredList[index];

                    return Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: const Color(0xF6F4F9FF), // soft background
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFE4DEFD),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 22.r,
                                backgroundImage: AssetImage(
                                  "assets/userimage.jpg",
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  "${user.firstname} ${user.lastname}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.more_vert,
                                size: 18.sp,
                                color: Colors.grey,
                              ),
                            ],
                          ),

                          SizedBox(height: 14.h),

                          // Details Row
                          buildInfoRow("assets/Globe.svg", "English"),
                          buildInfoRow(
                            "assets/Hang Up.svg",
                            "Phone number",
                            value: user.phone,
                          ),
                          buildInfoRow(
                            "assets/location.svg",
                            "Location",
                            value: user.country.join(', '),
                          ),
                          buildInfoRow(
                            "assets/letter.svg",
                            "Email",
                            value: user.email,
                          ),

                          buildInfoRow(
                            "assets/payment.svg",
                            "Paid",
                            valueWidget: Text(
                              user.paymentStatus.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color:
                                    user.paymentStatus == 'paid'
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  user.role.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
  Widget buildInfoRow(String iconPath, String title, {String? value, Widget? valueWidget}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Color(0xFFE4DEFD),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            iconPath,
            height: 16.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black54,
            ),
          ),
        ),
        valueWidget ??
            Text(
              value ?? '',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
              ),
            ),
      ],
    ),
  );
}

}
