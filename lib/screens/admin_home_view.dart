import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/po4rtfolio_controller.dart';
import 'package:joya_app/screens/all_users_screen.dart';
import 'package:joya_app/screens/usser_profile_screen.dart';
import 'package:joya_app/utils/colors.dart';

// Dummy profile screen


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
      'icon': Icons.person,
      'count': 120,
      'color': Colors.blue
    },
    {
      'title': 'Vendors',
      'icon': Icons.store,
      'count': 45,
      'color': Colors.orange
    },
    {
      'title': 'Ads',
      'icon': Icons.campaign,
      'count': 30,
      'color': Colors.green
    },
    {
      'title': 'Services',
      'icon': Icons.build,
      'count': 75,
      'color': Colors.purple
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
      backgroundColor: Colors.grey[100],
      body: SafeArea(child: pages[selectedIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20.r),
          // color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.shade300,
          //     blurRadius: 8.r,
          //     offset: Offset(0, -4.h),
          //   ),
          // ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: primaryColor,
            iconSize: 24.sp,
            selectedFontSize: 14.sp,
            unselectedFontSize: 14.sp,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 24.sp),
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
    return Column(
      children: [
        // ✅ Custom TopBar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              InkWell(
                onTap: (){

                },
                child: Image.asset('assets/joya.png', height: 40)), // Make sure this path is correct
              const Spacer(),
              const Text(
                'Admin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const Spacer(),
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/user.jpg'), // Replace with user's image
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
          GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          height: 100.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.w,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.grey, size: 24.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  "add_portfolio_add_photo".tr,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                        controller.imageFiles.isEmpty
                          ? const SizedBox()
                          : Row(
                            children: [
                              SizedBox(
                                  height: 100.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.imageFiles.length,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 10.w),
                                            width: 100.w,
                                            height: 100.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12.r),
                                              image: DecorationImage(
                                                image: FileImage(
                                                  controller.imageFiles[index],
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 4.w,
                                            top: 4.h,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  controller.removeImage(index),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: EdgeInsets.all(4.w),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 18.sp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),

        // ✅ Cards
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: metrics.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cards per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final item = metrics[index];
                return DashboardCard(
                  title: item['title'] as String,
                  icon: item['icon'] as IconData,
                  count: item['count'] as int,
                  color: item['color'] as Color,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      Get.to(AllUsersScreen());
        print('Tapped on $title');
      },
      child: Card(
        elevation: 4,
        shadowColor: color.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$count',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
