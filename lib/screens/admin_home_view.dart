import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/po4rtfolio_controller.dart';
import 'package:joya_app/controllers/user_controller.dart';
import 'package:joya_app/screens/admin_ad_screen.dart';
import 'package:joya_app/screens/admin_all_vendors_screen.dart';
import 'package:joya_app/screens/admin_service_screen.dart';
import 'package:joya_app/screens/adminsociallink.dart';
import 'package:joya_app/screens/all_users_screen.dart';
import 'package:joya_app/screens/usser_profile_screen.dart';
import 'package:joya_app/utils/colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int selectedIndex = 0;
  final PortfolioController controller = Get.put(PortfolioController());
  final UsersController usercontroller = Get.put(UsersController());
  final TextEditingController searchController = TextEditingController();

  var _selectedIndex = 0;

  List<Map<String, dynamic>> get filteredMetrics {
    final query = searchController.text.toLowerCase();
    final metrics = [
      {
        'title': 'Users'.tr,
        'icon': 'assets/alluser.svg',
        'count': usercontroller.totalUsers.value,
        'route': AllUsersScreen(),
      },
      {
        'title': 'Vendors'.tr,
        'icon': 'assets/allvendor.svg',
        'count': usercontroller.totalVendors.value,
        'route': adminallvendorsscreen(),
      },
      {
        'title': 'Ads'.tr,
        'icon': 'assets/adds.svg',
        'count': usercontroller.totalAds.value,
        'route': adminaddscreen(),
      },
      {
        'title': 'Services'.tr,
        'icon': 'assets/service.svg',
        'count': usercontroller.totalServices.value,
        'route': AdminServiceScreen(),
      },
      {
        'title': 'Socail Links'.tr,
        'icon': 'assets/social.svg',
        'count': usercontroller.totalPaymentLinks.value,
        'route': AdminPaymentLinksScreen(),
      },
    ];

    if (query.isEmpty) return metrics;

    return metrics.where((item) {
      final title = item['title'].toString().toLowerCase();
      return title.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroungcolor,
      body: SafeArea(child: _selectedIndex == 0 ? buildDashboard() : UserProfileScreen()),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 100.w, right: 100.w, bottom: 12.h),
        child: Container(
          height: 55.h,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor.withOpacity(0.3)),
            color: const Color(0xffE1DBFF),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildBottomNavItem(0, "assets/home.svg"),
              buildBottomNavItem(1, "assets/vendors.svg"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomNavItem(int index, String iconPath) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? primaryColor : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: _selectedIndex == index
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : ColorFilter.mode(primaryColor.withOpacity(0.8), BlendMode.srcIn),
          height: 24.sp,
        ),
      ),
    );
  }

  Widget buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20.r,
              child: ClipOval(
                child: Image.asset(
                  "assets/user.jpg",
                  fit: BoxFit.cover,
                  height: 40.h,
                  width: 40.w,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
Text(
  "${"hi".tr} admin",
  style: TextStyle(
    fontSize: 16.sp,
    color: Colors.grey,
  ),
),                SizedBox(height: 4.h),
                Text("Elevate Your Business with Joya".tr,
                    style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w300)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDashboard() {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTopBar(),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: TextField(
              controller: searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Search".tr,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: SvgPicture.asset(
                    "assets/Magnifer.svg",
                    height: 40.h,
                    width: 40.w,
                    fit: BoxFit.contain,
                  ),
                ),
                prefixIconConstraints: BoxConstraints(minHeight: 12.h, minWidth: 36.w),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Obx(() {
              final filtered = filteredMetrics;

              return ListView.builder(
                padding: EdgeInsets.only(bottom: 80.h),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h, left: 8.w, right: 8.w),
                    child: DashboardCard(
                      title: item['title'] as String,
                      icon: item['icon'] as String,
                      count: item['count'] as int,
                      onTap: () => Get.to(item['route'] as Widget),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String icon;
  final int count;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: backgroungcolor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE4DEFD), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              height: 20.r,
              width: 20.r,
              child: SvgPicture.asset(icon,
                  colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                  height: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(child: Text(title, style: TextStyle(fontSize: 14.sp))),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            SizedBox(width: 8.w),
            Container(
              height: 28.r,
              width: 28.r,
              decoration: const BoxDecoration(color: Color(0xFFE4DEFD), shape: BoxShape.circle),
              child: Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
