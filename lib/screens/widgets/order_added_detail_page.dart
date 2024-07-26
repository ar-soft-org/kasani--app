import '../../exports/exports.dart';
import '../../utils/app_constant.dart';
import '../history_detail_screen.dart';


Widget orderDetailedPageView(BuildContext context,TextEditingController controller,
    void Function() onContinue,List<int> counts,void Function() onChange,void Function()
    onChangeIncrement){
  return  Padding(
    padding:  EdgeInsets.symmetric(horizontal: 20.w),
    child: SingleChildScrollView(

      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpacer(20),
                customText("Mi pedido", FontWeight.w600, 12, GoogleFonts.beVietnamPro().fontFamily.toString(),Color(0XFF1B1B1B)),
                SizedBox(
                  height: 160.h,
                  child: ListView.builder(
                    itemCount: counts.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {

                      return   addItemCard("Langostinos. eget lectus lobortis viverra.",counts[index].toString(),"Kg",
                          true,true,   (){
                            if (counts[index] > 0) {
                              --counts[index];
                            }
                            onChange();
                          },
                              (){
                            ++counts[index];
                            onChangeIncrement();
                          });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: customButton(context,true,"Continuar comprando",12,() {
                  },175,31,Colors.transparent,AppColors.blue,8,showShadow: true),
                ),
                verticalSpacer(10),
                customText("Mensaje", FontWeight.w600, 12, GoogleFonts.beVietnamPro().fontFamily.toString(),Color(0XFF1B1B1B)),
                verticalSpacer(5),
                textField(controller,78,356,"","",8,Colors.white,true,false,false,false,(){}, context),
                verticalSpacer(15),
                Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined,color: Color(0xff5985E1),),
                    horizontalSpacer(15),
                    customText("Datos de entrega", FontWeight.w500, 14, GoogleFonts.beVietnamPro().fontFamily.toString(),AppColors.black),
                  ],
                ),
                verticalSpacer(10),
                detailHeading("Fecha de entrega: ", "30/05"),
                detailHeading("Hora de entrega:  ", "De 11: 00 am a 1: 00 pm"),
                detailHeading("Lugar de entrega: ", " Local Socabaya"),


              ],
            ),
    ),


  );
}
