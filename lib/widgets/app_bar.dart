import '../exports/exports.dart';

AppBar customAppBar(
  BuildContext context,
  String title,
  bool isBack, {
  Function()? onPressed,
}) {
  return AppBar(
      title: Text(
        title,
        style: TextStyle(
            color: AppColors.white,
            fontFamily: GoogleFonts.inter().fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 17.sp),
      ),
      centerTitle: true,
      elevation: 2,
      bottomOpacity: 0,
      backgroundColor: AppColors.appBar,
leading: isBack
    ? IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_outlined,
          color: AppColors.white,
          size: 17,
        ),
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
      )
    : GestureDetector(
        onTap: null, // No tendrá acción
        child: const Icon(
          Icons.arrow_back_ios_outlined,
          color: AppColors.appBar,
          size: 17,
        ),
      ),
);
}
