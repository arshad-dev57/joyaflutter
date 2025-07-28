import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/po4rtfolio_controller.dart';
import '../controllers/services_controller.dart';
import '../utils/colors.dart';

class AddPortfolioDialog extends StatelessWidget {
  final PortfolioController controller = Get.put(PortfolioController());
  final ServicesController servicesController = Get.put(ServicesController());

  AddPortfolioDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroungcolor,
      insetPadding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Center(
                  child: Text(
                    "Add Portfolio",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                buildTextField("Title", controller.titleCtrl),
                buildTextField("Description", controller.descCtrl, maxLines: 3),
                Text(
                  "Select Service Type",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 8.h),
               Obx(() {
  return Wrap(
    spacing: 8.w,
    runSpacing: 8.h,
    children: servicesController.serviceNames.map((service) {
      final isSelected = controller.serviceTypeList.contains(service);

      return Theme(
        data: Theme.of(context).copyWith(
          chipTheme: Theme.of(context).chipTheme.copyWith(
            checkmarkColor: Colors.white,
          ),
        ),
        child: ChoiceChip(
          label: Text(
            service,
            style: TextStyle(
              fontSize: 11.sp,
              color: isSelected ? Colors.white : primaryColor,
            ),
          ),
          selected: isSelected,
          selectedColor: primaryColor,
          backgroundColor: Colors.grey.shade100,
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected ? primaryColor : Colors.grey.shade300,
            ),
          ),
          onSelected: (val) {
            if (val) {
              controller.serviceTypeList.add(service);
            } else {
              controller.serviceTypeList.remove(service);
            }
          },
        ),
      );
    }).toList(),
  );
}),

                SizedBox(height: 16.h),

                // buildTextField("Number of Projects", controller.numberOfProjectsCtrl, inputType: TextInputType.number),
                // buildTextField("Min days", controller.minHoursCtrl, inputType: TextInputType.number),
                // buildTextField("Max days", controller.maxHoursCtrl, inputType: TextInputType.number),
                // buildTextField("Estimated Cost Min", controller.costMinCtrl, inputType: TextInputType.number),
                // buildTextField("Estimated Cost Max", controller.costMaxCtrl, inputType: TextInputType.number),
                // buildTextField("Currency", controller.currencyCtrl),

                // buildTextField(
                //   "Skills Used (comma separated)",
                //   TextEditingController(text: controller.skillsUsed.join(',')),
                //   onChanged: (val) {
                //     controller.skillsUsed.value = val.split(',').map((e) => e.trim()).toList();
                //   },
                // ),

                // buildTextField(
                //   "Equipment Used (comma separated)",
                //   TextEditingController(text: controller.equipmentUsed.join(',')),
                //   onChanged: (val) {
                //     controller.equipmentUsed.value = val.split(',').map((e) => e.trim()).toList();
                //   },
                // ),

                // buildTextField("Highlights", controller.highlightsCtrl),
                // buildTextField("Challenges Faced", controller.challengesCtrl),
                // buildTextField("Location", controller.locationCtrl),
                // buildTextField("Client Type", controller.clientTypeCtrl),
                // buildTextField("Video Link", controller.videoLinkCtrl),
                // buildTextField("Self Note", controller.selfNoteCtrl, maxLines: 2),

                /// Date Picker
                // Obx(() {
                //   return ListTile(
                //     contentPadding: EdgeInsets.zero,
                //     title: Text(
                //       controller.selectedDate.value == null
                //           ? "Select Date"
                //           : "Date: ${controller.selectedDate.value!.toLocal().toString().substring(0, 10)}",
                //       style: TextStyle(fontSize: 13.sp),
                //     ),
                //     trailing: Icon(Icons.calendar_today, color: primaryColor, size: 18.sp),
                //     onTap: () async {
                //       DateTime? picked = await showDatePicker(
                //         context: context,
                //         initialDate: controller.selectedDate.value ?? DateTime.now(),
                //         firstDate: DateTime(2000),
                //         lastDate: DateTime(2100),
                //       );
                //       if (picked != null) {
                //         controller.selectedDate.value = picked;
                //       }
                //     },
                //   );
                // }),

                // SizedBox(height: 12.h),

                // /// Image Picker
                Text(
                  "Images",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Icon(Icons.add_a_photo, color: Colors.grey),
                    ),
                  ),
                ),
                Obx(() => controller.imageFiles.isEmpty
                    ? SizedBox.shrink()
                    : Wrap(
                        spacing: 8,
                        children: List.generate(controller.imageFiles.length, (index) {
                          return Stack(
                            children: [
                              Container(
                                width: 60.w,
                                height: 60.h,
                                margin: EdgeInsets.only(top: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  image: DecorationImage(
                                    image: FileImage(controller.imageFiles[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => controller.removeImage(index),
                                  child: CircleAvatar(
                                    radius: 8.r,
                                    backgroundColor: Colors.black,
                                    child: Icon(Icons.close, color: Colors.white, size: 12.sp),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                      )),

                SizedBox(height: 16.h),

                /// Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text("Cancel", style: TextStyle(color: Colors.grey.shade700)),
                    ),
                    Obx(() => ElevatedButton(
                          onPressed: controller.addPortfolio,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          ),
                          child: controller.addPortfolioLoading.value
                              ? SizedBox(
                                  height: 16.h,
                                  width: 16.h,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : Text("Create", style: TextStyle(color: Colors.white)),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
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
          fillColor: Colors.grey.shade100,
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
}
