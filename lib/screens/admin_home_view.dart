import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/po4rtfolio_controller.dart';
import 'package:joya_app/screens/admin_ad_screen.dart';
import 'package:joya_app/screens/admin_all_vendors_screen.dart';
import 'package:joya_app/screens/admin_service_screen.dart';
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

  final metrics = [
    {
      'title': 'Users',
      'icon': Icons.person_outline,
      'count': 120,
    },
    {
      'title': 'Vendors',
      'icon': Icons.storefront_outlined,
      'count': 45,
    },
    {
      'title': 'Ads',
      'icon': Icons.campaign_outlined,
      'count': 30,
    },
    {
      'title': 'Services',
      'icon': Icons.design_services_outlined,
      'count': 75,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildDashboard(),
      UserProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(child: pages[selectedIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 0.8),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined, size: 24.sp),
                label: "home".tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 24.sp),
                label: "profile".tr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDashboard() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Bar
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Image.asset(
                    'assets/joya.png',
                    height: 40.h,
                  ),
                ),
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

            /// Dashboard Grid
            Wrap(
              spacing: 16.w,
              runSpacing: 16.h,
              children: metrics
                  .map(
                    (item) => SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 24,
                      child: DashboardCard(
                        title: item['title'] as String,
                        icon: item['icon'] as IconData,
                        count: item['count'] as int,
                        onTap: () {
                          if (item['title'] == 'Users') {
                            Get.to(AllUsersScreen());
                          } else if (item['title'] == 'Vendors') {
                            Get.to(adminallvendorsscreen());
                          } else if (item['title'] == 'Ads') {
                            Get.to(adminaddscreen());
                          } else if (item['title'] == 'Services') {
                            Get.to(AdminServiceScreen());
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
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
          children: [
            Container(
              height: 50.r,
              width: 50.r,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: primaryColor,
                size: 26.sp,
              ),
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
