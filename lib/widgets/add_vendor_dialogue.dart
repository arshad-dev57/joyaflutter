import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
      controller.paymentlinkCtrl.text = vendor!.paymentlink ?? "";
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
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16.w),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: backgroungcolor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SizedBox(
            height: 0.85.sh,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isEdit ? "Edit Vendor".tr : "Add Vendor".tr,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: primaryColor, size: 24.sp),
                                onPressed: () => Get.back(),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          buildTextField("First Name ".tr, controller.firstNameCtrl, inputType: TextInputType.name),
                          buildTextField("Last Name".tr, controller.lastNameCtrl, inputType: TextInputType.name),
                          buildTextField("UserName ".tr, controller.usernameCtrl, inputType: TextInputType.name),
                          buildTextField("email_label".tr, controller.emailCtrl, inputType: TextInputType.emailAddress),
                          buildTextField("phone_label".tr, controller.phoneCtrl, inputType: TextInputType.phone),
                          buildTextField("Code".tr, controller.codeCtrl, inputType: TextInputType.number),
                          buildTextField("Payment Link".tr, controller.paymentlinkCtrl, inputType: TextInputType.url),
                          buildTextField("login_password_label".tr, controller.passwordCtrl, inputType: TextInputType.visiblePassword),

                          // Country
                          Text(
                            "country_label".tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          DropdownButtonFormField<String>(
                            value: controller.countryCtrl.text.isEmpty
                                ? null
                                : controller.countryCtrl.text,
                            decoration: inputDecoration(primaryColor, context),
                            hint: Text("Select Country".tr, style: TextStyle(fontSize: 12.sp)),
                            items: ['Pakistan', 'Saudi Arabia', 'UAE', 'Egypt', 'Qatar']
                                .map((country) => DropdownMenuItem(
                                      value: country,
                                      child: Text(country, style: TextStyle(fontSize: 12.sp)),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              controller.countryCtrl.text = val!;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) return "Country is required".tr;
                              return null;
                            },
                          ),

                          SizedBox(height: 12.h),

                          /// Service Categories
                          Text(
                            "edit_service_category".tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Obx(() {
                            if (serviceController.isLoading.value) {
                              return Container(
                                height: 50.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
                                  border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
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
                              return Wrap(
                                spacing: 8.w,
                                runSpacing: 8.h,
                                children: serviceController.serviceNames.map((service) {
                                  final isSelected = serviceController.selectedServiceNames.contains(service);
                                  return ChoiceChip(
                                    checkmarkColor: Colors.white,
                                    label: Text(
                                      service,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: isSelected ? Colors.white : primaryColor,
                                      ),
                                    ),
                                    selected: isSelected,
                                    selectedColor: primaryColor,
                                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color: isSelected ? primaryColor : Colors.grey.shade300,
                                      ),
                                    ),
                                    onSelected: (val) {
                                      if (val) {
                                        serviceController.selectedServiceNames.add(service);
                                      } else {
                                        serviceController.selectedServiceNames.remove(service);
                                      }
                                    },
                                  );
                                }).toList(),
                              );
                            }
                          }),

                          SizedBox(height: 12.h),

                          Text(
                            "Language".tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Expanded(child: langButton("English")),
                              SizedBox(width: 8.w),
                              Expanded(child: langButton("عربي")),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          Text(
                            "Role".tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          DropdownButtonFormField<String>(
                            value: controller.role.value,
                            decoration: inputDecoration(primaryColor, context),
                            items: ["Vendor", "Admin", "User"]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e, style: TextStyle(fontSize: 12.sp)),
                                    ))
                                .toList(),
                            onChanged: (val) => controller.role.value = val!,
                          ),

                          SizedBox(height: 12.h),

                          buildTextField("add_portfolio_desc_label".tr, controller.descriptionCtrl, maxLines: 3),

                          SizedBox(height: 12.h),

                          Text(
                            "edit_image".tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          GestureDetector(
                            onTap: controller.pickImage,
                            child: Obx(() {
                              if (controller.imageFile.value != null) {
                                return _imageBox(Image.file(controller.imageFile.value!));
                              } else if (vendor?.image?.isNotEmpty == true) {
                                return _imageBox(Image.network(
                                  vendor!.image!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: Colors.grey),
                                ));
                              } else {
                                return _imageBox(Icon(Icons.camera_alt, color: Colors.grey));
                              }
                            }),
                          ),

                          SizedBox(height: 16.h),
                          Text(
                            "Add Social Link".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                        TextField(
  controller: controller.socialNameCtrl,
  decoration: InputDecoration(
    labelText: "Social Name".tr,
    labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 12.sp),
    filled: true,
    fillColor: backgroungcolor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: primaryColor.withOpacity(0.1)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: primaryColor.withOpacity(0.1), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
  ),
),

SizedBox(height: 10.h),

TextField(
  controller: controller.socialUrlCtrl,
  keyboardType: TextInputType.url,
  decoration: InputDecoration(
    labelText: "Social URL".tr,
    labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 12.sp),
    filled: true,
    fillColor: backgroungcolor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: primaryColor.withOpacity(0.1), width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
  ),

),
SizedBox(height: 8.h),
                               GestureDetector(
        onTap: () => controller.pickSocialIconImage(),
        child: Container(
          height: 120.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroungcolor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: primaryColor.withOpacity(0.5)),
          ),
          alignment: Alignment.center,
          child: controller.socialImageFile.value != null
              ? (kIsWeb
                  ? Image.network(
                      controller.socialImageFile.value!.path,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(controller.socialImageFile.value!.path),
                      fit: BoxFit.cover,
                    ))
              : Text("Tap to select social icon".tr),
        ),
      ),





                          SizedBox(height: 6.h),

                          
Align(
  alignment: Alignment.centerRight,
  child: TextButton(                              onPressed: controller.addSocialLink,
 child: Text("Add Social Link".tr, style: TextStyle(color: primaryColor, fontSize: 13.sp),)),
),
                          SizedBox(height: 16.h),

                          Obx(() {
                            if (controller.urlLinks.isEmpty) {
                              return Text(
                                "No social links added yet.".tr,
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
                        ],
                      ),
                    ),
                  ),
                ),

                Obx(() => Padding(
                      padding: EdgeInsets.all(12.w),
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
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: controller.isSubmitting.value
                              ? SizedBox(
                                  height: 18.h,
                                  width: 18.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  isEdit ? "Update Vendor".tr : "Submit".tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                  ),
                                ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }

   Widget buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    void Function(String)? onChanged,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: inputType,
        maxLines: maxLines,
        style: TextStyle(fontSize: 12.sp, color: Colors.black87),
        validator: (val) =>
            val == null || val.trim().isEmpty ? "$label is required" : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 12.sp),
          filled: true,
          fillColor: backgroungcolor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: selected ? primaryColor : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: primaryColor),
          ),
          child: Center(
            child: Text(
              lang,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
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
                    fontSize: 13.sp,
                    color: primaryColor,
                  ),
                ),
                Text(
                  item["url"] ?? "",
                  style: TextStyle(
                    fontSize: 11.sp,
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
            child: Icon(Icons.delete, color: Colors.red, size: 20.sp),
          )
        ],
      ),
    );
  }

  Widget _imageBox(Widget child) {
    return Container(
      height: 120.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: child,
      ),
    );
  }

  Widget _buildImageFromBase64OrUrl(String imageString) {
    if (imageString.startsWith("http")) {
      return Image.network(
        imageString,
        height: 24.h,
        width: 24.h,
        fit: BoxFit.cover,
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
        fillColor: backgroungcolor,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 12.sp,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: primaryColor, width: 1.5.w),
        ),
      );
}
