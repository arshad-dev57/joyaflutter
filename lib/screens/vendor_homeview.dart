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
 

  @override
  void initState() {
    super.initState();
    loadCountry();
    loadUsername();
  }
  Future<void> loadCountry() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final country = prefs.getString('country');
  print("country: $country");
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
  print("username: $name");
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

  final UserProfileController userProfileController = Get.put(UserProfileController());
  final ServicesController servicesController = Get.put(ServicesController());

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: _buildBody(),
 bottomNavigationBar: Padding(
  padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(30.r),
    child: Container(
      color: Colors.grey.shade100,
      child: SizedBox(
        height: 54.h, // 👈 Custom height (try 48.h to 56.h range as needed)
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade200,
          itemPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h), // 👈 Reduced padding
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
                    child: Text(
                      "No Ads found",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
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
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items: servicesController.adsList
                    .map(
                      (ad) => ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.network(
                          ad.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 40, color: Colors.white),
                        ),
                      ),
                    )
                    .toList(),
              );
            }),

            SizedBox(height: 20.h),

Padding(
  padding: EdgeInsets.symmetric(horizontal: 12.w),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Text("Services".tr,style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.w400),)),
),

SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() {
                if (servicesController.isLoading.value) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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

                if (servicesController.servicesList.isEmpty) {
                  return Center(
                    child: Text(
                      "No services found",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: servicesController.servicesList.length,
                  itemBuilder: (context, index) {
                    final item = servicesController.servicesList[index];
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

            // Text
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
Widget forSaleRibbon() {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      // Ribbon
      Container(
        width: 140,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade800,
              Colors.cyanAccent.shade400,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "For Sale",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),

      // Diamond shape
      Positioned(
        right: -10,
        top: 5,
        child: Transform.rotate(
          angle: 0.785398, // 45 degrees in radians
          child: Container(
            width: 20,
            height: 20,
            color: Colors.blue.shade800,
          ),
        ),
      ),
    ],
  );
}

}
