import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joya_app/models/portfolio_model.dart';
import 'package:joya_app/utils/colors.dart';

class PortfolioDetailScreen extends StatefulWidget {
  final PortfolioModel portfolio;

  const PortfolioDetailScreen({
    super.key,
    required this.portfolio,
  });

  @override
  State<PortfolioDetailScreen> createState() => _PortfolioDetailScreenState();
}

class _PortfolioDetailScreenState extends State<PortfolioDetailScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
         widget.portfolio.images.isNotEmpty
    ? CarouselSlider(
        options: CarouselOptions(
          height: 300.h,
          viewportFraction: 1.0,
          enableInfiniteScroll: false,
          autoPlay: false,
        ),
        items: widget.portfolio.images.map((imageUrl) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(0), // chahe to rounding karo
            child: Image.network(
              imageUrl,
              height: 300.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade300,
                child: Icon(Icons.broken_image,
                    size: 80.sp, color: Colors.grey),
              ),
            ),
          );
        }).toList(),
      )
    : Container(
        height: 300.h,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: Icon(Icons.image,
            size: 80.sp, color: Colors.grey),
      ),

            Transform.translate(
              offset: Offset(0, -30.h),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.portfolio.title,
                    style: TextStyle(
                      color: Colors.brown.shade700,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // SizedBox(height: 16.h),

            /// Rest of content
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.portfolio.description.isNotEmpty)
                    Text(
                      widget.portfolio.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade800,
                      ),
                    ),

                  SizedBox(height: 16.h),

                  if (widget.portfolio.services.isNotEmpty)
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: widget.portfolio.services
                          .map(
                            (s) => Chip(
                              label: Text(
                                s,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              backgroundColor:
                                  primaryColor.withOpacity(0.15),
                            ),
                          )
                          .toList(),
                    ),

                  SizedBox(height: 16.h),

                  // Divider(),

                  // _sectionHeader("Details"),

                  // _infoRow(Icons.location_on, "Location",
                  //     widget.portfolio.location),
                  // _infoRow(Icons.timer, "Duration", widget.portfolio.duration),
                  // _infoRow(Icons.group, "Client Type",
                  //     widget.portfolio.clientType),
                  // _infoRow(Icons.format_list_bulleted, "Tags",
                  //     widget.portfolio.tags?.join(", ")),
                  // _infoRow(Icons.star_border, "Number of Projects",
                  //     widget.portfolio.numberOfProjects?.toString()),
                  // _infoRow(
                  //     Icons.schedule,
                  //     "Time Estimates",
                  //     widget.portfolio.timeEstimates != null
                  //         ? "${widget.portfolio.timeEstimates!.minHours} - ${widget.portfolio.timeEstimates!.maxHours} hours"
                  //         : null),
                  // _infoRow(
                  //     Icons.attach_money,
                  //     "Estimated Cost",
                  //     widget.portfolio.estimatedCostRange != null
                  //         ? "${widget.portfolio.estimatedCostRange!.min} - ${widget.portfolio.estimatedCostRange!.max} ${widget.portfolio.estimatedCostRange!.currency}"
                  //         : null),
                  // _infoRow(Icons.lightbulb, "Highlights",
                  //     widget.portfolio.highlights),
                  // _infoRow(Icons.warning_amber, "Challenges",
                  //     widget.portfolio.challengesFaced),
                  // _infoRow(Icons.note, "Self Note", widget.portfolio.selfNote),
                  // _infoRow(Icons.calendar_today, "Date",
                  //     widget.portfolio.date != null
                  //         ? DateFormat.yMMMd().format(widget.portfolio.date!)
                  //         : null),
                  // _infoRow(Icons.check_circle, "Practice Project",
                  //     widget.portfolio.isPracticeProject == true ? "Yes" : "No"),
                  // _infoRow(Icons.contact_mail, "Contact Enabled",
                  //     widget.portfolio.contactEnabled == true ? "Yes" : "No"),

                  // if (widget.portfolio.skillsUsed != null &&
                  //     widget.portfolio.skillsUsed!.isNotEmpty)
                  //   _multiItemRow(Icons.construction, "Skills Used",
                  //       widget.portfolio.skillsUsed!),

                  // if (widget.portfolio.equipmentUsed != null &&
                  //     widget.portfolio.equipmentUsed!.isNotEmpty)
                  //   _multiItemRow(Icons.build, "Equipment Used",
                  //       widget.portfolio.equipmentUsed!),

                  // if (widget.portfolio.videoLinks != null &&
                  //     widget.portfolio.videoLinks!.isNotEmpty)
                  //   _multiItemRow(Icons.video_library, "Video Links",
                  //       widget.portfolio.videoLinks!),

                  // SizedBox(height: 16.h),

                  // if (widget.portfolio.testimonials != null &&
                  //     widget.portfolio.testimonials!.isNotEmpty)
                  //   Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       _sectionHeader("Testimonials"),
                  //       ...widget.portfolio.testimonials!.map(
                  //         (t) => Container(
                  //           margin:
                  //               EdgeInsets.symmetric(vertical: 8.h),
                  //           padding: EdgeInsets.all(12.r),
                  //           decoration: BoxDecoration(
                  //             color:
                  //                 primaryColor.withOpacity(0.05),
                  //             borderRadius:
                  //                 BorderRadius.circular(12.r),
                  //           ),
                  //           child: Row(
                  //             crossAxisAlignment:
                  //                 CrossAxisAlignment.start,
                  //             children: [
                  //               Icon(Icons.format_quote,
                  //                   color: primaryColor,
                  //                   size: 18.sp),
                  //               SizedBox(width: 8.w),
                  //               Expanded(
                  //                 child: Text(
                  //                   t,
                  //                   style: TextStyle(
                  //                     fontSize: 13.sp,
                  //                     color:
                  //                         Colors.grey.shade800,
                  //                     fontStyle:
                  //                         FontStyle.italic,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),

                  // SizedBox(height: 16.h),

                  // Text(
                  //   "Created on: ${DateFormat.yMMMd().format(widget.portfolio.createdAt)}",
                  //   style: TextStyle(
                  //     fontSize: 12.sp,
                  //     color: Colors.grey,
                  //     fontStyle: FontStyle.italic,
                  //   ),
                  // ),
                ],
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 10.h,left: 2.h),
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.black.withOpacity(0.4),
          onPressed: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startTop,
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$title: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade800,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _multiItemRow(IconData icon, String title, List<String> items) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          
        Wrap(
  spacing: 8.w,
  runSpacing: 6.h,
  children: List.generate(items.length, (index) {
    final e = items[index];
    final List<Color> chipColors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
    ];
    final color = chipColors[index % chipColors.length];

    return Chip(
      label: Text(
        e,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.black54,
        ),
      ),
      backgroundColor: color.withOpacity(0.15),
    );
  }),
)

        ],
      ),
    );
  }
}
