import 'package:kasanipedido/exports/exports.dart';
class ProfileScreen extends StatelessWidget {

  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {

    return   Scaffold(
      backgroundColor: AppColors.ice,
      appBar:customAppBar(context,"INFORMACIÓN",false),
      body:  Padding(
        padding:  EdgeInsets.symmetric(horizontal: 36.w,vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalSpacer(40),
            Container(
              width: 320.w,
              height: 90.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(
                    AppImages.profile,
                  ),
                  fit: BoxFit.fill
                )
              ),
            ),
            verticalSpacer(20),
            profileCategoryTile("Mi perfil",(){

            }),
            profileCategoryTile("Historial de pedidos", (){
              Navigator.of(context).pushNamed('history_screen');
              // Get.to(const HistoryScreen());

                }),
          ],
        ),
      ),

    );
  }
}
Widget profileCategoryTile(String title,  void Function() onTap){
  return   Padding(
    padding:  EdgeInsets.only(left:10.w,right: 75.w,top: 30.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(title, FontWeight.w400, 14, GoogleFonts.beVietnamPro().fontFamily.toString(),
            AppColors.black),

         GestureDetector(
             onTap: onTap,
             child: const Icon(Icons.arrow_forward_ios_outlined, color: AppColors.black,size: 18,)),
      ],
    ),
  );
}