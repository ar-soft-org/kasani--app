
import 'package:flutter/services.dart';
import 'package:kasanipedido/exports/exports.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email=TextEditingController();

  TextEditingController pw=TextEditingController();

  bool isObscure=true;

  @override
  Widget build(BuildContext context) {
      SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
    ));
    return Scaffold(
      appBar: null,
      bottomNavigationBar: null,
      body: Stack(
        children: [
        SizedBox(
          height: 400.h,
          width: 390.w,
          child:Image.asset(
            AppImages.loginbg,
            fit: BoxFit.cover,
          ),
        ),
          Positioned(
            top: 70.h,
            left: 115.w,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                AppImages.logo,
                height: 120.h,
                width: 174.w,

              ),
            ),
          ),

          Container(
            color: AppColors.lightCyan.withOpacity(0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 60.h),
                  child: Container(
                    width: 346.w,
                    height: 391.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.w),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 40.h),
                    child: Column(
                      children: [
                        textField(email,46,296,"Email","email",10,AppColors.tfBg,false,false,false,false,(){}, context),
                        verticalSpacer(10),
                        textField(pw,46,296,"Password","password",10,AppColors.tfBg,false,false,false,isObscure,(){
                        setState(() {
                          isObscure=!isObscure;
                        });

                        }, context),
                        const Spacer(),
                        customButton(context,false,"INGRESAR",16,() {
                          if (email.text == "Vendedor") {
                            Navigator.of(context).pushNamed('vendor');
                            // Get.to(const VendorScreen());
                          }
                        else{
                          Navigator.of(context).pushNamed('host');
                          // Get.to(const HostScreen());
                        }
                        },308,58,Colors.transparent,AppColors.lightCyan,100,showShadow: true),
                        verticalSpacer(20),
                        customText("¿Perdiste tu contraseña?", FontWeight.w600, 16, GoogleFonts.inter.toString(), AppColors.lightCyan),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
