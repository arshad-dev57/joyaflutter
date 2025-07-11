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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Portfolio",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 16.h),

              /// Title
              buildTextField("Title", controller.titleCtrl),

              /// Description
              buildTextField("Description", controller.descCtrl, maxLines: 3),

              /// ✅ Service Type (Choice Chips)
              Text("Select Service Type",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: primaryColor)),
              SizedBox(height: 8.h),
              Obx(() {
                return Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: servicesController.serviceNames.map((service) {
                    final isSelected =
                        controller.serviceTypeList.contains(service);

                    return ChoiceChip(
                      label: Text(service, style: TextStyle(fontSize: 12.sp)),
                      selected: isSelected,
                      selectedColor: primaryColor.withOpacity(0.2),
                      onSelected: (val) {
                        if (val) {
                          controller.serviceTypeList.add(service);
                        } else {
                          controller.serviceTypeList.remove(service);
                        }
                      },
                      labelStyle: TextStyle(
                        color: isSelected ? primaryColor : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        side: BorderSide(
                          color:
                              isSelected ? primaryColor : Colors.grey.shade300,
                        ),
                      ),
                      backgroundColor: Colors.white,
                    );
                  }).toList(),
                );
              }),

              SizedBox(height: 16.h),

              /// Number of Projects
              buildTextField("Number of Projects", controller.numberOfProjectsCtrl,
                  inputType: TextInputType.number),

              /// Min Hours
              buildTextField("Min Hours", controller.minHoursCtrl,
                  inputType: TextInputType.number),

              /// Max Hours
              buildTextField("Max Hours", controller.maxHoursCtrl,
                  inputType: TextInputType.number),

              /// Estimated Cost Min
              buildTextField("Estimated Cost Min", controller.costMinCtrl,
                  inputType: TextInputType.number),

              /// Estimated Cost Max
              buildTextField("Estimated Cost Max", controller.costMaxCtrl,
                  inputType: TextInputType.number),

              /// Currency
              buildTextField("Currency", controller.currencyCtrl),

              /// Skills Used
              buildTextField(
                "Skills Used (comma separated)",
                TextEditingController(
                    text: controller.skillsUsed.join(',')),
                onChanged: (val) {
                  controller.skillsUsed.value =
                      val.split(',').map((e) => e.trim()).toList();
                },
              ),

              /// Equipment Used
              buildTextField(
                "Equipment Used (comma separated)",
                TextEditingController(
                    text: controller.equipmentUsed.join(',')),
                onChanged: (val) {
                  controller.equipmentUsed.value =
                      val.split(',').map((e) => e.trim()).toList();
                },
              ),

              /// Highlights
              buildTextField("Highlights", controller.highlightsCtrl),

              /// Challenges
              buildTextField("Challenges Faced", controller.challengesCtrl),

              /// Location
              buildTextField("Location", controller.locationCtrl),

              /// Client Type
              buildTextField("Client Type", controller.clientTypeCtrl),

              /// Video Link
              buildTextField("Video Link", controller.videoLinkCtrl),

              /// Self Note
              buildTextField("Self Note", controller.selfNoteCtrl,
                  maxLines: 2),

              /// Date Picker
              Obx(() {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    controller.selectedDate.value == null
                        ? "Select Date"
                        : "Date: ${controller.selectedDate.value!.toLocal().toString().substring(0, 10)}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate:
                          controller.selectedDate.value ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      controller.selectedDate.value = picked;
                    }
                  },
                );
              }),

              SizedBox(height: 12.h),

              /// Image Picker
              Text("Images",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: primaryColor)),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  height: 100.h,
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
                      children: List.generate(
                          controller.imageFiles.length, (index) {
                        return Stack(
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.h,
                              margin: EdgeInsets.only(top: 8.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image: DecorationImage(
                                  image: FileImage(
                                      controller.imageFiles[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () =>
                                    controller.removeImage(index),
                                child: CircleAvatar(
                                  radius: 10.r,
                                  backgroundColor: Colors.black,
                                  child: Icon(Icons.close,
                                      color: Colors.white, size: 14),
                                ),
                              ),
                            )
                          ],
                        );
                      }),
                    )),

              SizedBox(height: 16.h),

              /// Submit Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("Cancel"),
                  ),
                  Obx(() => ElevatedButton(
                        onPressed: controller.addPortfolio,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                        ),
                        child: controller.addPortfolioLoading.value
                            ? SizedBox(
                                height: 16.h,
                                width: 16.h,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2))
                            : Text("Save Portfolio",
                                style: TextStyle(color: Colors.white)),
                      )),
                ],
              )
            ],
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
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: inputType,
        maxLines: maxLines,
        validator: (val) =>
            val == null || val.trim().isEmpty ? "$label is required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
  }
}
