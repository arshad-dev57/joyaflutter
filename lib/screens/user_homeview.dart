import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/paymentlinkcontroller.dart';
import 'package:joya_app/controllers/services_controller.dart';
import 'package:joya_app/models/servides_model.dart';
import 'package:joya_app/screens/all_vendors_screen.dart';
import 'package:joya_app/screens/usser_profile_screen.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:joya_app/widgets/admin_link_widget.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? userCountry;
  String? username;

  final servicecontroller = Get.put(ServicesController());
  final TextEditingController searchController = TextEditingController();
final PaymentLinkController controller = Get.put(PaymentLinkController());
  @override
  void initState() {
    super.initState();
    loadCountry();
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
                  icon: Icon(Icons.person),
                  title: Text("Profile", style: TextStyle(fontSize: 12.sp)),
                  selectedColor: Colors.white,
                ),
              ],
            ),
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
          SizedBox(height: 12.h),
          buildAdsSection(),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text("Social Links", style: TextStyle(fontSize: 30.sp)),
            )),
          SizedBox(height: 12.h),
          SizedBox(
            width: 500.w,
            height: 60.h,
            child: Obx(() {
              if (controller.paymentLinks.isEmpty) {
                return Center(child: Text("No Social Links"));
              }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.paymentLinks.length,
      itemBuilder: (context, index) {
        final link = controller.paymentLinks[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: SimpleLinkCard(
            imageUrl: link.imageUrl,
            linkText: link.link,
            linkUrl: link.link,
          ),
        );
      },
    );
  }),
),

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
                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w300),
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
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
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
        items: servicecontroller.adsList.map((ad) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
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
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "Services".tr,
            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(height: 8.h),

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
        SizedBox(height: 12.h),

        Obx(() {
          if (servicecontroller.servicesList.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: CircularProgressIndicator(color: primaryColor),
              ),
            );
          }

          final filteredServices = servicecontroller.servicesList.where((item) {
            final query = searchController.text.toLowerCase();
            return item.title.toLowerCase().contains(query);
          }).toList();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredServices.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final item = filteredServices[index];
                return _buildGridItem(item);
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
                Get.to(
                  () => AllVendorsScreen(
                    country: userCountry!,
                    service: item.title,
                  ),
                );
              }
            : null,
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
              ),
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
                Positioned(
                  top: 8.r,
                  right: 8.r,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20.r),
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
      ),
    );
  }
}
