import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              InkWell(onTap: () => Get.back(), child: SvgPicture.asset("assets/Arrow.svg", height: 32.h)),
              SizedBox(height: 12.h),
              vendor.image != null && vendor.image!.isNotEmpty
              ? ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: SizedBox(
                    height: 230.h,
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
                  ),
              )
              : Container(
                  height: 320.h,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: Icon(Icons.person, size: 60.sp, color: Colors.grey),
                ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${vendor.firstname ?? ''} ${vendor.lastname ?? ''}",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                   Row(
                children: [
                  ...List.generate(
                    2,
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
                ],
              ),
              SizedBox(height: 8.h),
            
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: infoRow("assets/Hang Up.svg", vendor.phoneNumber ?? "")),
                  Expanded(child: infoRow("assets/location.svg", vendor.country ?? "")),
                  Expanded(child: infoRow("assets/letter.svg", vendor.email ?? "")),
                
                ],
              ),
              // SizedBox(height: 20.h),
                
              // sectionTitle("vendor_services".tr),
              // SizedBox(height: 8.h),
              // Wrap(
              //   spacing: 8.w,
              //   runSpacing: 8.h,
              //   children: List.generate(
              //     (vendor.services ?? []).length,
              //     (index) {
              //       final service = vendor.services![index];
              //       final List<Color> chipColors = [
              //         Colors.blueAccent.withOpacity(0.15),
              //         Colors.redAccent.withOpacity(0.15),
              //         Colors.greenAccent.withOpacity(0.2),
              //       ];
              //       final backgroundColor =
              //           chipColors[index % chipColors.length];
                
              //       return Chip(
              //         backgroundColor: backgroundColor,
              //         label: Text(
              //           service,
              //           style: TextStyle(
              //             color: Colors.black87,
              //             fontWeight: FontWeight.bold,
              //             fontSize: 12.sp,
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              SizedBox(height: 8.h),
                
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
                          width: 320.w,
                          margin: EdgeInsets.only(right: 14.w),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(12.r),
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
                                BorderRadius.circular(12.r),
                            child: Stack(
                              children: [
                                p.images != null &&
                                        p.images.isNotEmpty
                                    ? Image.network(
                                        p.images[0],
                                        width: 320.w,
                                        height: 160.h,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 330.w,
                                        height: 180.h,
                                        color: Colors
                                            .grey.shade200,
                                        child: Icon(
                                          Icons.image,
                                          size: 32.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                Container(
                                  height: 160.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black
                                            .withValues(alpha: 0.6),
                                        Colors.transparent,
                                      ],
                                      begin:
                                          Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                                Positioned(
              top: 12.h,
              left: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
          p.title ?? "Untitled",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 8.sp,
          ),
                ),
              ),
                ),
                Positioned(
              bottom: 12.h,
              right: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
          "View more".tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 8.sp,
          ),
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
                    "No reviews yet.".tr,
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
                      review.user.email,
                      review.rating,
                      review.comment,
                    );
                  },
                );
              }),
              buildAddReviewSection(vendor),
              SizedBox(height: 20.h),
                
              sectionTitle("vendor_social_links".tr),
              SizedBox(height:6.h),
              SizedBox(
              height: 50.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: vendor.urls
            .map((link) => buildSocialLink(link))
            .toList(),
              ),
                ),
                
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

 Widget infoRow(String icon, String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Row(
      children: [
        SvgPicture.asset(icon, width: 18.sp, height: 18.sp, colorFilter: ColorFilter.mode(primaryColor.withValues(alpha: 0.8), BlendMode.srcIn)),
        SizedBox(width: 8.w),
        Flexible( // <- this is safer
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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
        color: Colors.black,
      ),
    );
  }

 Widget buildReviewTile(String name, int stars, String comment) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.h),
    padding: EdgeInsets.all(14.r),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: Colors.grey.shade200, width: 1.2),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            "https://i.pravatar.cc/150?img=${name.hashCode % 70}",
          ),
          radius: 24.r,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name + Stars Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Icon(
                          index < stars
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: index < stars
                              ? Colors.amber
                              : Colors.grey.shade300,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Comment
              Text(
                comment,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade800,
                  height: 1.4,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            sectionTitle("vendor_add_review_title".tr),
            SizedBox(width: 10.w),
 Obx(
  () => Row(
    children: List.generate(
      5,
      (index) => IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        icon: Icon(
          index < selectedStars.value
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          color: Colors.amber,
          size: 16.sp,
        ),
        onPressed: () {
          selectedStars.value = index + 1;
        },
      ),
    ),
  ),
),

          ],
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: reviewCtrl,
          maxLines: 6,
          style: TextStyle(fontSize: 10.sp),
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
          () => Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 100.w,
              height: 30.h,
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
        ),
      ],
    );
  }
Widget buildSocialLink(SocialLink link) {
  final imageUrl = link.image ?? '';
  final linkUrl = link.url ?? '';

  return GestureDetector(
    onTap: () async {
      final Uri uri = Uri.parse(linkUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not launch $linkUrl");
      }
    },
    child: Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: CircleAvatar(
        radius: 20.r,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
        child: imageUrl.isEmpty
            ? Icon(Icons.public, color: primaryColor, size: 18.sp)
            : null,
      ),
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
