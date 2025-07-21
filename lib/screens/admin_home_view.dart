import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int selectedIndex = 0;
  final PortfolioController controller = Get.put(PortfolioController());
  final UsersController usercontroller = Get.put(UsersController());

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [buildDashboard(), UserProfileScreen()];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(child: pages[selectedIndex]),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            color: Colors.grey.shade100,
            child: SizedBox(
              height: 54.h,
              child: SalomonBottomBar(
                currentIndex: selectedIndex,
                onTap: _onItemTapped,
                backgroundColor: primaryColor,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey.shade200,
                itemPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
                items: [
                  SalomonBottomBarItem(
                    icon: Icon(Icons.home),
                    title: Text("Home", style: TextStyle(fontSize: 12.sp)),
                    selectedColor: Colors.white,
                  ),
                  SalomonBottomBarItem(
                    icon: Icon(Icons.person),
                    title: Text("Profile", style: TextStyle(fontSize: 12.sp)),
                    selectedColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDashboard() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Bar
          Row(
            children: [
              Image.asset('assets/joya.png', height: 40.h),
              Spacer(),
              Text(
                'Admin',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Spacer(),
              CircleAvatar(
                radius: 20.r,
                backgroundImage: AssetImage('assets/user.jpg'),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: Obx(() {
              final metrics = [
                {
                  'title': 'Users',
                  'icon': Icons.person_outline,
                  'count': usercontroller.totalUsers.value,
                  'route': AllUsersScreen(),
                },
                {
                  'title': 'Vendors',
                  'icon': Icons.storefront_outlined,
                  'count': usercontroller.totalVendors.value,
                  'route': adminallvendorsscreen(),
                },
                {
                  'title': 'Ads',
                  'icon': Icons.campaign_outlined,
                  'count': usercontroller.totalAds.value,
                  'route': adminaddscreen(),
                },
                {
                  'title': 'Services',
                  'icon': Icons.design_services_outlined,
                  'count': usercontroller.totalServices.value,
                  'route': AdminServiceScreen(),
                },
                {
                  'title': 'Payment Links',
                  'icon': Icons.payment,
                "count" : usercontroller.totalPaymentLinks.value,
                  // 'count': usercontroller.totalPaymentLinks.value,
                  'route': AdminPaymentLinksScreen(),
                },
              ];

              return GridView.builder(
                padding: EdgeInsets.only(bottom: 80.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                ),
                itemCount: metrics.length,
                itemBuilder: (context, index) {
                  final item = metrics[index];
                  return DashboardCard(
                    title: item['title'] as String,
                    icon: item['icon'] as IconData,
                    count: item['count'] as int,
                    onTap: () {
                      Get.to(item['route'] as Widget);
                    },
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
  final IconData icon;
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
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50.r,
              width: 50.r,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 26.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              count.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
