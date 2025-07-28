import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/user_controller.dart';
import 'package:joya_app/utils/colors.dart';

class AllUsersScreen extends StatelessWidget {
  AllUsersScreen({super.key});
  final UsersController controller = Get.put(UsersController());
  final roles = ['All'.tr, 'User'.tr, 'Vendor'.tr, 'Admin'.tr];
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
                  InkWell(onTap: () {
                    Get.back();
                  }, child: SvgPicture.asset("assets/Arrow.svg", height: 32.h)),
                  SizedBox(width: 12.w),
                  Text(
                    "Users".tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
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
                        decoration:InputDecoration(
              hintText: "Search".tr,
              hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14.sp,
              ),
              prefixIcon: SvgPicture.asset("assets/Magnifer.svg", height: 12.h),
              filled: true,
              fillColor: Colors.transparent, 
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
                 
                ],
              ),
            ),
        SizedBox(height: 8.h),
         Padding(
           padding: EdgeInsets.symmetric(horizontal: 12.w),
           child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: roles.map((role) {
        final isSelected = controller.selectedRole.value.toLowerCase() == role.toLowerCase();
           
        return GestureDetector(
          onTap: () {
            controller.selectedRole.value = role.toLowerCase();
            controller.filterUsers();
          },
          child: Container(
           height: 34.h,
           width: 75.w,
           
            margin: EdgeInsets.only(right: 10.w),
            // padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : backgroungcolor,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: primaryColor,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  role,
                  style: TextStyle(
                    color: isSelected ? Colors.white : primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6.w),
                CircleAvatar(
                  radius: 8.r,
                  backgroundColor: isSelected ? Colors.white : primaryColor,
                  child: Center(
                    child: Text(
                      controller.getCountByRole(role).toString(),
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: isSelected ? primaryColor : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
              }).toList(),
            );
           }),
         ),
         SizedBox(height: 12.h),
            Obx(() {
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
                      
              return Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  
                  itemCount: controller.filteredList.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final user = controller.filteredList[index];
                          
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        margin: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xF6F4F9FF), 
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 22.r,
                                  backgroundImage: NetworkImage(
                                    user.image ,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    "${user.firstname} ${user.lastname}",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                               Container(
                                 height: 32,
                                 width: 32,
                                 decoration: BoxDecoration(
                                   color: Colors.grey.withOpacity(0.2),
                                   shape: BoxShape.circle,
                                 ),
                                 child: PopupMenuButton<int>(
                                   padding: EdgeInsets.zero,
                                   icon: Icon(Icons.more_vert, size: 16, color: Colors.black),
                                   itemBuilder: (context) => [
                                     PopupMenuItem(
                                       value: 1,
                                       height: 32,
                                       padding: EdgeInsets.symmetric(horizontal: 8),
                                       child: Row(
                                         children: [                                           SizedBox(width: 8),
                                           Text(
                                             "Delete",
                                             style: TextStyle(
                                               fontSize: 13,
                                               color: Colors.red,
                                               fontWeight: FontWeight.w500,
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ],
                                   onSelected: (value) {
                                     if (value == 1) {
                                       print("Delete tapped");
                                       controller.deleteUser(user.id);
                                     }
                                   },
                                   color: Colors.red.shade50,
                                   offset: Offset(0, 30),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(8),
                                   ),
                                 ),
                               ),
                              ],
                            ),
                      
                            SizedBox(height: 14.h),
                      
                      buildInfoRow(
                        "assets/Globe.svg",
                        user.language.toString(),
                        valueWidget: Row(
                          children: [
                            // Text(
                            //   user.language.toString(),
                            //   style: TextStyle(
                            //     fontSize: 12.sp,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                user.role.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                            buildInfoRow(
                              "assets/Hang Up.svg",
                              "Phone number".tr,
                              value: user.phone,
                            ),
                            buildInfoRow(
                              "assets/Point.svg",
                              "Location".tr,
                              value: user.country.join(', '),
                            ),
                            buildInfoRow(
                              "assets/Letter.svg",
                              "Email".tr,
                              value: user.email,
                            ),
                      
                            InkWell(
                              onTap: () {
                                
                              },
                              child: buildInfoRow(
                                "assets/Money Send.svg",
                                user.paymentStatus.toString(),
                                valueWidget: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.more_vert, size: 16, color: Colors.black),
                                    onSelected: (String value) async {
                                      await controller.updateUserPaymentStatus(user.id, value);
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem(
                                        value: 'paid',
                                        height: 36,
                                        child: Row(
                                          children: [
                                            Icon(Icons.check_circle, size: 16, color: Colors.green),
                                            SizedBox(width: 8),
                                            Text("Mark as Paid".tr, style: TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'unpaid',
                                        height: 36,
                                        child: Row(
                                          children: [
                                            Icon(Icons.cancel, size: 16, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text("Mark as Unpaid".tr, style: TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                    ],
                                    color: Colors.white,
                                    offset: Offset(0, 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),

                      
                              ),
                            ),
                      
                            SizedBox(height: 12.h),
                           
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
  Widget buildInfoRow(String iconPath, String title, {String? value, Widget? valueWidget}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            // color: Color(0xFFE4DEFD),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            iconPath,
            height: 26.sp,
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
