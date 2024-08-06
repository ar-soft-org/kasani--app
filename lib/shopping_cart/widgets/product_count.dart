import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/utils/images.dart';

class ProductCount extends StatefulWidget {
  const ProductCount({
    super.key,
    required this.initialComment,
    required this.onDelete,
  });

  final String initialComment;
  final Function onDelete;

  @override
  State<ProductCount> createState() => _ProductCountState();
}

class _ProductCountState extends State<ProductCount> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialComment);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  onAccept(BuildContext context) {
    final text = controller.text;

    if (text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('comment is empty')));
      return;
    }

    Navigator.of(context).pop({'comment': text});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 16.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                child: Image.asset(AppImages.deleteIcon, scale: 1.5.sp),
                onTap: () {
                  controller.clear();
                  widget.onDelete.call();
                },
              ),
              Text(
                'Comentarios',
                style: TextStyle(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: const Color(0xff2D0C57),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
              GestureDetector(
                child: Image.asset(AppImages.closeIcon, scale: 1.5.sp),
                onTap: () => Navigator.of(context).pop(),
              )
            ],
          ),
          SizedBox(height: 20.h),
          TextField(
            controller: controller,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                    width: 1.5.sp, color: const Color.fromRGBO(0, 0, 0, 0.42)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide:
                    BorderSide(width: 1.5.sp, color: const Color(0XFF009ebf)),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              onAccept(context);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              minimumSize: Size(175.w, 31.h),
              backgroundColor: const Color(0XFF009EBF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            child: Text('Aceptar',
                style: TextStyle(
                    fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                    fontSize: 14.sp,
                    color: Colors.white)),
          ),
          SizedBox(height: 10.h),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              minimumSize: Size(175.w, 31.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(
                  fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                  fontSize: 14.sp,
                  color: const Color(0XFF009EBF)),
            ),
          )
        ],
      ),
    );
  }
}