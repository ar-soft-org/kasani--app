import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/widgets/horizontal_spacer.dart';

Widget customButton(
    BuildContext context,
    bool isBack,
    String text,
    double fontSize,
    Function()? onPressed,
    double width,
    double height,
    Color borderColor,
    Color bgColor,
    double borderRadius,
    {bool showShadow = true,
    Color? color}) {
  return Container(
    width: width.w,
    height: height.h,
    decoration: BoxDecoration(
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25), // Shadow color
                  blurRadius: 5.0,
                  blurStyle: BlurStyle.normal,
                ),
              ]
            : [],
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: Border.all(color: borderColor)),
    child: MaterialButton(
      focusElevation: 20,
      onPressed: onPressed,
      highlightColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            isBack ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: fontSize.sp,
                fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                color: Colors.white,
              ),
            ),
          ),
          isBack ? horizontalSpacer(10) : const SizedBox.shrink(),
          isBack
              ? const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: AppColors.whiteShade,
                  size: 13,
                )
              : const SizedBox.shrink(),
        ],
      ),
    ),
  );
}
