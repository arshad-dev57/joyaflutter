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
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

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
      backgroundColor: backgroungcolor,
      appBar: AppBar(
        backgroundColor: backgroungcolor,
        title: Text(
          "Vendors".tr,
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Colors.black,
            letterSpacing: 1.2,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset("assets/Arrow.svg", ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          children: [
            Row(
              
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child:Container(
  height: 40.h,
  child: TextField(
    controller: controller.searchController,
    onChanged: (value) => controller.filterVendors(value),
    decoration: InputDecoration(
      isDense: true, // removes internal padding
      hintText: "Search".tr,
      hintStyle: TextStyle(
        color: const Color.fromRGBO(189, 189, 189, 1),
        fontSize: 14.sp,
      ),
      prefixIconConstraints: BoxConstraints(
        minWidth: 0,
        minHeight: 0,
      ),
      prefixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 12), // minimal spacing from border
          SvgPicture.asset(
            "assets/Magnifer.svg",
            height: 32.h,
            width: 32.w,
            fit: BoxFit.contain,
          ),
        ],
      ),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
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
)


                  ),
                ),
                
                SizedBox(width: 4.w),
                if (currentUserRole != "user")
                  InkWell(
                    onTap: () {
                      Get.dialog(AddVendorDialog());
                    },

                    child: Container(
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                       color: primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 6.w),
                          Text(
                            "Add".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.add, color: Colors.white, size: 16.w),
                        ],
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(height: 16.h),

            Expanded(
              child: Obx(() {
                if (controller.isLoadingVendors.value) {
                  return Center(child: buildVendorCardShimmer());
                }

                if (controller.vendors.isEmpty) {
                  return Center(
                    child: Text(
                      "No vendors found.".tr,
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
      Padding(
        padding:  EdgeInsets.symmetric(horizontal: 8.w),
        child: Container(
          decoration: BoxDecoration(
            color: backgroungcolor,
            borderRadius: BorderRadius.circular(20.r),
           border: Border.all(color: Colors.grey.shade400),
           
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (vendor.image != null && vendor.image!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  child: _buildVendorImage(vendor.image!),
                ),
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: List.generate(vendor.services.length, (index) {
                        final service = vendor.services[index];
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            service,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                    Text(                        "${vendor.firstname} ${vendor.lastname}",
 style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),),
                    SizedBox(height: 14.h),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Flexible(
      flex: 1,
      child: _infoRow("assets/phone.svg", vendor.phoneNumber),
    ),
    SizedBox(width: 8.w),
    Flexible(
      flex: 1,
      child: _infoRow("assets/newlocation.svg", vendor.country),
    ),
    SizedBox(width: 8.w),
    Flexible(
      flex: 1,
      child: _infoRow("assets/newmail.svg", vendor.email),
    ),
  ],
),


                    SizedBox(height: 14.h),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: vendor.urls.map((urlModel) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(urlModel.image,
                              height: 20.h,
                              width: 20.w,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              },
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                      : null,
                                );
                              },
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 80,
decoration: BoxDecoration(
  border: Border.all(color: primaryColor),
  borderRadius: BorderRadius.circular(10.r),
),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("view_more".tr,style: TextStyle(color: Colors.black,fontSize: 8.sp),),
                                  SvgPicture.asset("assets/forward.svg", colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn), height: 8.h),
                                ],
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    ),
        
                    SizedBox(height: 14.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      if (vendor.createdBy == currentUserId && currentUserRole != "user")
      Positioned(
  top: 10.r,
  right: 14.r,
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
        color: primaryColor.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SizedBox(
          height: 16.h,  // ✅ control icon size here
          width: 16.w,
          child: SvgPicture.asset(
            "assets/edit.svg",
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
          ),
        ),
      ),
    ),
  ),
),

    ],
  );
}

Widget _infoRow(String icon, String value) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SvgPicture.asset(icon, height: 14.sp),
      SizedBox(width: 4.w),
      Flexible(
        child: Text(
          value,
          style: TextStyle(fontSize: 11.sp, color: Colors.black),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
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
        height: 214.h,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholderBuilder: (context) => Container(
          height: 214.h,
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
        height: 214.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 214.h,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            height: 214.h,
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
  Widget buildVendorCardShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 150.h,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 14.h),

          // Name & Category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 14.h,
                width: 120.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              Container(
                height: 22.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Phone, Country, Email Rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: 10.h, width: 60.w, color: Colors.white),
              Container(height: 10.h, width: 50.w, color: Colors.white),
              Container(height: 10.h, width: 80.w, color: Colors.white),
            ],
          ),
          SizedBox(height: 16.h),

          // Bottom row (icon + button)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 12.r,
                backgroundColor: Colors.white,
              ),
              Container(
                height: 30.h,
                width: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: Colors.white),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


}
