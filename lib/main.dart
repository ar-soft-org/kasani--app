import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/config/providers/bloc_providers.dart';
import 'package:kasanipedido/config/providers/repository_providers.dart';
import 'package:kasanipedido/config/providers/service_providers.dart';
import 'package:kasanipedido/config/router/app_router.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/navigation_keys.dart';

Future<void> main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: ServiceProviders(
        child: RepositoryProviders(
          child: BlocProviders(
            child: MaterialApp(
              navigatorKey: mainNav,
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.initialRoute,
              routes: AppRoutes.routes,
              title: 'Kasini',
              theme: ThemeData(
                useMaterial3: false,
                primaryColor: AppColors.lightCyan,
                textTheme: GoogleFonts.interTextTheme(
                  Theme.of(context).textTheme,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
