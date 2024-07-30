import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';
import 'package:kasanipedido/widgets/custom_text.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';

class OrderCompletePageView extends StatelessWidget {
  const OrderCompletePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        customText('Pedido registrado', FontWeight.w700, 20,
            GoogleFonts.beVietnamPro().fontFamily.toString(), AppColors.black),
        verticalSpacer(10),
        customText(
            'Puedes visualizar tu pedido en el historial',
            FontWeight.w500,
            14,
            GoogleFonts.beVietnamPro().fontFamily.toString(),
            AppColors.black),
        verticalSpacer(100),
      ],
    );
  }
}
