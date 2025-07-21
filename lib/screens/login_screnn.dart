import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:joya_app/controllers/language_controller.dart';
import 'package:joya_app/controllers/login_controller.dart';
import 'package:joya_app/screens/regisdter_screen.dart';
import 'package:joya_app/utils/colors.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'loginregister_title'.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showLanguageDialog(context);
            },
            icon: Icon(
              Icons.language,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
        ],
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          /// Background image
          Image.asset(
            'assets/joya-login.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          /// Form overlay
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Username label
                    Text('login_username_label'.tr, style: labelStyle),
                    SizedBox(height: 8.h),

                    /// Username field
                    TextFormField(
                      controller: controller.userNameController,
                      decoration: inputDecoration(primaryColor, context)
                          .copyWith(
                        hintText: 'login_username_hint'.tr,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'login_required_username'.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    /// Password label
                    Text('login_password_label'.tr, style: labelStyle),
                    SizedBox(height: 8.h),

                    /// Password field
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        decoration: inputDecoration(primaryColor, context)
                            .copyWith(
                          hintText: 'login_password_hint'.tr,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 18.sp,
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
                    SizedBox(height: 24.h),

                    /// Login button
                    Obx(
                      () => Center(
                        child: SizedBox(
                          width: 200.w,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding:
                                  EdgeInsets.symmetric(vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      controller.loginUser();
                                    }
                                  },
                            icon: Icon(Icons.login,
                                color: Colors.white, size: 18.sp),
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
                                    'login_button'.tr,
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
                    SizedBox(height: 12.h),

                    /// Register button
                    Center(
                      child: SizedBox(
                        width: 200.w,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding:
                                EdgeInsets.symmetric(vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          onPressed: () {
                            Get.to(RegisterScreen());
                          },
                          icon: Icon(Icons.app_registration,
                              color: Colors.white, size: 18.sp),
                          label: Text(
                            'register_title'.tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

  final labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 13.sp,
    color: Colors.black,
  );

  InputDecoration inputDecoration(Color primaryColor, BuildContext context) =>
      InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 13.sp,
        ),
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
