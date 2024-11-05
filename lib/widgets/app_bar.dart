import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';

import '../exports/exports.dart';

import '../exports/exports.dart';

AppBar customAppBar(
  BuildContext context,
  String title,
  bool isBack, {
  Function()? onPressed,
  bool clearSearchOnBack = false, // Nuevo parámetro con valor predeterminado
}) {
  final homeCubit = BlocProvider.of<HomeCubit>(context);

  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        color: AppColors.white,
        fontFamily: GoogleFonts.inter().fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 17.sp,
      ),
    ),
    centerTitle: true,
    elevation: 2,
    bottomOpacity: 0,
    backgroundColor: AppColors.appBar,
    leading: isBack
        ? IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              color: AppColors.white,
              size: 17,
            ),
            onPressed: onPressed ??
                () {
                  if (clearSearchOnBack) {
                    homeCubit.searchController.clear(); 
                  }
                  Navigator.of(context).pop();
                },
          )
        : GestureDetector(
            onTap: null,
            child: const Icon(
              Icons.arrow_back_ios_outlined,
              color: AppColors.appBar,
              size: 17,
            ),
          ),
  );
}
