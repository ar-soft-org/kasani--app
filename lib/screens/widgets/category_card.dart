import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/screens/exports.dart';
import 'package:kasanipedido/shopping_cart/shopping_cart.dart';
import 'package:kasanipedido/shopping_cart/widgets/product_count.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';
import 'package:kasanipedido/widgets/custom_text.dart';
import 'package:kasanipedido/widgets/horizontal_spacer.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

Widget categoryCard(
  String image,
  String title,
  void Function() onTap,
  Color color,
  Color clrText, {
  FontWeight? fontWeight,
}) {
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
            customText(
              title,
              fontWeight ?? FontWeight.w700,
              16,
              GoogleFonts.roboto().fontFamily.toString(),
              clrText,
            ),
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
      height: 80.h,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 44.h,
              width: 50.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: bgColor, width: 1.w),
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.fill)),
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: GoogleFonts.inter().fontFamily,
              fontSize: 8.sp,
              fontWeight: fontWeight,
              color: clrText,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget addItemCard({
  // String? headTitle,
  required String title,
  required String count,
  required String mScale,
  required bool showTopActions,
  required void Function() increment,
  required void Function() decrement,
  void Function(String)? onEdit,
  String? comment,
  ProductData? data,
  required BuildContext context,
  Function()? onCountDelete,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      verticalSpacer(10),
      Padding(
        padding: const EdgeInsets.only(left: 17.0, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                if (showTopActions) ...[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TopActions(comment: comment, data: data),
                  ),
                  SizedBox(height: 8.h),
                ],
                Row(
                  children: [
                    GestureDetector(
                      onTap: decrement,
                      child: Container(
                        width: 27.w,
                        height: 27.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.lightCyan,
                            width: 1.w,
                          ),
                        ),
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
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 35.w),
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (onEdit != null) {
                              final result = await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17.r),
                                    ),
                                    child: ProductCount(
                                      initialQuantity:
                                          data?.quantity.toString() ?? '1',
                                      onDelete: () {
                                        onCountDelete?.call();
                                      },
                                    ),
                                  );
                                },
                              );

                              final quantityResult = result?['quantity'];
                              if (context.mounted && quantityResult != null) {
                                onEdit(quantityResult);
                              }
                            }
                          },
                          child: Text(
                            count,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                              fontSize: 16.sp,
                              color: AppColors.darkBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    horizontalSpacer(10),
                    GestureDetector(
                      onTap: increment,
                      child: Container(
                        width: 27.w,
                        height: 27.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.lightCyan,
                            width: 1.w,
                          ),
                        ),
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
                    customText(
                      getAbbreviatedUnit(mScale),
                      FontWeight.w400,
                      9,
                      GoogleFonts.beVietnamPro().fontFamily.toString(),
                      AppColors.darkGrey,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      verticalSpacer(5),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0),
        child: Container(
          width: 330.w,
          height: 1.h,
          color: AppColors.lightGrey,
        ),
      ),
      verticalSpacer(5),
    ],
  );
}

class TopActions extends StatelessWidget {
  const TopActions({super.key, required this.comment, required this.data});

  final String? comment;
  final ProductData? data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            final shoppingCartBloc = context.read<ShoppingCartBloc>();
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
                                    data: data!.copyWith(observation: '')),
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
                      data: data!.copyWith(observation: commentResult),
                    ),
                  );
            }
          },
          child: Image.asset(
            AppImages.message,
            height: 20.h,
            color: comment != null && comment!.isNotEmpty ? Colors.blue : null,
          ),
        ),
        SizedBox(width: 20.w),
        InkWell(
          onTap: () async {
            // FIXME: add confirm
            final result = await showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    // FIXME: show product name
                    content: const Text('Está seguro de borrar este producto?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Borrar')),
                    ],
                  );
                });

            if (context.mounted && result == true) {
              context
                  .read<ShoppingCartBloc>()
                  .add(ShoppingCartProductDataDeleted(id: data!.productId));
            }
          },
          child: Image.asset(AppImages.deleteIcon,
              height: 19.h, color: const Color(0xff009ebf)),
        )
      ],
    );
  }
}
