import 'package:kasanipedido/exports/exports.dart';

Widget textField(
  TextEditingController controller,
  double height,
  double width,
  String hintText,
  String indicator,
  double borderRadius,
  Color fillColor,
  bool isShadow,
  bool isSearchIcon,
  bool isShow,
  void Function() onShow,
  BuildContext context, {
  Function()? onTap,
  Color? textColor,
  bool bold = false,
  int? maxLines,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius.r),
    ),
    elevation: isShadow ? 2 : 0,
    child: SizedBox(
        width: width.w,
        height: height.h,
        child: TextField(
          onTap: onTap,
          maxLines: indicator == 'password' || maxLines == 1 ? 1 : null,
          obscureText: indicator == 'password' ? isShow : false,
          cursorColor: AppColors.lightCyan,
          cursorRadius: const Radius.circular(0),
          controller: controller,
          autocorrect: true,
          keyboardType: TextInputType.visiblePassword,
          style:
              TextStyle(fontSize: 14, color: textColor ?? AppColors.greyText),
          decoration: InputDecoration(
            
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.tfBorder,
              ),

                borderRadius: BorderRadius.circular(borderRadius.r)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.tfBorder,
                ),
                borderRadius: BorderRadius.circular(borderRadius.r)),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isShadow == false
                      ? AppColors.tfBorder
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(borderRadius.r)),
            hintText: hintText,
            prefixIcon: isSearchIcon
                ? Image(image: AssetImage(AppImages.search))
                : null,
            suffixIcon: indicator == 'password'
                ? GestureDetector(
                    onTap: onShow,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      child: Text(
                        isShow ? 'Show' : 'Hide',
                        style: TextStyle(
                          color: AppColors.lightCyan,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.inter().fontFamily,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            hintStyle: TextStyle(
                color: AppColors.greyText,
                fontSize: 16.sp,
                fontWeight: bold ? FontWeight.bold : FontWeight.w400,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontStyle: FontStyle.normal),
            fillColor: fillColor,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            filled: true,
          ),
        )),
  );
}
