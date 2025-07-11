import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/all_vendors_controllers.dart';
import 'package:joya_app/models/vendormodel.dart';
import 'package:joya_app/screens/all_vendor_detail_screen.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:joya_app/widgets/add_vendor_dialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class adminallvendorsscreen extends StatefulWidget {
  const adminallvendorsscreen({super.key});

  @override
  State<adminallvendorsscreen> createState() => _adminallvendorsscreenState();
}

class _adminallvendorsscreenState extends State<adminallvendorsscreen> {
  String? currentUserRole;

  final AllVendorsController controller = Get.put(AllVendorsController());

  @override
  void initState() {
    super.initState();
    loadUserRole();
    controller.fetchAllVendors();
    print("fetched 231");
  }

  Future<void> loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserRole = prefs.getString('role')?.trim();
    print("current user role => `$currentUserRole`");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Vendors".tr,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: inputDecoration(
                      primaryColor,
                      context,
                    ).copyWith(
                      hintText: "Search vendors...",
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20.sp),
                    ),
                    onFieldSubmitted: (value) {
                      controller.fetchVendors(
                        country: "Pakistan",
                        service: value,
                      );
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.dialog(AddVendorDialog());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: Icon(Icons.add, size: 18.sp, color: Colors.white),
                  label: Text(
                    "Add",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            /// Vendors List
            Expanded(
              child: Obx(() {
                if (controller.isLoadingVendors.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.vendors.isEmpty) {
                  return Center(
                    child: Text(
                      "No vendors found.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: controller.vendors.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final vendor = controller.vendors[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() => VendorDetailScreen(vendor: vendor));
                      },
                      child: _buildVendorCard(vendor),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorCard(VendorModel vendor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Vendor image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              bottomLeft: Radius.circular(16.r),
            ),
            child: vendor.image != null && vendor.image!.isNotEmpty
                ? Image.network(
                    vendor.image!,
                    height: 120.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 120.h,
                    width: 100.w,
                    color: Colors.grey.shade200,
                    child: Icon(Icons.person, size: 40.sp, color: Colors.grey),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${vendor.firstname} ${vendor.lastname}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey.shade600, size: 16.sp),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          vendor.phoneNumber,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.grey.shade600, size: 16.sp),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          vendor.email,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.grey.shade600, size: 16.sp),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          vendor.country,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: vendor.services
                        .map(
                          (service) => Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              service,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  InputDecoration inputDecoration(Color primaryColor, BuildContext context) =>
      InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primaryColor, width: 1.5.w),
        ),
      );
}
