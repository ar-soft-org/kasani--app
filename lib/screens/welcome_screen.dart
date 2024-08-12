import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasanipedido/screens/animation.dart';
import 'package:kasanipedido/screens/splash_screen.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';
import 'package:kasanipedido/widgets/custom_btn.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.black,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: null,
      body: Stack(
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
              Image.asset(
                AppImages.logo,
              ),
              const Spacer(),
              customButton(context, false, "INGRESAR", 16, () {
                Navigator.of(context).push(
                    SlideBottomToTopPageRoute(page: const SplashScreen()));
              }, 308, 58, Colors.transparent, AppColors.lightCyan, 100,
                  showShadow: true),
              verticalSpacer(75),
            ],
          ),
        ],
      ),
    );
  }
}
