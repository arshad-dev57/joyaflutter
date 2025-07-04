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
import 'package:shared_preferences/shared_preferences.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  int _selectedIndex = 0;

  final List<String> carouselImages = [
    'https://picsum.photos/id/1018/800/400',
    'https://picsum.photos/id/1023/800/400',
    'https://picsum.photos/id/1025/800/400',
  ];

String? userCountry;

Future<void> loadCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? countries = prefs.getString('country');
print(countries);
    if (countries != null && countries.isNotEmpty) {
      setState(() {
        userCountry = countries;
        print(userCountry);
      });
    } else {
      setState(() {
        userCountry = 'Unknown';
      });
    }
  }
  @override
  void initState() {
    super.initState();
    loadCountry();
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(20.r),
          // color: Colors.grey.shade100,
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
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: primaryColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 22.sp),
                label: "vendor_home_nav_home".tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_outline, size: 22.sp),
                label: "vendor_home_nav_portfolio".tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 22.sp),
                label: "vendor_home_nav_profile".tr,
              ),
            ],
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "joya.png",
                  width: 50.w,
                  height: 50.h,
                ),
                InkWell(
                  onTap: () {
                    userProfileController.logoutUser();
                  },
                  child: Text(
                    "vendor_home_title".tr,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
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
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "vendor_home_ads".tr,
              style: TextStyle(
                color: primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.h),
        
         Obx(() {
  if (servicesController.isLoadingAds.value) {
    return SizedBox(
      height: 180.h,
      child: Center(
        child: CircularProgressIndicator(),
      ),
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
            color: Colors.grey,
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
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              ad.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          ),
        )
        .toList(),
  );
}),

          SizedBox(height: 20.h),
         Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.w),
  child: Obx(() {
    if (servicesController.isLoading.value) {
      /// Show shimmer grid
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.85,
        ),
        itemCount: 4, // show 4 shimmer items
        itemBuilder: (context, index) {
          return buildShimmerItem();
        },
      );
    }

    if (servicesController.servicesList.isEmpty) {
      return Center(
        child: Text(
          "No services found",
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                ),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12.r),
                ),
              ),
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GridItem {
  final String title;
  final String imageUrl;

  GridItem({required this.title, required this.imageUrl});
}
