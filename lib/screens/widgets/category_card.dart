import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/shopping_cart/shopping_cart.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';
import 'package:kasanipedido/widgets/custom_text.dart';
import 'package:kasanipedido/widgets/horizontal_spacer.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

Widget categoryCard(String image, String title, void Function() onTap,
    Color color, Color clrText) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160.h,
        width: 160.w,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(8.r)),
        child: Column(
          children: [
            Container(
              height: 125.h,
              width: 160.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(image),
                ),
              ),
            ),
            verticalSpacer(5),
            customText(title, FontWeight.w700, 16,
                GoogleFonts.roboto().fontFamily.toString(), clrText),
          ],
        ),

        //
      ),
    ),
  );
}

Widget circleCard(
    BuildContext context,
    String image,
    String title,
    Color color,
    int index,
    Color bgColor,
    void Function() onTap,
    Color clrText,
    FontWeight fontWeight) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.w),
    child: SizedBox(
      height: 70.h,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 44.h,
              width: 44.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover)),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: GoogleFonts.inter().fontFamily,
                fontSize: 11.sp,
                fontWeight: fontWeight,
                color: clrText),
          ),
        ],
      ),
    ),
  );
}

Widget addItemCard({
  String? headTitle,
  required String title,
  required String count,
  required String mScale,
  required bool isHeadingVisible,
  required bool isMessage,
  required void Function() increment,
  required void Function() decrement,
  String? comment,
  ProductData? data,
  required BuildContext context,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      verticalSpacer(10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isHeadingVisible
                    ? Text(
                        headTitle ?? '--',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontSize: 16.sp,
                          color: AppColors.lightCyan,
                        ),
                      )
                    : const SizedBox.shrink(),
                Text(
                  title,
                  maxLines: null,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontSize: 12.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              isMessage
                  ? InkWell(
                      onTap: () async {
                        final shoppingCartBloc =
                            context.read<ShoppingCartBloc>();
                        final result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return BlocProvider.value(
                              value: shoppingCartBloc,
                              child: Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17.r)),
                                child: ProductComments(
                                  initialComment: comment ?? '',
                                  onDelete: () {
                                    if (data != null) {
                                      context.read<ShoppingCartBloc>().add(
                                            ShoppingCartProductDataUpdated(
                                                data: data.copyWith(
                                                    observation: '')),
                                          );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        );

                        final commentResult = result?['comment'];
                        if (context.mounted &&
                            data != null &&
                            result is Map &&
                            commentResult != null) {
                          context.read<ShoppingCartBloc>().add(
                                ShoppingCartProductDataUpdated(
                                  data:
                                      data.copyWith(observation: commentResult),
                                ),
                              );
                        }
                      },
                      child: Image.asset(
                        AppImages.message,
                        height: 20.h,
                        color: comment != null && comment.isNotEmpty
                            ? Colors.blue
                            : null,
                      ),
                    )
                  : const SizedBox.shrink(),
              Row(
                children: [
                  GestureDetector(
                    onTap: decrement,
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                              color: AppColors.lightCyan, width: 1.w)),
                      child: const Center(
                        child: Icon(
                          Icons.remove,
                          color: AppColors.lightCyan,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                  horizontalSpacer(6),
                  Text(
                    count,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontSize: 16.sp,
                      color: AppColors.darkBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  horizontalSpacer(6),
                  GestureDetector(
                    onTap: increment,
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.lightCyan, width: 1.w)),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: AppColors.lightCyan,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                  horizontalSpacer(5),
                ],
              )
            ],
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          customText(
              mScale,
              FontWeight.w400,
              11,
              GoogleFonts.beVietnamPro().fontFamily.toString(),
              AppColors.darkGrey),
        ],
      ),
      verticalSpacer(10),
      Container(
        width: 330.w,
        height: 1.h,
        color: AppColors.lightGrey,
      ),
      verticalSpacer(5),
    ],
  );
}
