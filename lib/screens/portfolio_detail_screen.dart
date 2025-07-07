import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joya_app/models/portfolio_model.dart';
import 'package:joya_app/utils/colors.dart';

class PortfolioDetailScreen extends StatelessWidget {
  final PortfolioModel portfolio;

  const PortfolioDetailScreen({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Top Image
          portfolio.images.isNotEmpty
              ? Image.network(
                  portfolio.images.first,
                  height: 300.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 300.h,
                  color: Colors.grey.shade300,
                  child: Center(child: Icon(Icons.image, size: 80.sp)),
                ),

          /// Back Button
          Positioned(
            top: 40.h,
            left: 16.w,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.4),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          /// Bottom Container
          Positioned(
            top: 260.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      portfolio.title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    /// Description
                    Text(
                      portfolio.description,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
                    ),

                    SizedBox(height: 16.h),

                    /// Services
                    if (portfolio.services.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: portfolio.services.map((s) {
                          return Chip(
                            label: Text(s),
                            backgroundColor: primaryColor.withOpacity(0.1),
                            labelStyle: TextStyle(color: primaryColor),
                          );
                        }).toList(),
                      ),

                    SizedBox(height: 16.h),

                    /// Info Rows
                    _infoRow("Location", portfolio.location),
                    _infoRow("Duration", portfolio.duration),
                    _infoRow("Client Type", portfolio.clientType),
                    _infoRow("Price Range", portfolio.priceRange),
                    if (portfolio.tags != null && portfolio.tags!.isNotEmpty)
                      _infoRow("Tags", portfolio.tags!.join(', ')),

                    SizedBox(height: 10.h),

                    /// Ratings
                    if (portfolio.ratings != null)
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange),
                          SizedBox(width: 6.w),
                          Text("${portfolio.ratings}", style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),

                    SizedBox(height: 16.h),

                    /// Testimonials
                    if (portfolio.testimonials != null && portfolio.testimonials!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Testimonials", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 6.h),
                          ...portfolio.testimonials!.map((t) => Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: Text("- $t"),
                              )),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value ?? "")),
        ],
      ),
    );
  }
}
