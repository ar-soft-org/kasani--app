import 'dart:async';
import 'package:kasanipedido/exports/exports.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).push(SlideBottomToTopPageRoute(page:  LoginScreen()));

    });
    return   Scaffold(
      backgroundColor: Colors.transparent, // Dark background color
      appBar:null,
      body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppImages.secondBg,
          fit: BoxFit.cover,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.logo,height: 200.h,width: 159.w,fit: BoxFit.fitHeight),
          ],
        ),
      ],
    ),

    );
  }
}