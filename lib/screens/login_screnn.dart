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
              size: 24.sp,
            ),
          ),
        ],
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/joya-login.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('login_username_label'.tr, style: labelStyle),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: controller.userNameController,
                      decoration: inputDecoration(primaryColor, context).copyWith(
                        hintText: 'login_username_hint'.tr,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'login_required_username'.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    Text('login_password_label'.tr, style: labelStyle),
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
                    SizedBox(height: 30.h),
                  Obx(
  () => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: EdgeInsets.symmetric(vertical: 16.h),
      ),
      onPressed: controller.isLoading.value
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                controller.loginUser();
              }
            },
      child: controller.isLoading.value
          ? SizedBox(
              height: 20.h,
              width: 20.h,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              'login_button'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    ),
  ),
),

                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        onPressed: () {
                          Get.to(RegisterScreen());
                        },
                        child: Text(
                          'register_title'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
          border: Border.all(
            color: primaryColor,
            width: 2.w,
          ),
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

  final labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  InputDecoration inputDecoration(Color primaryColor, BuildContext context) =>
      InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14.sp,
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
