import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/host_home/cubit/host_home_cubit.dart';
import 'package:kasanipedido/order_history/cubit/order_history_cubit.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/widgets/app_bar.dart';
import 'package:kasanipedido/widgets/custom_btn.dart';
import 'package:kasanipedido/widgets/drop_down.dart';
import 'package:kasanipedido/widgets/horizontal_spacer.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderHistoryCubit(
        orderRepository: RepositoryProvider.of<OrderRepository>(context),
      ),
      child: const HistoryView(),
    );
  }
}

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HistoryScreen();
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    final state = context.read<AuthCubit>().state;

    if (state is AuthSuccess) {
      context.read<OrderHistoryCubit>().getOrdersHistory(state.host);
    }
  }

  @override
  void didChangeDependencies() {
    log('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant HistoryScreen oldWidget) {
    log('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final history =
        context.select((OrderHistoryCubit cubit) => cubit.state.history);

    List<String> staticList = [
      'Últimos 7 días',
      'Últimos 14 días',
      'Últimos 30 días',
      'Desde siempre'
    ];
    return MultiBlocListener(
      listeners: [
        BlocListener<HostHomeCubit, HostHomeState>(
          listenWhen: (previous, current) => previous.tab != current.tab,
          listener: (context, state) {
            if (state.tab == HostHomeTab.history) {
              final state = context.read<AuthCubit>().state;

              if (state is AuthSuccess) {
                context.read<OrderHistoryCubit>().getOrdersHistory(state.host);
              }
            }
          },
        ),
        BlocListener<OrderHistoryCubit, OrderHistoryState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.ice,
        appBar: customAppBar(context, 'HISTORIA DE PEDIDOS', false),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: RefreshIndicator(
            onRefresh: () async {
              final state = context.read<AuthCubit>().state;
              if (state is AuthSuccess) {
                context.read<OrderHistoryCubit>().getOrdersHistory(state.host);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                verticalSpacer(40),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 200.0,
                  ),
                  // FIXME:
                  child: CustomDropdown(
                    list: staticList
                        .map((e) =>
                            CustomDropdownMenuItem(value: e, key: e, data: e))
                        .toList(),
                    // staticList[0].toString()
                  ),
                ),
                // ListView.builder(
                //   itemCount: 5,
                //   shrinkWrap: true,
                //   padding: EdgeInsets.only(left: 200.w),
                //   scrollDirection: Axis.vertical,
                //   itemBuilder: (context, index) {
                //     return bulletPoints();
                //   },
                // ),
                verticalSpacer(20),
                Text(
                  'Fecha',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                    fontSize: 14.sp,
                    color: AppColors.sand,
                  ),
                ),
                verticalSpacer(20),
                Container(
                  width: 375.w,
                  height: 1.h,
                  color: AppColors.strokeWhite,
                ),
                verticalSpacer(10),
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return customListWidget(context, item);
                    },
                  ),
                ),
                verticalSpacer(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget customListWidget(BuildContext context, OrderHistory item) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 120.sp),
            child: Text(
              item.fechaHora,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontSize: 14.sp,
                color: AppColors.blackShade,
              ),
            ),
          ),
          horizontalSpacer(40),
          customButton(context, false, 'Ver detalles', 12.sp, () {
            Navigator.of(context)
                .pushNamed('history_detail', arguments: {'orderHistory': item});
          }, 120.sp, 28, Colors.transparent, AppColors.lightCyan, 8,
              showShadow: true),
        ],
      ),
      verticalSpacer(10),
      Container(
        width: 375.w,
        height: 1.h,
        color: AppColors.strokeWhite,
      ),
      verticalSpacer(10),
    ],
  );
}

Widget bulletPoints() {
  return Row(
    children: [
      Container(
        height: 6.h,
        width: 6.w,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
      horizontalSpacer(5),
      Text(
        'Últimos 7 días',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: GoogleFonts.inter().fontFamily,
          fontSize: 14.sp,
          color: AppColors.blackShade,
        ),
      ),
    ],
  );
}
