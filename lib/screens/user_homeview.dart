import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/services_controller.dart';
import 'package:joya_app/models/servides_model.dart';
import 'package:joya_app/screens/all_vendors_screen.dart';
import 'package:joya_app/screens/usser_profile_screen.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? userCountry;
  final servicecontroller = Get.put(ServicesController());
  @override
  void initState() {
    super.initState();
    loadCountry();
    servicecontroller.fetchServices();
  }

  Future<void> loadCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? countries = prefs.getString('country');
    userCountry = countries?.isNotEmpty == true ? countries : 'Unknown';
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FA),
      body: _selectedIndex == 0 ? buildHomeContent() : UserProfileScreen(),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }

  Widget buildBottomNavBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 12,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey.shade600,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16.h),
          buildTopBar(),
          SizedBox(height: 20.h),
          buildAdsSection(),
          SizedBox(height: 24.h),
          buildServicesSection(),
        ],
      ),
    );
  }

  Widget buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child:  
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Column(
                   children: [
                     Text("Hii, Arshad",style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.w400),),
                      SizedBox(width: 160.w),
                 Text("Elevate Your Business with Joya",style: TextStyle(fontSize: 10.sp,fontWeight: FontWeight.w300),),
                   ],
                 ),
                
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20.r,
                    child: ClipOval(
                      child: Image.asset(
                        "assets/user.jpg",
                        fit: BoxFit.cover,
                        height: 30.h,
                        width: 30.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildAdsSection() {
    return Obx(() {
      if (servicecontroller.adsList.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            height: 180.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: Text(
                "No Ads Available",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        );
      }

      return CarouselSlider(
        options: CarouselOptions(
          height: 180.h,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          autoPlayInterval: Duration(seconds: 3),
        ),
        items: servicecontroller.adsList.map(
          (ad) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(
                  ad.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            );
          },
        ).toList(),
      );
    });
  }

  Widget buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
  padding: EdgeInsets.symmetric(horizontal: 12.w),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Text("Services".tr,style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.w400),)),
),

        SizedBox(height: 16.h),
        Obx(() {
          if (servicecontroller.servicesList.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: CircularProgressIndicator(color: primaryColor),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: servicecontroller.servicesList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final item = servicecontroller.servicesList[index];
                return _buildGridItem(item);
              },
            ),
          );
        }),
      ],
    );
  }

Widget _buildGridItem(ServiceModel item) {
  return InkWell(
    onTap: () {
      Get.to(() => AllVendorsScreen(
            country: userCountry!,
            service: item.title,
          ));
    },
    child: Container(
      width: 120.w,
      height: 160.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
  children: [
    // Background Image
    Positioned.fill(
      child: Image.network(
        item.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.white,
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.grey.shade100,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    ),

    // Gradient Overlay
    Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ),

    // 🔹 Top-right Vendor Count Badge
    Positioned(
      top: 8.r,
      right: 8.r,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          // color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.black12),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 4,
          //     offset: Offset(0, 2),
          //   )
          // ],
        ),
        child: Text(
          "${item.vendorCount} vendors",
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    ),

    // Title at bottom
    Positioned(
      left: 8.r,
      right: 8.r,
      bottom: 12.r,
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          shadows: [
            Shadow(
              color: Colors.black45,
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    ),
  ],
),

      ),
    ),
  );
}
}
