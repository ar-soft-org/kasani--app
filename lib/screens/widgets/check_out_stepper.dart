import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasanipedido/utils/colors.dart';

Widget buildIndicator(int currentPage) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (index) {
      return Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 20.h,
            width: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPage < index
                  ? AppColors.greyShade
                  : AppColors.lightCyan,
            ),
            child: currentPage >= index
                ? const Center(
                    child: Icon(
                    Icons.done_rounded,
                    size: 15,
                    color: Colors.white,
                  ))
                : null,
          ),
          index == 2
              ? const SizedBox()
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  height: 2.h,
                  width: 105.w,
                  color: AppColors.greyShade,
                )
        ],
      );
    }),
  );
}
