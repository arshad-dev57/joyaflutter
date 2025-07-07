import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/all_vendors_controllers.dart';
import 'package:joya_app/models/vendormodel.dart';
import 'package:joya_app/utils/colors.dart';

class VendorDetailScreen extends StatefulWidget {
  final VendorModel vendor;

  const VendorDetailScreen({super.key, required this.vendor});

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  final AllVendorsController controller = Get.put(AllVendorsController());

  @override
  void initState() {
    super.initState();
    // API call to fetch reviews for this vendor
    controller.getReviews(widget.vendor.id);
  }

  @override
  Widget build(BuildContext context) {
    final vendor = widget.vendor;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
            child: vendor.image != null && vendor.image!.isNotEmpty
                ? Image.network(
                    vendor.image!,
                    width: double.infinity,
                    height: 300.h,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 300.h,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.person, size: 60.sp, color: Colors.grey),
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.grey.shade100.withOpacity(0.5),
                child: BackButton(color: Colors.black),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${vendor.firstname ?? ''} ${vendor.lastname ?? ''}",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          ...List.generate(
                            4,
                            (_) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20.sp,
                            ),
                          ),
                          Icon(Icons.star_half,
                              color: Colors.amber, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            "4.5",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
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
                        children: (vendor.services ?? [])
                            .map(
                              (service) => Chip(
                                backgroundColor: Colors.grey.withOpacity(0.1),
                                label: Text(
                                  service,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 20.h),
                      sectionTitle("vendor_portfolio".tr),
                      SizedBox(height: 8.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          "https://picsum.photos/id/1005/400/300",
                          height: 180.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
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
                            final review = controller.reviewList[index];
                            return buildReviewTile(
                              review.user.id, // User name or ID
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
                          link.name ?? "Unknown",
                          link.url ?? "",
                          link.image,
                        ),
                      ),
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

  Widget buildSocialLink(String platform, String link, String? iconUrl) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage:
            iconUrl != null && iconUrl.isNotEmpty ? NetworkImage(iconUrl) : null,
        backgroundColor: Colors.grey.shade200,
        radius: 20.r,
        child: iconUrl == null || iconUrl.isEmpty
            ? Icon(Icons.public, color: Colors.grey, size: 20.sp)
            : null,
      ),
      title: Text(
        platform,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
      ),
      subtitle: Text(
        link,
        style: TextStyle(fontSize: 12.sp),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 14.sp),
    );
  }

  Widget buildReviewTile(String name, int stars) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
        radius: 20.r,
      ),
      title: Text(
        name,
        style: TextStyle(fontSize: 14.sp),
      ),
      subtitle: Row(
        children: List.generate(
          5,
          (index) => Icon(
            index < stars ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 18.sp,
          ),
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 14.sp),
    );
  }

  Widget buildAddReviewSection(VendorModel vendor) {
    final TextEditingController reviewCtrl = TextEditingController();
    final RxInt selectedStars = 0.obs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          "vendor_add_review_title".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
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
                      ? Icons.star
                      : Icons.star_border,
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
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              onPressed: () {
                print("Review: ${reviewCtrl.text}");
                print("Stars: ${selectedStars.value}");
                controller.addReview(
                  vendorId: vendor.id,
                  comment: reviewCtrl.text,
                  rating: selectedStars.value,
                );
                reviewCtrl.clear();
                selectedStars.value = 0;
              },
              child: controller.reviewloading.value
                  ? CircularProgressIndicator()
                  : Text(
                      "vendor_add_review_submit".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: Colors.black),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.sp),
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
      ),
    );
  }
}
