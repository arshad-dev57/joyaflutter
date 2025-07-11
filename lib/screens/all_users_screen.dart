import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "All Users".tr,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Search & filter
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        controller.searchQuery.value = val;
                        controller.filterUsers();
                      },
                      decoration: InputDecoration(
                        hintText: "Search user...",
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 20.sp),
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
                  SizedBox(width: 12.w),
                  Obx(() {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: DropdownButton<String>(
                        value: controller.selectedRole.value,
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                        items: roles
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Text(
                                  role[0].toUpperCase() + role.substring(1),
                                  style: TextStyle(
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

            /// User List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(color: primaryColor));
                }

                if (controller.filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group_off, size: 64.sp, color: Colors.grey.shade400),
                        SizedBox(height: 12.h),
                        Text(
                          'No users found.',
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(16.r),
                  itemCount: controller.filteredList.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final user = controller.filteredList[index];

                    return Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                            backgroundColor: primaryColor.withOpacity(0.1),
                            child: Icon(Icons.person, color: primaryColor, size: 28.sp),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Name + Role
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${user.firstname} ${user.lastname}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                          color: primaryColor,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Text(
                                        user.role.toUpperCase(),
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),

                                /// Email
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 6.h),

                                /// Phone
                                Row(
                                  children: [
                                    Icon(Icons.phone, size: 14.sp, color: Colors.grey.shade600),
                                    SizedBox(width: 6.w),
                                    Flexible(
                                      child: Text(
                                        user.phone,
                                        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),

                                /// Country
                                Row(
                                  children: [
                                    Icon(Icons.flag, size: 14.sp, color: Colors.grey.shade600),
                                    SizedBox(width: 6.w),
                                    Flexible(
                                      child: Text(
                                        user.country.join(', '),
                                        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),

                                /// Language
                                Row(
                                  children: [
                                    Icon(Icons.language, size: 14.sp, color: Colors.grey.shade600),
                                    SizedBox(width: 6.w),
                                    Flexible(
                                      child: Text(
                                        user.language,
                                        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),

                          /// Delete Icon
                          IconButton(
                            onPressed: () {
                              controller.deleteUser(user.id);
                            },
                            icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 24.sp),
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
}
