
import 'package:kasanipedido/exports/exports.dart';


Future<void> main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(
      const MyApp()
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'Kasini',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          primaryColor: AppColors.lightCyan,
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home:   const WelcomeScreen(),
      ),
    );
  }
}


