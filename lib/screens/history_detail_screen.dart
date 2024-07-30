import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/order_history_detail/cubit/order_history_detail_cubit.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/widgets/app_bar.dart';
import 'package:kasanipedido/widgets/custom_text.dart';
import 'package:kasanipedido/widgets/horizontal_spacer.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';

class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final map =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final orderHistory = map['orderHistory'] as OrderHistory?;

    if (orderHistory == null) {
      throw Exception('orderHistory not found in map argument');
    }

    return BlocProvider(
      create: (context) => OrderHistoryDetailCubit(
        orderHistory: orderHistory,
        orderRepository: RepositoryProvider.of<OrderRepository>(context),
      ),
      child: const HistoryDetailView(),
    );
  }
}

class HistoryDetailView extends StatelessWidget {
  const HistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HistoryDetailScreen();
  }
}

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({super.key});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    final state = context.read<AuthCubit>().state;

    if (state is AuthSuccess) {
      context.read<OrderHistoryDetailCubit>().getOrderHistoryDetail(state.host);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail =
        context.select((OrderHistoryDetailCubit cubit) => cubit.state.detail);

    final status =
        context.select((OrderHistoryDetailCubit cubit) => cubit.state.status);

    return BlocListener<OrderHistoryDetailCubit, OrderHistoryDetailState>(
      listenWhen: (previous, current) {
        return previous.errorMessage != current.errorMessage;
      },
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.ice,
        appBar: customAppBar(context, 'HISTORIA DE PEDIDOS', true),
        body: RefreshIndicator(
          onRefresh: () async {
            final state = context.read<AuthCubit>().state;

            if (state is AuthSuccess) {
              context
                  .read<OrderHistoryDetailCubit>()
                  .getOrderHistoryDetail(state.host);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                verticalSpacer(40),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 10,
                  child: Container(
                    height: 180.h,
                    width: 335.w,
                    padding: EdgeInsets.symmetric(horizontal: 0.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customText(
                              'Datos de entrega',
                              FontWeight.w500,
                              14,
                              GoogleFonts.beVietnamPro().fontFamily.toString(),
                              AppColors.black),
                          verticalSpacer(10),
                          detailHeading(
                              'Fecha de entrega: ', detail?.fechaEntrega ?? ''),
                          detailHeading(
                              'Hora de entrega:  ', detail?.horaEntrega ?? ''),
                          detailHeading(
                              'Lugar de entrega: ', detail?.lugarEntrega ?? ''),
                        ],
                      ),
                    ),
                  ),
                ),
                verticalSpacer(20),
                Row(
                  children: [
                    Text(
                      'Mi pedido',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                        fontSize: 14.sp,
                        color: AppColors.black,
                      ),
                    ),
                    if (status == OrderHistoryDetailStatus.loading) ...[
                      SizedBox(width: 10.w),
                      SizedBox(
                          height: 10.sp,
                          width: 10.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.sp,
                          ))
                    ]
                  ],
                ),
                verticalSpacer(0),
                if (detail != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: detail.detalle.length,
                      itemBuilder: (_, index) {
                        final item = detail.detalle[index];
                        return historyItemCard(item.nombreProducto,
                            item.cantidad, item.unidadMedida);
                      },
                    ),
                  ),
                // historyItemCard(
                //     'In et eros eget lectus lobortis viverra.', '10', 'Doc'),
                // historyItemCard(
                //     'In et eros eget lectus lobortis viverra.', '9', 'kg'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget historyItemCard(String title, String count, String mScale) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      verticalSpacer(10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Langostino Jumbo',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontSize: 16.sp,
                  color: AppColors.lightCyan,
                ),
              ),
              Text(
                title,
                maxLines: null,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontSize: 16.sp,
                  color: AppColors.darkBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
              horizontalSpacer(8),
              customText(
                  mScale,
                  FontWeight.w400,
                  11,
                  GoogleFonts.beVietnamPro().fontFamily.toString(),
                  AppColors.darkGrey),
            ],
          ),
        ],
      ),
      verticalSpacer(10),
      Container(
        width: 330.w,
        height: 1.h,
        color: AppColors.lightGrey,
      ),
      verticalSpacer(5),
    ],
  );
}

Widget detailHeading(String title, String detail) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(title, FontWeight.w600, 16,
            GoogleFonts.beVietnamPro().fontFamily.toString(), AppColors.black),
        Flexible(
          child: customText(
              detail,
              FontWeight.w400,
              14,
              GoogleFonts.beVietnamPro().fontFamily.toString(),
              AppColors.black),
        ),
      ],
    ),
  );
}
