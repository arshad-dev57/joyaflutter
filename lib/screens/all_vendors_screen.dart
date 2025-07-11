import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/all_vendors_controllers.dart';
import 'package:joya_app/models/vendormodel.dart';
import 'package:joya_app/screens/all_vendor_detail_screen.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:joya_app/widgets/add_vendor_dialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllVendorsScreen extends StatefulWidget {
  final String country;
  final String service;

  const AllVendorsScreen({
    super.key,
    required this.country,
    required this.service,
  });

  @override
  State<AllVendorsScreen> createState() => _AllVendorsScreenState();
}

class _AllVendorsScreenState extends State<AllVendorsScreen> {
  String? currentUserRole;
  String? vendorId;
  String? currentUserId;
  final AllVendorsController controller = Get.put(AllVendorsController());

  @override
  void initState() {
    super.initState();
    loadUserRole();
    controller.fetchVendors(
      country: widget.country,
      service: widget.service,
    );
  }

  Future<void> loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserRole = prefs.getString('role')?.trim();
    // vendorId = prefs.getString('vendorId')?.trim();
      currentUserId = prefs.getString('userId')?.trim();
      print("[DEBUG] Current User Role: $currentUserRole");
      // print()
      // print("[DEBUG] Vendor ID: $vendorId");
      print("[DEBUG] Current User ID: $currentUserId");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 4,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          "Vendors",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
          onPressed: () => Get.back(),
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
                    decoration: inputDecoration(primaryColor, context).copyWith(
                      hintText: "Search vendors...",
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20.sp),
                    ),
                    onFieldSubmitted: (value) {
                      controller.fetchVendors(
                        country: widget.country,
                        service: value,
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                if (currentUserRole != "user")
                  InkWell(
                    onTap: () {
                      Get.dialog(AddVendorDialog());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.7),
                            primaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, size: 18.sp, color: Colors.white),
                          SizedBox(width: 6.w),
                          Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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
  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Overlay and Name
            if (vendor.image != null && vendor.image!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                child: Stack(
                  children: [
                    _buildVendorImage(vendor.image!),
                    Container(
                      height: 160.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.45),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12.w,
                      bottom: 12.h,
                      child: Text(
                        "${vendor.firstname} ${vendor.lastname}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 4,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

            // Info Section
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(Icons.phone, vendor.phoneNumber),
                  SizedBox(height: 8.h),
                  _infoRow(Icons.email, vendor.email),
                  SizedBox(height: 8.h),
                  _infoRow(Icons.location_on, vendor.country),
                  SizedBox(height: 14.h),
                Wrap(
  spacing: 8.w,
  runSpacing: 6.h,
  children: List.generate(vendor.services.length, (index) {
    final service = vendor.services[index];
    final List<Color> chipColors = [
      Colors.blueAccent.withValues(alpha: 0.15),
      Colors.redAccent.withValues(alpha: 0.15),
      Colors.greenAccent.withValues(alpha: 0.2),
    ];
    final backgroundColor = chipColors[index % chipColors.length];

    return Chip(
      label: Text(
        service,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: backgroundColor,
      shape: StadiumBorder(),
    );
  }),
),

                ],
              ),
            ),
          ],
        ),
      ),

  if (vendor.createdBy == currentUserId && currentUserRole != "user")
  Positioned(
    top: 10.r,
    right: 10.r,
    child: InkWell(
      onTap: () {
        Get.dialog(
          AddVendorDialog(
            vendor: vendor,
            isEdit: true,
          ),
        );
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        height: 36.r,
        width: 36.r,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Icon(Icons.edit, color: primaryColor, size: 18.sp),
      ),
    ),
  ),

    ],
  );
}


 Widget _infoRow(IconData icon, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 18.sp, color: Colors.grey.shade600),
      SizedBox(width: 8.w),
      Expanded(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 13.5.sp,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}


  Widget _buildVendorImage(String url) {
    final ext = url.split('.').last.toLowerCase();

    if (ext == 'svg') {
      return SvgPicture.network(
        url,
        height: 160.h,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholderBuilder: (context) => Container(
          height: 160.h,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Image.network(
        url,
        height: 160.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 160.h,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            height: 160.h,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    }
  }

  InputDecoration inputDecoration(Color primaryColor, BuildContext context) =>
      InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
