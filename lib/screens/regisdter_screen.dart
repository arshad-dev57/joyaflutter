import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/language_controller.dart';
import 'package:joya_app/controllers/register_controller.dart';
import 'package:joya_app/utils/colors.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "register_title".tr,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 24.sp),
        actions: [
          IconButton(
            icon: Icon(Icons.language, size: 24.sp),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
        ],
      ),
      bottomSheet: buildBottomSheet(context),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/joya-register.png', fit: BoxFit.cover),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 8.w,
                    right: 8.w,
                    top: 230.h,
                    bottom: 20.h,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "register_heading".tr,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "register_subheading".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                /// ✅ SCROLLABLE FORM
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildFormFields(context),
                          SizedBox(height: 30.h),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "already_account".tr,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14.sp,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "sign_in".tr,
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFormFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Country
        SizedBox(height: 20.h),

        /// First Name
        Text("first_name_label".tr, style: labelStyle(primaryColor)),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.firstNameController,
          decoration: inputDecoration(
            primaryColor,
            context,
          ).copyWith(hintText: "first_name_hint".tr),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "first_name_required".tr;
            }
            return null;
          },
        ),
        SizedBox(height: 20.h),

        /// Last Name
        Text("last_name_label".tr, style: labelStyle(primaryColor)),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.lastNameController,
          decoration: inputDecoration(
            primaryColor,
            context,
          ).copyWith(hintText: "last_name_hint".tr),
        ),
        SizedBox(height: 20.h),

        /// Username
        Text("username_label".tr, style: labelStyle(primaryColor)),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.userNameController,
          decoration: inputDecoration(
            primaryColor,
            context,
          ).copyWith(hintText: "username_hint".tr),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "username_required".tr;
            }
            return null;
          },
        ),
        SizedBox(height: 20.h),
         Text("country_label".tr, style: labelStyle(primaryColor)),
        SizedBox(height: 8.h),
        Obx(
          () => DropdownButtonFormField<String>(
            value:
                controller.selectedCountry.value.isEmpty
                    ? null
                    : controller.selectedCountry.value,
            decoration: inputDecoration(
              primaryColor,
              context,
            ).copyWith(hintText: "country_hint".tr),
            items:
                controller.countries
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c, style: TextStyle(fontSize: 14.sp)),
                      ),
                    )
                    .toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "country_required".tr;
              }
              return null;
            },
            onChanged: (value) {
              controller.selectedCountry.value = value ?? '';
            },
          ),
        ),
        SizedBox(height: 20.h),

        /// Role
        Text("role_label".tr, style: labelStyle(primaryColor)),
        SizedBox(height: 8.h),
       Obx(
  () => DropdownButtonFormField<String>(
    value: controller.selectedRole.value.isEmpty
        ? null
        : controller.selectedRole.value,
    decoration: inputDecoration(
      primaryColor,
      context,
    ).copyWith(hintText: "role_hint".tr),
    items: controller.roles
        .map(
          (role) => DropdownMenuItem(
            value: role,
            child: Text(role, style: TextStyle(fontSize: 14.sp)),
          ),
        )
        .toList(),
    onChanged: (value) {
      controller.selectedRole.value = value ?? 'user';
    },
  ),
),

SizedBox(height: 20.h),

        /// Email
        Text("email_label".tr, style: labelStyle(primaryColor)),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecoration(
            primaryColor,
            context,
          ).copyWith(hintText: "email_hint".tr),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "email_required".tr;
            }
            return null;
          },
        ),
        SizedBox(height: 20.h),

        /// Phone
        Text("phone_label".tr, style: labelStyle(primaryColor)),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          decoration: inputDecoration(
            primaryColor,
            context,
          ).copyWith(hintText: "phone_hint".tr),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "phone_required".tr;
            }
            return null;
          },
        ),
       
        SizedBox(height: 10),
 Text('login_password_label'.tr, style: labelStyle(primaryColor)),
                    SizedBox(height: 8.h),
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        decoration: inputDecoration(primaryColor, context).copyWith(
                          hintText: 'login_password_hint'.tr,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 22.sp,
                            ),
                            onPressed: () {
                              controller.isPasswordVisible.value =
                                  !controller.isPasswordVisible.value;
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'login_required_password'.tr;
                          }
                          return null;
                        },
                      ),
                    ),


      ],
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.h),
          ),
          onPressed:
              controller.isLoading.value
                  ? null
                  : () {
                    if (_formKey.currentState!.validate()) {
                      controller.registerUser();
                    }
                  },
          child:
              controller.isLoading.value
                  ? SizedBox(
                    height: 24.h,
                    width: 24.h,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    "sign_up".tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    Get.defaultDialog(
      title: "Choose Language",
      titleStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
      ),
      content: Obx(() {
        final currentLang = languageController.currentLocale.value.languageCode;

        return Column(
          children: [
            _buildLangButton(
              label: "English",
              isSelected: currentLang == 'en',
              onTap: () {
                languageController.changeLanguage(const Locale('en'));
                Get.back();
              },
            ),
            SizedBox(height: 12.h),
            _buildLangButton(
              label: "عربي",
              isSelected: currentLang == 'ar',
              onTap: () {
                languageController.changeLanguage(const Locale('ar'));
                Get.back();
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLangButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: primaryColor, width: 2.w),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  TextStyle labelStyle(Color primaryColor) => TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14.sp,
    color: primaryColor,
  );

  InputDecoration inputDecoration(Color primaryColor, BuildContext context) =>
      InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
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
