import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed.call();
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: Size(175.w, 31.h),
        backgroundColor: const Color(0XFF009EBF),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontFamily: GoogleFonts.beVietnamPro().fontFamily,
            fontSize: 14.sp,
            color: Colors.white),
      ),
    );
  }
}
