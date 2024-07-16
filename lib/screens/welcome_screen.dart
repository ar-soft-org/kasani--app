import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kasanipedido/exports/exports.dart';


class WelcomeScreen extends StatelessWidget {

  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(

      statusBarColor: AppColors.black,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor:AppColors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return   Scaffold(
      backgroundColor: Colors.transparent,
      appBar:null,
      body:  Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
           AppImages.bg,
            fit: BoxFit.contain,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpacer(50),

              Image.asset(AppImages.logo,),
              const Spacer(),
              customButton(context,false,"INGRESAR",16,() {
                Navigator.of(context).push(SlideBottomToTopPageRoute(page: const SplashScreen()));
              },308,58,Colors.transparent,AppColors.lightCyan,100,showShadow: true),
              verticalSpacer(75),
            ],
          ),
        ],
      ),

    );
  }
}