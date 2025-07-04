import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/po4rtfolio_controller.dart';
import 'package:joya_app/models/portfolio_model.dart';
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
                    return _buildPortfolioCard(item);
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

    return StatefulBuilder(
      builder: (context, setState) {
        int currentPage = 0;

        void goNext() {
          if (currentPage < item.images.length - 1) {
            currentPage++;
            pageController.animateToPage(
              currentPage,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {});
          }
        }

        void goPrev() {
          if (currentPage > 0) {
            currentPage--;
            pageController.animateToPage(
              currentPage,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {});
          }
        }

        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 8.r,
                offset: Offset(0, 4.h),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image slider
              if (item.images.isNotEmpty)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                      child: SizedBox(
                        height: 200.h,
                        width: double.infinity,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: item.images.length,
                          onPageChanged: (index) {
                            currentPage = index;
                            setState(() {});
                          },
                          itemBuilder: (context, index) {
                            return Image.network(
                              item.images[index],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(Icons.broken_image),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    /// Left Button
                    Positioned(
                      left: 10.w,
                      top: 80.h,
                      child: IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                        onPressed: goPrev,
                      ),
                    ),

                    /// Right Button
                    Positioned(
                      right: 10.w,
                      top: 80.h,
                      child: IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                        onPressed: goNext,
                      ),
                    ),

                    /// Page dots
                    Positioned(
                      bottom: 10.h,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          item.images.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == currentPage
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              /// Text
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
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
