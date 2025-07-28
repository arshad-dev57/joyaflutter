import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:joya_app/screens/login_screnn.dart';
import 'package:joya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DisclaimerScreen extends StatefulWidget {
  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroungcolor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),

              SvgPicture.asset(
                'assets/Disclaimer.svg',
                height: 40.h,
              ),

              SizedBox(height: 12.h),

              Text(
                "App Usage Policy",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 20.h),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "نحن لا نقدم هذه الخدمات بشكل مباشر ولا نضمن جودتها أو التزام مقدمي الخدمة بها. جميع التعاملات تتم بين المستخدم ومقدم الخدمة بشكل مستقل، دون مسؤولية مباشرة على التطبيق.\n\n"
                        "تطبيق “جويا” هو منصة وسيطة تهدف إلى ربط المستخدمين بمقدمي خدمات المناسبات مثل القاعات، الضيافة، التصوير، وغيرها.\n\n"
                        "باستخدامك للتطبيق، فإنك تقر وتوافق على أن “جويا” ليست مسؤولة عن أي خلل أو تأخير أو مشاكل ناتجة عن الأطراف المقدمة للخدمة.",
                        style: TextStyle(fontSize: 13.sp, height: 1.6),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Joya is a third-party platform designed to connect users with event service providers such as venues, catering, photography, and more.\n\n"
                        "We do not directly provide these services, nor do we guarantee their quality or the commitment of the providers. All transactions and agreements are made solely between the user and the service provider, without any direct liability on the app.\n\n"
                        "By using the app, you acknowledge and agree that Joya is not responsible for any issues, delays, or disputes that may arise with third-party service providers.",
                        style: TextStyle(fontSize: 13.sp, height: 1.6),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "I Agree with ",
                        style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

             Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12.0),
  child: SizedBox(
    width: double.infinity,
    height: 45.h,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
      ),
      onPressed: isChecked
          ? () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('disclaimerAccepted', true);
Get.to(LoginScreen());
            }
          : null,
      child: Text(
        "Continue",
        style: TextStyle(fontSize: 16.sp, color: Colors.white),
      ),
    ),
  ),
),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
