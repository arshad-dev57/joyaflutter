import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/po4rtfolio_controller.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '../utils/colors.dart';

class AddPortfolioDialog extends StatelessWidget {
  AddPortfolioDialog({super.key});

  final PortfolioController controller = Get.put(PortfolioController());

  @override
  Widget build(BuildContext context) {
    return
    
    
    
     Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "add_portfolio_title".tr,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 20.h),

                /// Image Picker Section
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          height: 100.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.w,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.grey, size: 24.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  "add_portfolio_add_photo".tr,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      controller.imageFiles.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              height: 100.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.imageFiles.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 10.w),
                                        width: 100.w,
                                        height: 100.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.r),
                                          image: DecorationImage(
                                            image: FileImage(
                                              controller.imageFiles[index],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 4.w,
                                        top: 4.h,
                                        child: GestureDetector(
                                          onTap: () =>
                                              controller.removeImage(index),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(4.w),
                                            child: Icon(
                                              Icons.close,
                                              size: 18.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ],
                  );
                }),
                SizedBox(height: 16.h),

                /// Title
                TextFormField(
                  controller: controller.titleCtrl,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "add_portfolio_title_required".tr;
                    }
                    return null;
                  },
                  decoration: inputDecoration(primaryColor, context).copyWith(
                    labelText: "add_portfolio_title_label".tr,
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                /// Description
                TextFormField(
                  controller: controller.descCtrl,
                  maxLines: 3,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "add_portfolio_desc_required".tr;
                    }
                    return null;
                  },
                  decoration: inputDecoration(primaryColor, context).copyWith(
                    labelText: "add_portfolio_desc_label".tr,
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
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
                        
                            return MultiSelectDialogField<String>(
                              items: controller.serviceNames
                                  .map((name) => MultiSelectItem<String>(name, name))
                                  .toList(),
                              initialValue: controller.selectedServiceNames,
                              searchable: true,
                              listType: MultiSelectListType.LIST,
                              selectedColor: primaryColor,
                              chipDisplay: MultiSelectChipDisplay(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                                chipColor: primaryColor,
                                onTap: (value) {
                                  controller.selectedServiceNames.remove(value);
                                },
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.w,
                                ),
                              ),
                              buttonIcon: Icon(
                                Icons.add,
                                color: primaryColor,
                              ),
                              buttonText: Text(
                                "Select Services",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              onConfirm: (values) {
                                controller.selectedServiceNames.value = values;
                              },
                              validator: (values) {
                                if (values == null || values.isEmpty) {
                                  return "At least one service is required";
                                }
                                return null;
                              },
                            );
                          }
                        ),
                        SizedBox(height: 12.h),
                /// Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "add_portfolio_cancel".tr,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                        ),
                        onPressed: controller.addPortfolio,
                        child:controller.addPortfolioLoading.value ? CircularProgressIndicator() : Text(
                          "add_portfolio_save".tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
          vertical: 16.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.5.w,
          ),
        ),
      );
}
