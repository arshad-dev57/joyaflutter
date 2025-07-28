import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/language_controller.dart';
import 'package:joya_app/controllers/register_controller.dart';
import 'package:joya_app/screens/login_screnn.dart';
import 'package:joya_app/utils/colors.dart';
class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();
  RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroungcolor,

      body: SafeArea(
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
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text("register_title".tr, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: primaryColor)),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        _showLanguageDialog(context);
                      },
                      child: SvgPicture.asset("assets/Globe.svg", height: 32.h)),        ],
                ),
                SizedBox(height: 12.h),
                buildFormFields(context),
                SizedBox(height: 20.h),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(LoginScreen());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "already_account".tr,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12.sp,
                        ),
                        children: [
                          TextSpan(
                            text: "sign_in".tr,
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFormFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),

       Row(
  children: [
    /// First Name
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("first_name_label".tr, style: labelStyle(Colors.black)),
          SizedBox(height: 6.h),
          TextFormField(
            controller: controller.firstNameController,
            decoration: inputDecoration(primaryColor, context)
                .copyWith(hintText: "first_name_hint".tr),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "first_name_required".tr;
              }
              return null;
            },
          ),
        ],
      ),
    ),
    SizedBox(width: 12.w),

    /// Last Name
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("last_name_label".tr, style: labelStyle(Colors.black)),
          SizedBox(height: 6.h),
          TextFormField(
            controller: controller.lastNameController,
            decoration: inputDecoration(primaryColor, context)
                .copyWith(hintText: "last_name_hint".tr),
          ),
        ],
      ),
    ),
  ],
),
SizedBox(height: 14.h),

/// Username (below row)
Text("username_label".tr, style: labelStyle(Colors.black)),
SizedBox(height: 6.h),
TextFormField(
  controller: controller.userNameController,
  decoration: inputDecoration(primaryColor, context)
      .copyWith(hintText: "username_hint".tr),
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return "username_required".tr;
    }
    return null;
  },
),
SizedBox(height: 14.h),

        Row(
  children: [
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("country_label".tr, style: labelStyle(Colors.black)),
          SizedBox(height: 6.h),
          Obx(
  () => DropdownButtonFormField<String>(
    value: controller.selectedCountry.value.isEmpty
        ? null
        : controller.selectedCountry.value,
    decoration: inputDecoration(primaryColor, context).copyWith(
      hintText: "country_hint".tr,
      hintStyle: TextStyle(
        color: Colors.grey.shade400, // Light grey hint
        fontSize: 10.sp,
      ),
    ),
    style: TextStyle(
      fontSize: 10.sp,
      color: Colors.black87, // Selected item text color
    ),
    items: controller.countries.map(
      (c) => DropdownMenuItem(
        value: c,
        child: Text(
          c,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black54, // Dropdown list item color
          ),
        ),
      ),
    ).toList(),
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

        ],
      ),
    ),
    SizedBox(width: 14.w), // spacing between Country and Role dropdowns

    /// Role 
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("role_label".tr, style: labelStyle(Colors.black)),
          SizedBox(height: 6.h),
         Obx(
  () => DropdownButtonFormField<String>(
    value: controller.selectedRole.value.isEmpty
        ? null
        : controller.selectedRole.value,
    decoration: inputDecoration(primaryColor, context).copyWith(
      hintText: "role_hint".tr,
      hintStyle: TextStyle(
        color: Colors.grey.shade400, // Light grey for hint
        fontSize: 10.sp,
      ),
    ),
    style: TextStyle(
      fontSize: 10.sp,
      color: Colors.black87, // Selected item color
    ),
    items: controller.roles.map(
      (role) => DropdownMenuItem(
        value: role,
        child: Text(
          role,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black54, // List items light grey
          ),
        ),
      ),
    ).toList(),
    onChanged: (value) {
      controller.selectedRole.value = value ?? 'user';
    },
  ),
),

        ],
      ),
    ),
  ],
),

        SizedBox(height: 14.h),

        /// Email
        Text("email_label".tr, style: labelStyle(Colors.black)),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecoration(primaryColor, context)
              .copyWith(hintText: "email_hint".tr),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "email_required".tr;
            }
            return null;
          },
        ),
        SizedBox(height: 12.h),
 Text("login_password_label".tr, style: labelStyle(Colors.black)),
        SizedBox(height: 6.h),
        Obx(
          () => TextFormField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            decoration: inputDecoration(primaryColor, context).copyWith(
              hintText: 'login_password_hint'.tr,
             suffixIcon: IconButton(
  onPressed: () {
    controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
  },
  constraints: BoxConstraints(
    minWidth: 36.w,
    minHeight: 36.h,
  ),
  padding: EdgeInsets.all(8.r),
  icon: SizedBox(
    width: 20.w,
    height: 20.h,
    child: SvgPicture.asset(
      controller.isPasswordVisible.value
          ? 'assets/openeye.svg'
          : 'assets/eye.svg',
      fit: BoxFit.contain,
    ),
  ),
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
        SizedBox(height: 14.h),
        /// Phone
        Text("phone_label".tr, style: labelStyle(Colors.black)),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          decoration: inputDecoration(primaryColor, context)
              .copyWith(hintText: "phone_hint".tr),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "phone_required".tr;
            }
            return null;
          },
        ),
        SizedBox(height: 18.h),
        Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            controller.registerUser();
                          }
                        },
                 
                  label: controller.isLoading.value
                      ? SizedBox(
                          height: 18.h,
                          width: 18.h,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'register_title1'.tr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

 
  void _showLanguageDialog(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    Get.defaultDialog(
      title: "Choose Language",
      titleStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
      content: Obx(() {
        final currentLang =
            languageController.currentLocale.value.languageCode;

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
            SizedBox(height: 10.h),
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
        width: 140.w,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: primaryColor,
            width: 1.5.w,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }

  TextStyle labelStyle(Color primaryColor) => TextStyle(
        fontSize: 10.sp,
        color: primaryColor,
      );

  InputDecoration inputDecoration(
          Color primaryColor, BuildContext context) =>
      InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintStyle:
            TextStyle(color: Colors.grey.shade500, fontSize: 12.sp),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: Colors.grey.shade300, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: primaryColor, width: 1.5.w),
        ),
      );
}
