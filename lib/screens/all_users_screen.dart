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
            fontSize: 14.sp,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(12.r),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: Colors.white, size: 14.sp),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40.h,
                      child: TextField(
                        onChanged: (val) {
                          controller.searchQuery.value = val;
                          controller.filterUsers();
                        },
                        decoration: InputDecoration(
                          hintText: "Search user...",
                          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 16.sp),
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
  padding: EdgeInsets.all(12.r),
  itemCount: controller.filteredList.length,
  separatorBuilder: (_, __) => SizedBox(height: 12.h),
  itemBuilder: (context, index) {
    final user = controller.filteredList[index];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: primaryColor.withValues(alpha: 0.1),
            child: Icon(
              Icons.person,
              color: primaryColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name row with delete icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${user.firstname} ${user.lastname}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: primaryColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.deleteUser(user.id);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade400,
                        size: 20.sp,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    )
                  ],
                ),

                SizedBox(height: 4.h),

                /// Email
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),

                /// Phone
                Row(
                  children: [
                    Icon(Icons.phone, size: 14.sp, color: Colors.grey.shade600),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        user.phone,
                        style: TextStyle(fontSize: 11.5.sp, color: Colors.grey.shade800),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                /// Country
                Row(
                  children: [
                    Icon(Icons.flag, size: 14.sp, color: Colors.grey.shade600),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        user.country.join(', '),
                        style: TextStyle(fontSize: 11.5.sp, color: Colors.grey.shade800),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.language, size: 14.sp, color: Colors.grey.shade600),
                        SizedBox(width: 6.w),
                        Text(
                          user.language,
                          style: TextStyle(fontSize: 11.5.sp, color: Colors.grey.shade800),
                        ),
                      ],
                    ),
                DropdownButton<String>(
  value: (user.paymentStatus == 'paid' || user.paymentStatus == 'unpaid')
      ? user.paymentStatus
      : 'unpaid', // fallback in case backend gives junk
  items: ['paid', 'unpaid']
      .map((status) => DropdownMenuItem<String>(
            value: status,
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 11.sp,
                color: status == 'paid' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ))
      .toList(),
  onChanged: (newStatus) {
    if (newStatus != null && newStatus != user.paymentStatus) {
      controller.updateUserPaymentStatus(user.id, newStatus);
    }
  },
  underline: SizedBox(),
  icon: Icon(Icons.arrow_drop_down, size: 16.sp),
)
,
                  
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        user.role.toUpperCase(),
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
          ],
        ),
      ),
    );
  }
}
