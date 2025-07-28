import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  int _selectedIndex = 0;
  String? userCountry;
  String? username;
final RxInt currentIndex = 0.obs;

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
      backgroundColor: backgroungcolor,
body: _buildBody(),
    bottomNavigationBar: buildBottomNavBar(),
    );
  }

Widget buildBottomNavBar() {
  return Padding(
padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 12.h),
    child: Container(
      height: 60.h,
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
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: _selectedIndex == 0 ? primaryColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/home.svg",
                colorFilter: _selectedIndex == 0
                    ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                    : ColorFilter.mode(primaryColor.withOpacity(0.8), BlendMode.srcIn),
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
                "assets/portfolio.svg",
                colorFilter: _selectedIndex == 1
                    ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                    : ColorFilter.mode(primaryColor.withOpacity(0.8), BlendMode.srcIn),
                height: 18.sp,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _selectedIndex = 2),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: _selectedIndex == 2 ? primaryColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/vendors.svg",
                colorFilter: _selectedIndex == 2
                    ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                    : ColorFilter.mode(primaryColor.withOpacity(0.8), BlendMode.srcIn),
                height: 24.sp,
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
    if (servicesController.adsList.isEmpty) {
      return Container(
        height: 180.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Text(
            "No Ads Available",
            style: TextStyle(color: Colors.grey, fontSize: 16.sp),
          ),
        ),
      );
    }

    return CarouselSlider.builder(
      itemCount: servicesController.adsList.length,
      itemBuilder: (context, index, realIndex) {
        final ad = servicesController.adsList[index];
        return Stack(
          children: [
            /// Background Image
            Container(
              width: double.infinity,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(
                  ad.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180.h,
                ),
              ),
            ),

          

            Positioned(
              bottom: 12.h,
              left: 0,
              right: 0,
              child: Center(
                child: Obx(() => AnimatedSmoothIndicator(
                      activeIndex: currentIndex.value,
                      count: servicesController.adsList.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 6.h,
                        dotWidth: 6.h,
                        spacing: 6.w,
                        activeDotColor: Colors.white,
                        dotColor: Colors.white54,
                      ),
                    )),
              ),
            ),
          ],
        );
      },
      options: CarouselOptions(
        height: 180.h,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        onPageChanged: (index, reason) {
          currentIndex.value = index;
        },
      ),
    );
  });
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
    child: userProfileController.userProfile.value?.image != null
        ? Image.network(
            userProfileController.userProfile.value!.image!,
            fit: BoxFit.cover,
            height: 40.h,
            width: 40.w,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                "assets/user.jpg",
                fit: BoxFit.cover,
                height: 40.h,
                width: 40.w,
              );
            },
          )
        : Image.asset(
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
  "${'hi'.tr}${username}",
  style: TextStyle(
    fontSize: 12.sp,
    color: Colors.grey,
  ),
),
                SizedBox(height: 4.h),
                Text(
                  "Elevate Your Business with Joya".tr,
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

  Widget buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
           buildTopBar(),
            SizedBox(height: 12.h),
             Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.w),
  child: TextField(
    controller: searchController,
    onChanged: (value) => setState(() {}),
    decoration: InputDecoration(
      hintText: "Search".tr,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 12.sp,
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.all(4.r),
        child: SvgPicture.asset(
          "assets/Magnifer.svg",
          height: 40.h,
          width: 40.w,
          fit: BoxFit.contain,
        ),
      ),
      prefixIconConstraints: BoxConstraints(
        minHeight: 12.h,
        minWidth: 36.w,
      ),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
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

            buildAdsSection(),
            SizedBox(height: 12.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child:  Text(
            "Services".tr,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
          ),
              ),
            ),
            SizedBox(height: 12.h),

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

                return ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: filteredServices.length,
  itemBuilder: (context, index) {
    final item = filteredServices[index];
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: _buildGridItem(item),
    );
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all( Radius.circular(16.r)),
            child: Image.network(
              item.imageUrl,
              height: 214.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.white,
                height: 140.h,
                child: Icon(Icons.broken_image, color: Colors.grey),
              ),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: Colors.grey.shade100,
                  height: 140.h,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 12.h),
  
                Row(
                  children: [
                    SvgPicture.asset("assets/vendors.svg", height: 20.h),
                                          SizedBox(width: 4.w),
                  Text(
  "${item.vendorCount} ${'vendors_label'.tr}",
  style: TextStyle(
    fontSize: 12.sp,
    color: Colors.grey,
  ),
),

                    Spacer(),
                     SizedBox(
                  width: 90.w,
                  height: 28.h,
                  child: ElevatedButton(
                    onPressed: 
                        () {
                            Get.to(() => AllVendorsScreen(
                                  country: userCountry!,
                                  service: item.title,
                                ));
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "view_more".tr,
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(Icons.arrow_forward, size: 14.sp,color: Colors.white,),
                      ],
                    ),
                  ),
                ),
              
                  ],
                  
                ),
              SizedBox(height: 28.h), 
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  // Widget _buildGridItem(ServiceModel item) {
  //   return InkWell(
  //     onTap: () {
  //       Get.to(() => AllVendorsScreen(country: userCountry!, service: item.title));
  //     },
  //     child: Container(
  //       width: 120.w,
  //       height: 160.h,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12.r),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.shade300,
  //             blurRadius: 8.r,
  //             offset: Offset(0, 4.h),
  //           )
  //         ],
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(12.r),
  //         child: Stack(
  //           children: [
  //             Positioned.fill(
  //               child: Image.network(
  //                 item.imageUrl,
  //                 fit: BoxFit.cover,
  //                 errorBuilder: (context, error, stackTrace) => Container(
  //                   color: Colors.white,
  //                   child: Icon(Icons.broken_image, color: Colors.grey),
  //                 ),
  //                 loadingBuilder: (context, child, progress) {
  //                   if (progress == null) return child;
  //                   return Container(
  //                     color: Colors.grey.shade100,
  //                     child: Center(child: CircularProgressIndicator()),
  //                   );
  //                 },
  //               ),
  //             ),
  //             Positioned.fill(
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
  //                     begin: Alignment.topCenter,
  //                     end: Alignment.bottomCenter,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               left: 8.r,
  //               right: 8.r,
  //               bottom: 12.r,
  //               child: Text(
  //                 item.title,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14.sp,
  //                   shadows: [
  //                     Shadow(
  //                       color: Colors.black45,
  //                       offset: Offset(0, 1),
  //                       blurRadius: 2,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
