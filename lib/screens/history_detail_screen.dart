import 'package:kasanipedido/exports/exports.dart';

import '../widgets/drop_down.dart';

class HistoryDetailScreen extends StatelessWidget {

  const HistoryDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {

    return   Scaffold(
      backgroundColor: AppColors.ice,
      appBar:customAppBar(context,"HISTORIA DE PEDIDOS",true),
      body:  Padding(
        padding:  EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalSpacer(40),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 10,
              child: Container(
                height: 180.h,
                width: 335.w,
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding:  EdgeInsets.only(left: 30.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText("Datos de entrega", FontWeight.w500, 14, GoogleFonts.beVietnamPro().fontFamily.toString(),AppColors.black),
                      verticalSpacer(10),
                      detailHeading("Fecha de entrega: ", "30/05"),
                      detailHeading("Hora de entrega:  ", "De 11: 00 am a 1: 00 pm"),
                      detailHeading("Lugar de entrega: ", " Local Socabaya"),
                    ],
                  ),
                ),
              ),
            ),
            verticalSpacer(20),
            Text(
              "Mi pedido",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                fontSize: 14.sp,
                color: AppColors.black,
              ),
            ),

            verticalSpacer(0),

            historyItemCard("In et eros eget lectus lobortis viverra.","10","Doc"),
            historyItemCard("In et eros eget lectus lobortis viverra.","9","kg"),
          ],
        ),
      ),

    );
  }
}

Widget historyItemCard(String title,String count,String mScale){
  return  Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      verticalSpacer(10),
      Row(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           Text(
                "Langostino Jumbo",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontSize: 16.sp,
                  color: AppColors.lightCyan,
                ),
              ),
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

          const Spacer(),
          Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              horizontalSpacer(8),
              customText(mScale, FontWeight.w400, 11, GoogleFonts.beVietnamPro().fontFamily.toString(), AppColors.darkGrey),

            ],
          ),



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
Widget detailHeading(String title,String detail){
  return   Padding(
    padding:  EdgeInsets.symmetric(horizontal: 0.w,vertical: 4.h),
    child: Row(
      children: [
        customText(title, FontWeight.w600, 16, GoogleFonts.beVietnamPro().fontFamily.toString(),AppColors.black),
        customText(detail, FontWeight.w400, 14, GoogleFonts.beVietnamPro().fontFamily.toString(),AppColors.black),
      ],
    ),
  );
}