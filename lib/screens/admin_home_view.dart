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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroungcolor,
      body: SafeArea(child: _selectedIndex == 0 ? buildDashboard() : UserProfileScreen()),
      bottomNavigationBar:Padding(
    padding: EdgeInsets.only(left:100.w, right: 100.w, bottom: 12.h),
    child: Container(

      height: 55.h,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor.withOpacity(0.3)),
color: Color(0xffE1DBFF),
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedIndex = 0),
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: _selectedIndex == 0 ? primaryColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/home.svg",
                colorFilter: _selectedIndex == 0
                    ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                    : ColorFilter.mode(primaryColor.withValues(alpha: 0.8), BlendMode.srcIn),
                height: 24.sp,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _selectedIndex = 1),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: _selectedIndex == 1 ? primaryColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/vendors.svg",
                colorFilter: _selectedIndex == 1
                    ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                    : ColorFilter.mode(primaryColor.withValues(alpha: 0.8), BlendMode.srcIn),
                height: 24.sp,
              ),
            ),
          ),
        ],
      ),
    ),
  )
  );    
    
  }
Widget buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
                  "Hi,Admin",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  "Elevate Your Business with Joya",
                  style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            SizedBox(width: 12.w),
           
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
  padding: EdgeInsets.symmetric(horizontal: 10.w),
  child: TextField(
    controller: searchController,
    onChanged: (value) => setState(() {}),
    decoration: InputDecoration(
      hintText: "Search",
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14.sp,
      ),
      prefixIcon: SvgPicture.asset("assets/Magnifer.svg", height: 20.h),
      filled: true,
      fillColor: Colors.transparent, // or backgroungcolor if needed
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
          SizedBox(height: 12.h),
          Expanded(
            child: Obx(() {
              final metrics = [
                {
                  'title': 'Users',
                  'icon': 'assets/alluser.svg',
                  'count': usercontroller.totalUsers.value,
                  'route': AllUsersScreen(),
                },
                {
                  'title': 'Vendors',
                  'icon': 'assets/allvendor.svg',
                  'count': usercontroller.totalVendors.value,
                  'route': adminallvendorsscreen(),
                },
                {
                  'title': 'Ads',
                  'icon': 'assets/adds.svg',
                  'count': usercontroller.totalAds.value,
                  'route': adminaddscreen(),
                },
                {
                  'title': 'Services',
                  'icon': 'assets/service.svg',
                  'count': usercontroller.totalServices.value,
                  'route': AdminServiceScreen(),
                },
                {
                  'title': 'Payment Links',
                  'icon': 'assets/payment.svg',
                "count" : usercontroller.totalPaymentLinks.value,
                  // 'count': usercontroller.totalPaymentLinks.value,
                  'route': AdminPaymentLinksScreen(),
                },
              ];

              return ListView.builder(
  padding: EdgeInsets.only(bottom: 80.h),
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(), // if nested
  itemCount: metrics.length,
  itemBuilder: (context, index) {
    final item = metrics[index];
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: DashboardCard(
        title: item['title'] as String,
        icon:                     item['icon'] as String,
        count: item['count'] as int,
        onTap: () {
          Get.to(item['route'] as Widget);
        },
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
          border: Border.all(
            color: const Color(0xFFE4DEFD), 
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 20.r,
              width: 20.r,
              decoration: BoxDecoration(
                // color: primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(icon, colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn), height: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ),

            // Count
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            SizedBox(width: 8.w),

            // Right arrow in circle
            Container(
              height: 28.r,
              width: 28.r,
              decoration: BoxDecoration(
                color: const Color(0xFFE4DEFD),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.sp,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


