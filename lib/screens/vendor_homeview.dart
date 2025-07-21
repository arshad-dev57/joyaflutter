import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/services_controller.dart';
import 'package:joya_app/controllers/userprofile_controller.dart';
import 'package:joya_app/models/servides_model.dart';
import 'package:joya_app/screens/all_vendors_screen.dart';
import 'package:joya_app/screens/usser_profile_screen.dart';
import 'package:joya_app/screens/vendor_portfolio_screen.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:joya_app/widgets/shimmer.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  int _selectedIndex = 0;
  String? userCountry;
  String? username;

  final UserProfileController userProfileController = Get.put(UserProfileController());
  final ServicesController servicesController = Get.put(ServicesController());
  final TextEditingController searchController = TextEditingController(); // 🔍

  @override
  void initState() {
    super.initState();
    loadCountry();
    loadUsername();
    servicesController.fetchServices();
  }

  Future<void> loadCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final country = prefs.getString('country');
    if (country != null && country.isNotEmpty) {
      setState(() {
        userCountry = country;
      });
    } else {
      setState(() {
        userCountry = 'Unknown';
      });
    }
  }

  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username');
    if (name != null && name.isNotEmpty) {
      setState(() {
        username = name;
      });
    } else {
      setState(() {
        username = 'Unknown';
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: _buildBody(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            color: Colors.grey.shade100,
            child: SizedBox(
              height: 54.h,
              child: SalomonBottomBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                backgroundColor: primaryColor,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey.shade200,
                itemPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                items: [
                  SalomonBottomBarItem(
                    icon: Icon(Icons.home),
                    title: Text("Home", style: TextStyle(fontSize: 12.sp)),
                    selectedColor: Colors.white,
                  ),
                  SalomonBottomBarItem(
                    icon: Icon(Icons.portrait),
                    title: Text("Portfolio", style: TextStyle(fontSize: 12.sp)),
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

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return buildHomeContent();
    } else if (_selectedIndex == 1) {
      return VendorPortfolioScreen();
    } else {
      return UserProfileScreen();
    }
  }

  Widget buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hii, $username",
                          style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w400),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Elevate Your Business with Joya",
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
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
            SizedBox(height: 6.h),

            Obx(() {
              if (servicesController.isLoadingAds.value) {
                return SizedBox(
                  height: 180.h,
                  child: Center(child: CircularProgressIndicator(color: Colors.white)),
                );
              }
              if (servicesController.adsList.isEmpty) {
                return SizedBox(
                  height: 180.h,
                  child: Center(
                    child: Text("No Ads found", style: TextStyle(fontSize: 16.sp, color: Colors.white)),
                  ),
                );
              }

              return CarouselSlider(
                options: CarouselOptions(
                  height: 180.h,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items: servicesController.adsList.map((ad) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.network(
                      ad.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image, size: 40, color: Colors.white),
                    ),
                  );
                }).toList(),
              );
            }),

            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Services".tr,
                  style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w400),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // 🔍 Search Field
           Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextField(
            controller: searchController,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Search services...",
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

            SizedBox(height: 10.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() {
                if (servicesController.isLoading.value) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return buildShimmerItem();
                    },
                  );
                }

                final filteredServices = servicesController.servicesList.where((item) {
                  final query = searchController.text.toLowerCase();
                  return item.title.toLowerCase().contains(query);
                }).toList();

                if (filteredServices.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Text("No services found", style: TextStyle(fontSize: 16.sp)),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    final item = filteredServices[index];
                    return _buildGridItem(item);
                  },
                );
              }),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(ServiceModel item) {
    return InkWell(
      onTap: () {
        Get.to(() => AllVendorsScreen(country: userCountry!, service: item.title));
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
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
