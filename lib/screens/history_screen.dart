import 'package:kasanipedido/exports/exports.dart';

class HistoryScreen extends StatelessWidget {

  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    List<String> staticList = [
      "Últimos 7 días",
      "Últimos 14 días",
      "Últimos 30 días",
      "Desde siempre"
    ];
    return   Scaffold(
      backgroundColor: AppColors.ice,
      appBar:customAppBar(context,"HISTORIA DE PEDIDOS",false),
      body:  Padding(
        padding:  EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalSpacer(40),
            Padding(
              padding: const EdgeInsets.only(left: 200.0,),
              child: dropDown(context,staticList,staticList[0].toString()),
            ),
            ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 200.w),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return   bulletPoints();
                },),

            verticalSpacer(20),
            Text(
              "Fetcha",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                fontSize: 14.sp,
                color: AppColors.sand,
              ),
            ),

            verticalSpacer(20),

            Container(width: 375.w,height: 1.h,color: AppColors.strokeWhite,),
            verticalSpacer(10),
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return   customListWidget(context);
              },),
            verticalSpacer(20),

          ],
        ),
      ),

    );
  }
}
Widget customListWidget(BuildContext context){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "1 Jun",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontSize: 14.sp,
              color: AppColors.blackShade,
            ),
          ),

          horizontalSpacer(40),
          customButton(context,false,"Ver detalles",12,(){
            Navigator.of(context).pushNamed('history_detail');
            // Get.to(const HistoryDetailScreen());
          },100,28,Colors.transparent,AppColors.lightCyan,8,showShadow: true),
        ],
      ),
      verticalSpacer(10),
      Container(width: 375.w,height: 1.h,color: AppColors.strokeWhite,),
      verticalSpacer(10),
    ],
  );
}
Widget bulletPoints(){
  return Row(
    children: [
      Container(
        height: 6.h,
        width:6.w,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
      horizontalSpacer(5),
      Text(
        "Últimos 7 días",
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: GoogleFonts.inter().fontFamily,
          fontSize: 14.sp,
          color: AppColors.blackShade,
        ),
      ),

    ],
  );
}