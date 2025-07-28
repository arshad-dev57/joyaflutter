import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  TextEditingController searchController = TextEditingController();
  RxList<VendorModel> filteredVendors = <VendorModel>[].obs;

  @override
  void initState() {
    super.initState();
    loadUserRole();
    controller.fetchAllVendors().then((_) {
      filteredVendors.assignAll(controller.vendors);
    });
  }

  Future<void> loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserRole = prefs.getString('role')?.trim();
    setState(() {});
  }

  void _filterVendors(String query) {
    final filtered = controller.vendors.where((vendor) {
      final fullName = "${vendor.firstname} ${vendor.lastname}".toLowerCase();
      final matchesName = fullName.contains(query.toLowerCase());
      final matchesService = vendor.services.any((s) => s.toLowerCase().contains(query.toLowerCase()));
      return matchesName || matchesService;
    }).toList();
    filteredVendors.assignAll(filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroungcolor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset("assets/Arrow.svg", height: 32.h),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "Vendors".tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40.h,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) => _filterVendors(value),
                        decoration: InputDecoration(
                          hintText: "Search".tr,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14.sp,
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: SvgPicture.asset("assets/Magnifer.svg", height: 12.h),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  InkWell(
                    onTap: () {
                      Get.dialog(AddVendorDialog());
                    },
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      height: 40.h,
                      width: 70.w,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add".tr,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12.sp,
                            ),
                          ),
                          Icon(Icons.add, size: 12.sp, color: Colors.white),
                          SizedBox(width: 4.w),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingVendors.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (filteredVendors.isEmpty) {
                  return Center(
                    child: Text(
                      "No vendors found.",
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: filteredVendors.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final vendor = filteredVendors[index];
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
          padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                      Text(
                        "${vendor.firstname} ${vendor.lastname}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoRow("assets/phone.svg", vendor.phoneNumber),
                          _infoRow("assets/newlocation.svg", vendor.country),
                          _infoRow("assets/newmail.svg", vendor.email),
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
                                child: Image.network(
                                  urlModel.image,
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
                                    Text("view_more".tr, style: TextStyle(color: Colors.black, fontSize: 8.sp)),
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
          child: Center(child: CircularProgressIndicator()),
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

  Widget _infoRow(String icon, String value, {Function()? onTap}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(icon, colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn), height: 20.h),
        SizedBox(width: 8.w),
        InkWell(
          onTap: () {
            if (onTap != null) {
              onTap();
            }
          },
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
