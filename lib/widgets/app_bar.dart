
import '../exports/exports.dart';
AppBar customAppBar(BuildContext context,String title,bool isBack){
  return  AppBar(
  title: Text(title,style: TextStyle(color: AppColors.darkBlue,fontFamily: GoogleFonts.inter().fontFamily,fontWeight: FontWeight.w600,fontSize: 17.sp),),
  centerTitle: true,
  elevation: 2,
  shadowColor:AppColors.ice,
  bottomOpacity: 0,
  backgroundColor: Colors.white,
  leading: isBack?IconButton(
  icon: const Icon(Icons.arrow_back_ios_outlined, color: AppColors.darkBlue),
  onPressed: () => Navigator.of(context).pop(),
  ):null
  );
}
