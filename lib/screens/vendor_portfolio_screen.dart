import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Vendor Portfolios",
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

          /// Search and Add
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.h,
                    child: TextFormField(
                      decoration: inputDecoration(primaryColor, context).copyWith(
                        hintText: 'Search Portfolios',
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20.sp),
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
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor.withOpacity(0.7), primaryColor],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 18.sp, color: Colors.white),
                        SizedBox(width: 4.w),
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
          ),

          SizedBox(height: 16.h),

          /// Dropdown
          Obx(() {
            return Container(
              height: 40.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: DropdownButtonFormField<String>(
                  decoration: inputDecoration(primaryColor, context).copyWith(
                    hintText: "Select Service",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: servicesController.selectedServiceName.value.isEmpty
                      ? null
                      : servicesController.selectedServiceName.value,
                  items: servicesController.serviceNames
                      .map(
                        (s) => DropdownMenuItem<String>(
                          value: s,
                          child: Text(s, style: TextStyle(fontSize: 12.sp)
                          ),
                        ),
                      )
                      .toList(),
                onChanged: (val) {
                servicesController.selectedServiceName.value = val ?? '';
              
                if (val != null && val.isNotEmpty) {
                  portfolioController.getPortfolios(val);
                } else {
                  // Clear the list when empty selected
                  portfolioController.portfolioList.clear();
                }
              }
              
                ),
              ),
            );
          }),

          SizedBox(height: 16.h),

          /// List/Grid
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          /// Image Carousel with overlay gradient
          if (item.images.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Stack(
                children: [
                  Image.network(
                    item.images.first,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12.h,
                    left: 12.w,
                    right: 12.w,
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.7),
                            blurRadius: 6,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Description
                Text(
                  item.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13.sp,
                  ),
                ),

                SizedBox(height: 12.h),

             if (item.services.isNotEmpty)
  Wrap(
    spacing: 8.w,
    runSpacing: 6.h,
    children: List.generate(item.services.length, (index) {
      final s = item.services[index];

      final List<Color> chipColors = [
        Colors.blueAccent,
        Colors.redAccent,
        Colors.yellowAccent,
      ];
      final color = chipColors[index % chipColors.length];

      return Chip(
        label: Text(
          s,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: color.withOpacity(0.1),
        shape: StadiumBorder(),
      );
    }),
  ),

                SizedBox(height: 12.h),

                // Divider(),

                // /// Details
                // _infoRow(Icons.location_on, "Location", item.location),
                // _infoRow(Icons.timer, "Duration", item.duration),
                // _infoRow(Icons.group, "Client Type", item.clientType),

                // if (item.tags != null && item.tags!.isNotEmpty)
                //   _infoRow(Icons.label, "Tags", item.tags!.join(', ')),

                SizedBox(height: 12.h),

                /// Testimonials
                // if (item.testimonials != null &&
                //     item.testimonials!.isNotEmpty)
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         "Testimonials:",
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           color: primaryColor,
                //           fontSize: 14.sp,
                //         ),
                //       ),
                //       SizedBox(height: 8.h),
                //       ...item.testimonials!.map(
                //         (t) => Padding(
                //           padding: EdgeInsets.symmetric(vertical: 2.h),
                //           child: Text(
                //             "• $t",
                //             style: TextStyle(
                //               color: Colors.grey.shade800,
                //               fontSize: 12.sp,
                //               fontStyle: FontStyle.italic,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),

                // SizedBox(height: 12.h),

                // Text(
                //   "Created on: ${item.createdAt.toLocal().toString().split(' ')[0]}",
                //   style: TextStyle(
                //     color: Colors.grey.shade500,
                //     fontSize: 12.sp,
                //   ),
                // )
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
