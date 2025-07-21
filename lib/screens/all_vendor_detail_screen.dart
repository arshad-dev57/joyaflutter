import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/all_vendors_controllers.dart';
import 'package:joya_app/models/vendormodel.dart';
import 'package:joya_app/screens/portfolio_detail_screen.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorDetailScreen extends StatefulWidget {
  final VendorModel vendor;

  const VendorDetailScreen({super.key, required this.vendor});

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  final AllVendorsController controller = Get.put(AllVendorsController());
  String? currentUserId;
  String? currentUserRole;

  @override
  void initState() {
    super.initState();
    loadUser();
    controller.getReviews(widget.vendor.id);
    controller.fetchUserPortfolios();
    controller.fetchLinkedPortfolios(widget.vendor.id);
  }

  void loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('userId')?.trim();
    currentUserRole = prefs.getString('role')?.trim();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final vendor = widget.vendor;
    final vendorId = widget.vendor.createdBy.trim();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          vendor.image != null && vendor.image!.isNotEmpty
              ? SizedBox(
                  height: 320.h,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        vendor.image!,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: 320.h,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: Icon(Icons.person, size: 60.sp, color: Colors.grey),
                ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.black.withOpacity(0.4),
                child: BackButton(
                  style: ButtonStyle(
                    iconSize: WidgetStatePropertyAll(20.sp),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.72,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${vendor.firstname ?? ''} ${vendor.lastname ?? ''}",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          ...List.generate(
                            4,
                            (_) => Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 20.sp,
                            ),
                          ),
                          Icon(
                            Icons.star_half_rounded,
                            color: Colors.amber,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "4.5",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      infoRow(Icons.phone, vendor.phoneNumber ?? ""),
                      infoRow(Icons.email, vendor.email ?? ""),
                      infoRow(Icons.location_on, vendor.country ?? ""),
                      SizedBox(height: 20.h),

                      sectionTitle("vendor_services".tr),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: List.generate(
                          (vendor.services ?? []).length,
                          (index) {
                            final service = vendor.services![index];
                            final List<Color> chipColors = [
                              Colors.blueAccent.withOpacity(0.15),
                              Colors.redAccent.withOpacity(0.15),
                              Colors.greenAccent.withOpacity(0.2),
                            ];
                            final backgroundColor =
                                chipColors[index % chipColors.length];

                            return Chip(
                              backgroundColor: backgroundColor,
                              label: Text(
                                service,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          sectionTitle("vendor_portfolio".tr),
                          if (vendorId == currentUserId &&
                              currentUserRole == "vendor")
                           ElevatedButton.icon(
  onPressed: () {
    showPortfolioPicker(context, vendor.id);
  },
  icon: Icon(Icons.link, size: 12.sp, color: Colors.white),
  label: Text(
    "Link Portfolio".tr,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 8.sp,
      color: Colors.white,
    ),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
    ),
    elevation: 4,
  ),
),

                        ],
                      ),
                      SizedBox(height: 12.h),

                      Obx(() {
                        if (controller.loadingLinkedPortfolios.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (controller.linkedPortfolios.isEmpty) {
                          return Text(
                            "No portfolios linked yet.",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          );
                        }

                        return SizedBox(
                          height: 160.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.linkedPortfolios.length,
                            padding: EdgeInsets.only(left: 4.w),
                            itemBuilder: (context, index) {
                              final p =
                                  controller.linkedPortfolios[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(PortfolioDetailScreen(portfolio: p));
                                },
                                child: Container(
                                  width: 260.w,
                                  margin: EdgeInsets.only(right: 14.w),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(20.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.08),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(20.r),
                                    child: Stack(
                                      children: [
                                        p.images != null &&
                                                p.images.isNotEmpty
                                            ? Image.network(
                                                p.images[0],
                                                width: 260.w,
                                                height: 160.h,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                width: 260.w,
                                                height: 160.h,
                                                color: Colors
                                                    .grey.shade200,
                                                child: Icon(
                                                  Icons.image,
                                                  size: 32.sp,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        Container(
                                          width: 260.w,
                                          height: 160.h,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black
                                                    .withOpacity(0.6),
                                                Colors.transparent,
                                              ],
                                              begin:
                                                  Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 12.w,
                                          bottom: 12.h,
                                          right: 12.w,
                                          child: Text(
                                            p.title ?? "Untitled",
                                            maxLines: 2,
                                            overflow:
                                                TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.4),
                                                  offset: Offset(0, 1),
                                                  blurRadius: 4,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      SizedBox(height: 20.h),

                      sectionTitle("vendor_ratings_reviews".tr),
                      SizedBox(height: 10.h),
                      Obx(() {
                        if (controller.reviewList.isEmpty) {
                          return Text(
                            "No reviews yet.",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.reviewList.length,
                          itemBuilder: (context, index) {
                            final review =
                                controller.reviewList[index];
                            return buildReviewTile(
                              review.comment,
                              review.rating,
                            );
                          },
                        );
                      }),
                      buildAddReviewSection(vendor),
                      SizedBox(height: 20.h),

                      sectionTitle("vendor_social_links".tr),
                      ...vendor.urls.map(
                        (link) => buildSocialLink(
                          // link.name ?? "Unknown",
                          // link.url ?? "",
                          link.image,
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: primaryColor.withOpacity(0.8)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        letterSpacing: 0.4,
      ),
    );
  }

  Widget buildReviewTile(String name, int stars) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              "https://i.pravatar.cc/150?img=${name.hashCode % 70}",
            ),
            radius: 22.r,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < stars
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: index < stars
                          ? Colors.amber
                          : Colors.grey.shade300,
                      size: 18.sp,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Great experience! Highly recommended!",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddReviewSection(VendorModel vendor) {
    final TextEditingController reviewCtrl = TextEditingController();
    final RxInt selectedStars = 0.obs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        sectionTitle("vendor_add_review_title".tr),
        SizedBox(height: 10.h),
        TextFormField(
          controller: reviewCtrl,
          maxLines: 3,
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: "vendor_add_review_hint".tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            contentPadding: EdgeInsets.all(12.r),
          ),
        ),
        SizedBox(height: 10.h),
        Obx(
          () => Row(
            children: List.generate(
              5,
              (index) => IconButton(
                icon: Icon(
                  index < selectedStars.value
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: Colors.amber,
                  size: 24.sp,
                ),
                onPressed: () {
                  selectedStars.value = index + 1;
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                controller.addReview(
                  vendorId: vendor.id,
                  comment: reviewCtrl.text,
                  rating: selectedStars.value,
                );
                reviewCtrl.clear();
                selectedStars.value = 0;
              },
              child: controller.reviewloading.value
                  ? SizedBox(
                      height: 18.h,
                      width: 18.h,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "vendor_add_review_submit".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSocialLink( String? iconUrl) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(iconUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar("Error", "Could not launch $iconUrl");
        }
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4.h),
        leading: CircleAvatar(
          backgroundImage:
              iconUrl != null && iconUrl.isNotEmpty
                  ? NetworkImage(iconUrl)
                  : null,
          backgroundColor: Colors.grey.shade200,
          radius: 20.r,
          child:
              iconUrl == null || iconUrl.isEmpty
                  ? Icon(Icons.public, color: primaryColor, size: 18.sp)
                  : null,
        ),
        // title: Text(
        //   platform,
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 13.sp,
        //     color: Colors.black87,
        //   ),
        // ),
        // subtitle: GestureDetector(
        //   onTap: () async {
        //     final Uri url = Uri.parse(link);
        //     if (await canLaunchUrl(url)) {
        //       await launchUrl(url, mode: LaunchMode.externalApplication);
        //     } else {
        //       Get.snackbar("Error", "Could not launch $link");
        //     }
        //   },
        //   child: Text(
        //     link,
        //     style: TextStyle(
        //       fontSize: 12.sp,
        //       color: Colors.blue,
        //       decoration: TextDecoration.underline,
        //     ),
        //   ),
        // ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
      ),
    );
  }

  void showPortfolioPicker(BuildContext context, String vendorId) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Obx(() {
          if (controller.loadingPortfolios.value) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.userPortfolios.isEmpty) {
            return Text("No portfolios found.");
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Portfolio to Link",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.userPortfolios.length,
                    itemBuilder: (context, index) {
                      final portfolio =
                          controller.userPortfolios[index];
                      return ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.h),
                        leading: portfolio["images"] != null &&
                                (portfolio["images"] as List).isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.network(
                                  portfolio["images"][0],
                                  width: 50.w,
                                  height: 50.w,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.photo, size: 32.sp),
                        title: Text(
                          portfolio["title"] ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        subtitle: Text(
                          portfolio["description"] ?? "",
                          style: TextStyle(
                              fontSize: 12.sp, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing:
                            Icon(Icons.arrow_forward_ios, size: 14.sp),
                        onTap: () {
                          final portfolioId = portfolio["id"];
                          controller.linkPortfolioToVendor(
                            portfolioId: portfolioId,
                            vendorId: widget.vendor.id,
                          );
                          Get.back();
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          }
        }),
      ),
      isScrollControlled: true,
    );
  }
}
