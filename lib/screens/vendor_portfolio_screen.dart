import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/po4rtfolio_controller.dart';
import 'package:joya_app/models/portfolio_model.dart';
import 'package:joya_app/screens/portfolio_detail_screen.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:joya_app/widgets/portfolio_dialogue.dart';
import 'package:joya_app/widgets/shimmer.dart';

class VendorPortfolioScreen extends StatelessWidget {
  final PortfolioController portfolioController = Get.put(PortfolioController());

  VendorPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure API load happens only once
    Future.delayed(Duration.zero, () {
      if (portfolioController.portfolioList.isEmpty) {
        portfolioController.getPortfolios();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "vendor_portfolio_title".tr,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Row(
            children: [
              SizedBox(width: 8.w),
              Expanded(
                child: TextFormField(
                  decoration: inputDecoration(primaryColor, context).copyWith(
                    hintText: 'vendor_portfolio_search'.tr,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: InkWell(
                  onTap: () {
                    Get.dialog(AddPortfolioDialog());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      color: Colors.grey.shade100.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        "vendor_portfolio_add".tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: Obx(() {
              if (portfolioController.portfolioloading.value) {
                return Center(child: buildShimmerItem());
              } else if (portfolioController.portfolioList.isEmpty) {
                return Center(child: Text("No portfolios found"));
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: portfolioController.portfolioList.length,
                  itemBuilder: (context, index) {
                    final item = portfolioController.portfolioList[index];
                    return InkWell(
                      onTap: (){
                        Get.to(PortfolioDetailScreen(portfolio: item,));
                      },
                      child: _buildPortfolioCard(item));
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
  final PageController pageController = PageController();

  return Container(
    margin: EdgeInsets.only(bottom: 16.h),
    padding: EdgeInsets.all(12.r),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 8,
          offset: Offset(0, 4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Text(item.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: Colors.black87,
            )),
        SizedBox(height: 6.h),

        /// Description
        Text(item.description,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700)),
        SizedBox(height: 10.h),

        /// Image Slider
        if (item.images.isNotEmpty)
          SizedBox(
            height: 180.h,
            child: PageView.builder(
              controller: pageController,
              itemCount: item.images.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    item.images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                  ),
                );
              },
            ),
          ),

        SizedBox(height: 10.h),

        /// Services
        if (item.services.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: item.services
                .map((s) => Chip(
                      label: Text(s),
                      backgroundColor: Colors.blue.shade50,
                      labelStyle: TextStyle(color: Colors.blue),
                    ))
                .toList(),
          ),

        SizedBox(height: 10.h),

        /// Location, Duration, Client Type
        _infoRow("Location", item.location),
        _infoRow("Duration", item.duration),
        _infoRow("Client Type", item.clientType),

        /// Price Range
        _infoRow("Price Range", item.priceRange),

        /// Tags
        if (item.tags != null && item.tags!.isNotEmpty)
          _infoRow("Tags", item.tags!.join(', ')),

        /// Ratings
        if (item.ratings != null)
          Row(
            children: [
              Icon(Icons.star, color: Colors.orange, size: 18.sp),
              SizedBox(width: 4.w),
              Text("${item.ratings}", style: TextStyle(fontSize: 14.sp)),
            ],
          ),

        /// Testimonials
        if (item.testimonials != null && item.testimonials!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text("Testimonials:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...item.testimonials!.map((t) => Text("- $t")),
            ],
          ),

        SizedBox(height: 10.h),

        /// Created Date
        Text("Created on: ${item.createdAt.toLocal().toString().split(' ')[0]}",
            style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
      ],
    ),
  );
}

Widget _infoRow(String title, String? value) {
  if (value == null || value.isEmpty) return SizedBox.shrink();
  return Padding(
    padding: EdgeInsets.only(top: 4.h),
    child: Row(
      children: [
        Text("$title: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
        Expanded(child: Text(value, style: TextStyle(fontSize: 13.sp))),
      ],
    ),
  );
}

  InputDecoration inputDecoration(Color primaryColor, BuildContext context) =>
      InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
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
