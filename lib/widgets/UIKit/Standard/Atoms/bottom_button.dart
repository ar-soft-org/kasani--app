import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/widgets/custom_btn.dart';

class BottomButon extends StatelessWidget {
  const BottomButon({
    super.key,
    this.label,
    this.onPressed,
  });

  final String? label;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Center(
        child: customButton(
          context,
          false,
          label ?? 'Continuar',
          16,
          () {
            onPressed?.call();
          },
          308,
          58,
          Colors.transparent,
          AppColors.lightCyan,
          100,
          showShadow: true,
        ),
      ),
    );
  }
}
