import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/all_vendors_controllers.dart';
import 'package:joya_app/controllers/services_controller.dart';
import 'package:joya_app/models/vendormodel.dart';
import 'package:joya_app/utils/colors.dart';

class AddVendorDialog extends GetView<AllVendorsController> {
  final VendorModel? vendor;
  final bool isEdit;

  AddVendorDialog({
    super.key,
    this.vendor,
    this.isEdit = false,
  });

  @override
  final AllVendorsController controller = Get.put(AllVendorsController());
  final ServicesController serviceController = Get.put(ServicesController());

  @override
  Widget build(BuildContext context) {
    if (isEdit && vendor != null) {
      controller.firstNameCtrl.text = vendor!.firstname;
      controller.lastNameCtrl.text = vendor!.lastname;
      controller.usernameCtrl.text = vendor!.username;
      controller.emailCtrl.text = vendor!.email;
      controller.phoneCtrl.text = vendor!.phoneNumber;
      controller.codeCtrl.text = vendor!.code;
      controller.countryCtrl.text = vendor!.country;
      controller.descriptionCtrl.text = vendor!.description ?? "";
      serviceController.selectedServiceNames.assignAll(vendor!.services);
      controller.urlLinks.assignAll(
        vendor!.urls.map((e) => {
          "name": e.name,
          "url": e.url,
          "image": e.image,
          "_id": e.id,
        }).toList(),
      );
    }
    return Obx(() {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SizedBox(
          height: 0.85.sh,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEdit ? "Edit Vendor" : "Add Vendor",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        buildTextField(controller.firstNameCtrl, "First Name *", "Enter First Name"),
                        buildTextField(controller.lastNameCtrl, "Last Name", "Enter Last Name"),
                        buildTextField(controller.usernameCtrl, "UserName *", "Enter UserName"),
                        buildTextField(controller.emailCtrl, "Email *", "Enter Email", keyboardType: TextInputType.emailAddress),
                        buildTextField(controller.phoneCtrl, "Phone *", "Enter Phone", keyboardType: TextInputType.phone),
                        buildTextField(controller.codeCtrl, "Code *", "Enter Code"),
                        buildTextField(controller.passwordCtrl, "Password *", "Enter Password", keyboardType: TextInputType.visiblePassword),

                        Text(
                          "Country *",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        DropdownButtonFormField<String>(
                          value: controller.countryCtrl.text.isEmpty
                              ? null
                              : controller.countryCtrl.text,
                          decoration: inputDecoration(primaryColor, context),
                          hint: Text("Select Country", style: TextStyle(fontSize: 14.sp)),
                          items: ['Pakistan', 'Saudi Arabia', 'UAE', 'Egypt', 'Qatar']
                              .map((country) => DropdownMenuItem(
                                    value: country,
                                    child: Text(country),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            controller.countryCtrl.text = val!;
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) return "Country is required";
                            return null;
                          },
                        ),

                        SizedBox(height: 12.h),
                        Text(
                          "Service Categories *",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Obx(() {
                          if (serviceController.isLoading.value) {
                            return Container(
                              height: 50.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 10.w,
                                  runSpacing: 10.h,
                                  children: serviceController.serviceNames.map((service) {
                                    final isSelected = serviceController.selectedServiceNames.contains(service);
                                    return FilterChip(
                                      selected: isSelected,
                                      label: Text(service),
                                      selectedColor: primaryColor,
                                      backgroundColor: Colors.grey.shade200,
                                      labelStyle: TextStyle(
                                        color: isSelected ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                      ),
                                      onSelected: (bool selected) {
                                        if (selected) {
                                          serviceController.selectedServiceNames.add(service);
                                        } else {
                                          serviceController.selectedServiceNames.remove(service);
                                        }
                                      },
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 8.h),
                                Obx(() {
                                  if (serviceController.selectedServiceNames.isEmpty) {
                                    return Padding(
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: Text(
                                        "At least one service is required",
                                        style: TextStyle(color: Colors.red, fontSize: 12.sp),
                                      ),
                                    );
                                  }
                                  return SizedBox.shrink();
                                }),
                              ],
                            );
                          }
                        }),

                        SizedBox(height: 12.h),

                        /// Language
                        Text(
                          "Language *",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(child: langButton("English")),
                            SizedBox(width: 10.w),
                            Expanded(child: langButton("عربي")),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        /// Role
                        Text(
                          "Role *",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        DropdownButtonFormField<String>(
                          value: controller.role.value,
                          decoration: inputDecoration(primaryColor, context),
                          items: ["Vendor", "Admin", "User"]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e, style: TextStyle(fontSize: 14.sp)),
                                  ))
                              .toList(),
                          onChanged: (val) => controller.role.value = val!,
                        ),

                        SizedBox(height: 16.h),

                        buildTextField(controller.descriptionCtrl, "Description", "Enter Description", maxLines: 3),

                        SizedBox(height: 12.h),

                        /// Vendor Image
                        Text(
                          "Image *",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: controller.pickImage,
                          child: Obx(() {
                            if (controller.imageFile.value != null) {
                              return Container(
                                height: 120.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.file(
                                    controller.imageFile.value!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              );
                            } else if (vendor?.image?.isNotEmpty == true) {
                              return Container(
                                height: 120.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.network(
                                    vendor!.image!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) =>
                                        Icon(Icons.broken_image, size: 40.sp, color: Colors.grey),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                height: 120.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Icon(Icons.camera_alt, size: 30.sp, color: Colors.grey),
                              );
                            }
                          }),
                        ),

                        SizedBox(height: 16.h),

                        /// Social link section
                        Text(
                          "Add Social Link",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        GestureDetector(
                          onTap: controller.pickSocialIconImage,
                          child: Obx(() => Container(
                                height: 80.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: controller.socialImageFile.value == null
                                    ? Icon(Icons.camera_alt, size: 30.sp, color: Colors.grey)
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: Image.file(
                                          controller.socialImageFile.value!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                              )),
                        ),

                        SizedBox(height: 10.h),
                        buildTextField(controller.socialNameCtrl, "Social Name", "Enter Social Name"),
                        buildTextField(controller.socialUrlCtrl, "Social URL", "Enter Social URL"),

                        SizedBox(height: 16.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.addSocialLink,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "Add Social Link",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),
                        Obx(() {
                          if (controller.urlLinks.isEmpty) {
                            return Text(
                              "No social links added yet.",
                              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                            );
                          } else {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.urlLinks.length,
                              separatorBuilder: (_, __) => SizedBox(height: 8.h),
                              itemBuilder: (_, index) {
                                var item = controller.urlLinks[index];
                                return socialLinkTile(item, index);
                              },
                            );
                          }
                        }),

                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),

              Obx(
                () => Padding(
                  padding: EdgeInsets.all(16.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                    onPressed: controller.isSubmitting.value
    ? null
    : () {
        if (isEdit && vendor != null) {
          controller.updateVendor(vendor!.id);
        } else {
          controller.submit();
        }
      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: controller.isSubmitting.value
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              isEdit ? "Update Vendor" : "Submit",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildTextField(
    TextEditingController ctrl,
    String label,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (val) {
          if (label.contains("*") && (val == null || val.trim().isEmpty)) {
            return "$label is required";
          }
          return null;
        },
        decoration: inputDecoration(primaryColor, Get.context!).copyWith(
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget langButton(String lang) {
    return Obx(() {
      final selected = controller.language.value == lang;
      return GestureDetector(
        onTap: () {
          controller.language.value = lang;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: selected ? primaryColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: primaryColor),
          ),
          child: Center(
            child: Text(
              lang,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget socialLinkTile(Map<String, dynamic> item, int index) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          if (item["image"]?.isNotEmpty == true)
            _buildImageFromBase64OrUrl(item["image"]!)
          else
            Icon(Icons.link, size: 24.sp, color: primaryColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"] ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: primaryColor,
                  ),
                ),
                Text(
                  item["url"] ?? "",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.urlLinks.removeAt(index);
            },
            child: Icon(Icons.delete, color: Colors.red),
          )
        ],
      ),
    );
  }

  Widget _buildImageFromBase64OrUrl(String imageString) {
    if (imageString.startsWith("http")) {
      return Image.network(
        imageString,
        height: 24.h,
        width: 24.h,
        errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 24.sp),
      );
    } else {
      try {
        final bytes = base64Decode(imageString);
        return Image.memory(
          bytes,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return Icon(Icons.broken_image, size: 24.sp);
      }
    }
  }

  InputDecoration inputDecoration(Color primaryColor, BuildContext context) =>
      InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 4.sp,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
