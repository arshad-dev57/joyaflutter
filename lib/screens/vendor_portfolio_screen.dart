import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/po4rtfolio_controller.dart';
import 'package:joya_app/controllers/services_controller.dart';
import 'package:joya_app/models/portfolio_model.dart';
import 'package:joya_app/screens/portfolio_detail_screen.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:joya_app/widgets/portfolio_dialogue.dart';
import 'package:joya_app/widgets/shimmer.dart';

class VendorPortfolioScreen extends StatefulWidget {
  VendorPortfolioScreen({super.key});

  @override
  State<VendorPortfolioScreen> createState() => _VendorPortfolioScreenState();
}

class _VendorPortfolioScreenState extends State<VendorPortfolioScreen> {
  final PortfolioController portfolioController = Get.put(PortfolioController());
  final ServicesController servicesController = Get.put(ServicesController());

  @override
  void initState() {
    super.initState();

    ever(
      servicesController.selectedServiceName,
      (serviceName) {
        if (serviceName.isNotEmpty) {
          portfolioController.getPortfolios(serviceName);
        }
      },
    );

    if (servicesController.selectedServiceName.value.isNotEmpty) {
      portfolioController.getPortfolios(
        servicesController.selectedServiceName.value,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroungcolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: backgroungcolor,
        centerTitle: true,
        title: Text(
          "Vendor Portfolios".tr,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.h,
                    child: TextFormField(
                        decoration: InputDecoration(
      hintText: "Search".tr,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 12.sp,
      ),
      prefixIcon: SvgPicture.asset(
        "assets/Magnifer.svg",
        height: 40.h,
        width: 40.w,
        fit: BoxFit.contain,
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
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () {
                    Get.dialog(AddPortfolioDialog());
                  },
                  child: Container(
                    height: 40.h,
                    width: 70.w,
                    // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        color: primaryColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 4.w),
                        Text(
                          "Add Work +".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: Obx(() {
            return Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300, width: 1),
                color: backgroungcolor, // soft pastel background
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
          isExpanded: true,
          icon: SvgPicture.asset("assets/down.svg", height: 10.h, width: 10.w, colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
          dropdownColor: backgroungcolor,
          hint: Text(
            "Category",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade200,
            ),
          ),
          value: servicesController.selectedServiceName.value.isEmpty
              ? null
              : servicesController.selectedServiceName.value,
          items: servicesController.serviceNames.map((s) {
            return DropdownMenuItem<String>(
              value: s,
              child: Text(
                s,
                style: TextStyle(fontSize: 12.sp),
              ),
            );
          }).toList(),
          onChanged: (val) {
            servicesController.selectedServiceName.value = val ?? '';
            if (val != null && val.isNotEmpty) {
              portfolioController.getPortfolios(val);
            } else {
              portfolioController.portfolioList.clear();
            }
          },
                ),
              ),
            );
          }),
        ),
          SizedBox(height: 12.h),

          Expanded(
            child: Obx(() {
              if (portfolioController.portfolioloading.value) {
                return Center(child: buildShimmerItem());
              } else if (portfolioController.portfolioList.isEmpty) {
                return Center(
                  child: Text(
                    "No portfolios found",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: portfolioController.portfolioList.length,
                  itemBuilder: (context, index) {
                    final item = portfolioController.portfolioList[index];
                    return InkWell(
                      onTap: () {
                        Get.to(PortfolioDetailScreen(
                          portfolio: item,
                        ));
                      },
                      child: _buildPortfolioCard(item),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioCard(PortfolioModel item) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: backgroungcolor,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.images.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
              child: Image.network(
                item.images.first,
                height: 210.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height:8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  if (item.services.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: List.generate(item.services.length, (index) {
                      final s = item.services[index];
                              
                      
                      final color = primaryColor;
                              
                      return Chip(
                        label: Text(
                          s,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                          ),
                        ),
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      );
                    }),
                  ),
                ],
              ),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  item.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12.sp,
                  ),
                ),
            
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 30.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: backgroungcolor,
                      border: Border.all(color: primaryColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_forward, color: Colors.grey.shade700, size: 16.sp),
                        Text(
                          "View more".tr,
                          style: TextStyle(
                            fontSize: 6.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            
           
            
            
               
            
                SizedBox(height: 12.h),
            
               
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: primaryColor),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$title: ",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.normal,
                      fontSize: 13.sp,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  InputDecoration inputDecoration(Color primaryColor, BuildContext context) =>
      InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14.sp,
        ),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      );
}
