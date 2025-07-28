import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/paymentlinkcontroller.dart';
import 'package:joya_app/controllers/services_controller.dart';
import 'package:joya_app/controllers/user_controller.dart';
import 'package:joya_app/controllers/userprofile_controller.dart';
import 'package:joya_app/models/servides_model.dart';
import 'package:joya_app/screens/all_vendors_screen.dart';
import 'package:joya_app/screens/usser_profile_screen.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? userCountry;
  String? username;
  String? userRole;
String? userImageUrl;
  final servicecontroller = Get.put(ServicesController());
  final TextEditingController searchController = TextEditingController();
final PaymentLinkController controller = Get.put(PaymentLinkController());
final usercontroller = Get.put(UserProfileController());
  @override
  void initState() {
    super.initState();
    loadUserImage();
    loadCountry();
    loadUserRole();
    loadUsername();
    servicecontroller.fetchServices();
    controller.fetchPaymentLinks();
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

Future<void> loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    if (role != null && role.isNotEmpty) {
      setState(() {
        userRole = role;
      });
    } else {
      setState(() {
        userRole = 'Unknown';
      });
    }
  }

Future<void> loadUserImage() async {
 var imageUrl = usercontroller.userProfile.value?.image;

  setState(() {
    userImageUrl = imageUrl;
  });
}
  Future<void> loadCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? countries = prefs.getString('country');
    userCountry = countries?.isNotEmpty == true ? countries : 'Unknown';
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroungcolor,
      body: _selectedIndex == 0 ? buildHomeContent() : UserProfileScreen(),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }


Widget buildBottomNavBar() {
  return Padding(
    padding: EdgeInsets.only(left:100.w, right: 100.w, bottom: 12.h),
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


  Widget buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16.h),
          buildTopBar(),
          SizedBox(height: 8.h),
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
          buildServicesSection(),
        ],
      ),
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
    child: usercontroller.userProfile.value?.image != null
        ? Image.network(
            usercontroller.userProfile.value!.image!,
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
  "${'hi'.tr},${username}",
  style: TextStyle(
    fontSize: 16.sp,
    color: primaryColor,
  ),
),
                SizedBox(height: 4.h),
                Text(
                  "${userRole}",
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            SizedBox(width: 12.w),
           
          ],
        ),
      ),
    );
  }


final RxInt currentIndex = 0.obs;
Widget buildAdsSection() {
  return Obx(() {
    if (servicecontroller.isLoading.value) {
      return Shimmer.fromColors(
    baseColor: backgroungcolor,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
    ),
  );
    }

    if (servicecontroller.adsList.isEmpty) {
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
      itemCount: servicecontroller.adsList.length,
      itemBuilder: (context, index, realIndex) {
        final ad = servicecontroller.adsList[index];
        return Stack(
          children: [
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
                      count: servicecontroller.adsList.length,
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

  Widget buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Text(
            "Services".tr,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
          ),
        ),      
        SizedBox(height: 6.h),

        Obx(() {
         if (servicecontroller.isLoading.value) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4, 
      itemBuilder: (context, index) => buildServiceShimmer(),
    ),
  );
}

          final filteredServices = servicecontroller.servicesList.where((item) {
            final query = searchController.text.toLowerCase();
            return item.title.toLowerCase().contains(query);
          }).toList();

          return Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.w),
  child: ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: filteredServices.length,
    itemBuilder: (context, index) {
      final item = filteredServices[index];
      return _buildGridItem(item); // You can rename it to _buildListItem if needed
    },
  ),
);

        }),
      ],
    );
  }

 Widget _buildGridItem(ServiceModel item) {
  bool isClickable = item.vendorCount > 0;
  return Opacity(
    opacity: isClickable ? 1.0 : 0.5,
    child: InkWell(
      onTap: isClickable
          ? () {
              Get.to(() => AllVendorsScreen(
                    country: userCountry!,
                    service: item.title,
                  ));
            }
          : null,
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
                      onPressed: isClickable
                          ? () {
                              Get.to(() => AllVendorsScreen(
                                    country: userCountry!,
                                    service: item.title,
                                  ));
                            }
                          : null,
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
                            "view more",
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
    ),
  );
}
Widget buildServiceShimmer() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Shimmer.fromColors(
      baseColor: backgroungcolor,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            SizedBox(height: 12.h),
            Container(height: 14.h, width: 100.w, color: Colors.white),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 12.h, width: 60.w, color: Colors.white),
                Container(height: 32.h, width: 80.w, color: Colors.white),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

}
