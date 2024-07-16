import '../../exports/exports.dart';


Widget orderCompletePageView() {
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
      customText("Pedido registrado", FontWeight.w700, 20,
          GoogleFonts.beVietnamPro().fontFamily.toString(), AppColors.black),
      verticalSpacer(10),
      customText(
          "Puedes visualizar tu pedido en el historial",
          FontWeight.w500,
          14,
          GoogleFonts.beVietnamPro().fontFamily.toString(),
          AppColors.black),
      verticalSpacer(100),
    ],
  );
}
