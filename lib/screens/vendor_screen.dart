
import 'package:kasanipedido/exports/exports.dart';
class VendorScreen extends StatelessWidget {

  const VendorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: AppColors.ice,
      appBar:AppBar(
        title: Text("INFORMACIÓN",style: TextStyle(color: AppColors.darkBlue,fontFamily: GoogleFonts.inter().fontFamily,fontWeight: FontWeight.w600,fontSize: 17.sp),),
        centerTitle: true,
        elevation: 2,
        shadowColor:AppColors.ice,
        bottomOpacity: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.darkBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                verticalSpacer(20),
                Text(
                  "5 de Junio 2024",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontSize: 14.sp,
                    color: AppColors.blackShade.withOpacity(0.9),
                  ),
                ),
                verticalSpacer(20),
                Row(
                  children: [
                    Text(
                      "Estado",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                        fontSize: 14.sp,
                        color: AppColors.sand,
                      ),
                    ),
                    horizontalSpacer(40),
                    Text(
                      "Nombre",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontSize: 14.sp,
                        color: AppColors.sand,
                      ),
                    ),
                  ],
                ),
                verticalSpacer(10),
                Container(width: 375.w,height: 1.h,color: AppColors.strokeWhite,),
                verticalSpacer(10),
                ListView.builder(
                  itemCount: 8,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return   customListWidget(context);
                  },),
                verticalSpacer(20),

              ],
            ),
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
            "Sí",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontSize: 14.sp,
              color: AppColors.blackShade.withOpacity(0.9),
            ),
          ),
          horizontalSpacer(75),
          Text(
            "Fito Perez",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
          horizontalSpacer(40),
          customButton(context,false,"Crear Pedido",11,(){
            Get.to(const HostScreen());
          },90,28,Colors.transparent,AppColors.lightCyan,100,showShadow: true),
        ],
      ),
      verticalSpacer(10),
      Container(width: 375.w,height: 1.h,color: AppColors.strokeWhite,),
      verticalSpacer(10),
    ],
  );
}