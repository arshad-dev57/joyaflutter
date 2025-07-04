import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
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

  final List<String> carouselImages = [
    'https://picsum.photos/id/1018/800/400',
    'https://picsum.photos/id/1023/800/400',
    'https://picsum.photos/id/1025/800/400',
  ];
  String? userCountry;

  final List<GridItem> gridItems = [
    GridItem(
      title: "photography".tr,
      imageUrl: "https://picsum.photos/id/100/400/400",
    ),
    GridItem(
      title: "event_planning".tr,
      imageUrl: "https://picsum.photos/id/101/400/400",
    ),
    GridItem(
      title: "designer".tr,
      imageUrl: "https://picsum.photos/id/102/400/400",
    ),
    GridItem(
      title: "catering".tr,
      imageUrl: "https://picsum.photos/id/103/400/400",
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
Future<void> loadCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? countries = prefs.getString('country');

    if (countries != null && countries.isNotEmpty) {
      setState(() {
        userCountry = countries;
      });
    } else {
      setState(() {
        userCountry = 'Unknown';
      });
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCountry();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: _selectedIndex == 0 ? buildHomeContent() : UserProfileScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8.r,
              offset: Offset(0, -4.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
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
                Text(
                  "joya_app".tr,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
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
              "ads".tr,
              style: TextStyle(
                color: primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          CarouselSlider(
            options: CarouselOptions(
              height: 180.h,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 16 / 9,
              autoPlayInterval: Duration(seconds: 3),
            ),
            items: carouselImages
                .map((url) => ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "services".tr,
              style: TextStyle(
                color: primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.85,
              ),
              itemCount: gridItems.length,
              itemBuilder: (context, index) {
                final item = gridItems[index];
                return _buildGridItem(item);
              },
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildGridItem(GridItem item) {
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
