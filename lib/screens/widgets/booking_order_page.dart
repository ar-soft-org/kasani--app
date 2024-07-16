import '../../exports/exports.dart';
import '../../utils/app_constant.dart';
import '../../widgets/calender.dart';


Widget orderBookingPageView(BuildContext context,void Function() onContinue,String? selectedButton, void Function(String?)? onChange){
  return    Padding(
    padding: EdgeInsets.symmetric(horizontal: 32.w),
    child: SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 5,
                  child: Container(
                    height: 94.h,
                    width: 322.w,
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "  Seleccionar lugar de entrega",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts
                                .beVietnamPro()
                                .fontFamily,
                            fontSize: 14.sp,
                            color: AppColors.darkBlue,
                          ),
                        ),
                        verticalSpacer(5),
                        Container(
                            height: 38.h,




                            decoration: BoxDecoration(
                              color: AppColors.tfBg.withOpacity(
                                  0.8),
                              borderRadius: BorderRadius.circular(
                                  8.r),
                              border: Border.all(
                                  color: AppColors.strokeWhite),
                            ),
                            child: Center(

                                child: dropDown(
                                context, staticList,
                                staticList[0].toString()))),
                      ],
                    ),

                  ),
                ),



            verticalSpacer(5),
            Text(
              "  Seleccionar fecha de entrega",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts
                    .beVietnamPro()
                    .fontFamily,
                fontSize: 14.sp,
                color: AppColors.darkBlue,
              ),
            ),
            verticalSpacer(5),
            Align(
              alignment: Alignment.center,
              child: CalendarScreen(),
            ),
            verticalSpacer(10),
            Text(
              "  Seleccionar franja horaria",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts
                    .beVietnamPro()
                    .fontFamily,
                fontSize: 14.sp,
                color: AppColors.black,
              ),
            ),
            verticalSpacer(5),
            ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                String value = "value_$index";
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: SizedBox(
                    height: 25.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "De 08:00 am a 9:00 am",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts
                                .beVietnamPro()
                                .fontFamily,
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                        Radio(
                          activeColor: AppColors.lightCyan,
                          value: value,
                          groupValue: selectedButton,
                          onChanged: onChange
                        )
                      ],
                    ),
                  ),
                );
              },),
          ]
      ),
    ),);
}
