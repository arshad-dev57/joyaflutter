import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerItem() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 8.r,
          offset: Offset(0, 4.h),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          height: 40.h,
          color: Colors.grey.shade300,
          margin: EdgeInsets.only(top: 8.h),
        )
      ],
    ),
  );
}
