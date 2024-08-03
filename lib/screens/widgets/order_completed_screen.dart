import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/screens/widgets/check_out_stepper.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';
import 'package:kasanipedido/widgets/custom_text.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';

class OrderCompletedPageView extends StatelessWidget {
  const OrderCompletedPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalSpacer(30),
            buildIndicator(2),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    height: 60.h,
                    width: 60.w,
                    AppImages.done,
                    fit: BoxFit.contain,
                  ),
                  verticalSpacer(10),
                  customText(
                      'Pedido registrado',
                      FontWeight.w700,
                      20,
                      GoogleFonts.beVietnamPro().fontFamily.toString(),
                      AppColors.black),
                  verticalSpacer(10),
                  customText(
                      'Puedes visualizar tu pedido en el historial',
                      FontWeight.w500,
                      14,
                      GoogleFonts.beVietnamPro().fontFamily.toString(),
                      AppColors.black),
                  verticalSpacer(100),
                  // button
                  // FIXME: make global
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('host');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: Size(175.w, 31.h),
                      backgroundColor: const Color(0XFF009EBF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                    ),
                    child: Text('Inicio',
                        style: TextStyle(
                            fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                            fontSize: 14.sp,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
