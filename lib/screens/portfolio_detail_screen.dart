import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:joya_app/models/portfolio_model.dart';
import 'package:joya_app/utils/colors.dart';
class PortfolioDetailScreen extends StatelessWidget {
  final PortfolioModel portfolio;

  const PortfolioDetailScreen({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroungcolor,
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    InkWell(onTap: () {
                      Get.back();
                    }, child: SvgPicture.asset("assets/Arrow.svg", height: 32.h)),
                    SizedBox(width: 12.w),
                    Text(
                      "Portfolio Details".tr,
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
  child: SizedBox(
    height: 180.h,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: portfolio.images.length,
      separatorBuilder: (context, index) => SizedBox(width: 12.w),
      itemBuilder: (context, index) {
        final imageUrl = portfolio.images[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.network(
            imageUrl,
            width: 300.w,
            height: 180.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 300.w,
              height: 180.h,
              color: Colors.grey.shade300,
              child: Icon(Icons.broken_image, size: 60.sp, color: Colors.grey),
            ),
          ),
        );
      },
    ),
  ),
),

              SizedBox(height: 16.h),
        
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: backgroungcolor,
                   
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                         
                          if (portfolio.services.isNotEmpty)
                            Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                portfolio.services.first,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                        
                      SizedBox(height: 12.h),
                         Text(
                           portfolio.title,
                           style: TextStyle(
                             color: primaryColor,
                             fontSize: 18.sp,
                             fontWeight: FontWeight.w400,
                           ),
                         ),
                                               SizedBox(height: 12.h),

                      // Description
                      if (portfolio.description.isNotEmpty)
                        Text(
                          portfolio.description,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade500,
                            height: 1.5,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
