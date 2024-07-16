
import 'package:kasanipedido/exports/exports.dart';
Widget textField(
    TextEditingController controller,
    double height,double width,
    String hintText,
    String indicator,
    double borderRadius,
    Color fillColor,
    bool isShadow,
    bool onTap,
    bool isSearchIcon,
    bool isShow,
    void Function() onShow
    ) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius.r),
    ),
    elevation:isShadow? 2:0,
    child: SizedBox(
        width: width.w,
        height: height.h,
        child: TextField(
          onTap:onTap?(){
            Get.to(const ContinueHomeScreen());
          }:null ,
          onChanged: (value) {

          },
          maxLines: indicator=="password"?1:null,
          obscureText: indicator=="password"?isShow:false,
          cursorColor: AppColors.lightCyan,
          cursorRadius: const Radius.circular(0),
          controller: controller,
          autocorrect: true,
          keyboardType: TextInputType.visiblePassword,
          style:  const TextStyle(fontSize: 14,color: AppColors.greyText),
          decoration: InputDecoration(
            focusedBorder:  OutlineInputBorder(
                borderSide:  BorderSide(color:isShadow==false? AppColors.tfBorder:Colors.transparent,),
                borderRadius: BorderRadius.circular(borderRadius.r)
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:  BorderSide(color:isShadow==false? AppColors.tfBorder:Colors.transparent,),
                borderRadius: BorderRadius.circular(borderRadius.r)
            ),
            border: OutlineInputBorder(
                borderSide:  BorderSide(color:isShadow==false? AppColors.tfBorder:Colors.transparent,),
                borderRadius: BorderRadius.circular(borderRadius.r)
            ),
            hintText:hintText,
            prefixIcon:isSearchIcon? Image(image: AssetImage(AppImages.search)):null,

            suffixIcon: indicator=="password"?GestureDetector(
                onTap:onShow ,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
                  child: Text(
                    isShow?"Show":"Hide",
                    style: TextStyle(
                      color: AppColors.lightCyan,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                ),
              ):
            const SizedBox(),
            hintStyle: TextStyle(
               color: AppColors.greyText,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontStyle: FontStyle.normal),
            fillColor:fillColor ,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
            filled: true,
          ),
        )),
  );
}