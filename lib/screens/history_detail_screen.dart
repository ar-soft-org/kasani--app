import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/host_home/cubit/host_home_cubit.dart';
import 'package:kasanipedido/order_history_detail/cubit/order_history_detail_cubit.dart';
import 'package:kasanipedido/screens/home_screen.dart';
import 'package:kasanipedido/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/widgets/UIKit/Standard/Atoms/bottom_button.dart';
import 'package:kasanipedido/widgets/app_bar.dart';
import 'package:kasanipedido/widgets/custom_text.dart';
import 'package:kasanipedido/widgets/horizontal_spacer.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtiene los argumentos desde el HostHomeCubit
    final orderHistory = context
        .read<HostHomeCubit>()
        .getArguments()?['orderHistory'] as OrderHistory?;

    if (orderHistory == null) {
      return Scaffold(
        appBar: customAppBar(context, 'Detalle del Pedido', true),
        body: Center(
          child: Text("No se encontraron detalles del pedido."),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OrderHistoryDetailCubit(
            orderHistory: orderHistory,
            orderRepository: RepositoryProvider.of<OrderRepository>(context),
            shoppingCartRepository:
                RepositoryProvider.of<ShoppingCartRepository>(context),
          ),
        ),
        BlocProvider(
          create: (_) => ShoppingCartBloc(
            shoppingCartRepository:
                RepositoryProvider.of<ShoppingCartRepository>(context),
          )
            ..add(const ShoppingCartSubscriptionRequested())
            ..add(const ShoppingCartProductsDataRequested()),
        ),
      ],
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
    getOrderHistoryDetail(state);
  }

  void getOrderHistoryDetail(AuthState state) {
    if (state is AuthHostSuccess) {
      context.read<OrderHistoryDetailCubit>().getOrderHistoryDetail(state.host);
    } else if (state is AuthVendorSuccess) {
      context.read<OrderHistoryDetailCubit>().getOrderHistoryDetail(
            state.vendor,
            employeeId: state.vendor.idEmpleado,
          );
    } else {
      throw Exception('Invalid AuthState');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final navigateToHistoryScreen = args?['navigateToHistoryScreen'] ?? false;

    final detail =
        context.select((OrderHistoryDetailCubit cubit) => cubit.state.detail);
    final status =
        context.select((OrderHistoryDetailCubit cubit) => cubit.state.status);
    final cartState = context.select((ShoppingCartBloc bloc) => bloc.state);

    return WillPopScope(
      onWillPop: () async {
        if (navigateToHistoryScreen) {
          Navigator.of(context).pushReplacementNamed('history_screen');
          return false; // Intercepta el retroceso para ir a `history_screen`
        }
        return true; // Permite el retroceso normal si no hay argumento
      },
      child: BlocListener<OrderHistoryDetailCubit, OrderHistoryDetailState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.message != current.message,
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state.message != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.ice,
          appBar:
              customAppBar(context, 'HISTORIA DE PEDIDOS', true, onPressed: () {
            context.read<HostHomeCubit>().setTab(HostHomeTab.history);
          }),
          body: RefreshIndicator(
            onRefresh: () async {
              final state = context.read<AuthCubit>().state;
              getOrderHistoryDetail(state);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  verticalSpacer(10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 1,
                    child: Container(
                      height: 140.h,
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
                              AppColors.black,
                            ),
                            verticalSpacer(10),
                            detailHeading('Fecha de entrega: ',
                                detail?.fechaEntrega ?? ''),
                            detailHeading('Hora de entrega:  ',
                                detail?.horaEntrega ?? ''),
                            detailHeading('Lugar de entrega: ',
                                detail?.lugarEntrega ?? ''),
                          ],
                        ),
                      ),
                    ),
                  ),
                  verticalSpacer(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Row(
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
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                  verticalSpacer(0),
                  if (detail != null)
                    Expanded(
                      child: ListView.builder(
                        itemCount: detail.detalle.length,
                        itemBuilder: (_, index) {
                          final item = detail.detalle[index];
                          return historyItemCard(
                            item.nombreProducto,
                            item.cantidad,
                            item.unidadMedida,
                          );
                        },
                      ),
                    ),
                  verticalSpacer(20),
                  if (detail != null && detail.detalle.isNotEmpty)
                    BottomButon(
                      label: 'Volver a pedir',
                      onPressed: () async {
                        bool result = true;
                        if (cartState.productsData.isNotEmpty) {
                          final r = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('¿Estás seguro?'),
                                content: const Text(
                                  'Si vuelves a pedir, se eliminarán los productos actuales de tu carrito.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                ],
                              );
                            },
                          );

                          result = r == true;
                        }

                        if (!result || !mounted) return;

                        context.read<OrderHistoryDetailCubit>().orderAgain();

                        context
                            .read<HostHomeCubit>()
                            .setTab(HostHomeTab.history);
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget historyItemCard(String title, String count, String mScale) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacer(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 110.w,
              height: 30.h,
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        count,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontSize: 16.sp,
                          color: AppColors.darkBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    horizontalSpacer(8),
                    Flexible(
                      flex: 2,
                      child: customText(
                        getAbbreviatedUnit(mScale),
                        FontWeight.w400,
                        11,
                        GoogleFonts.beVietnamPro().fontFamily.toString(),
                        AppColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        verticalSpacer(10),
        Container(
          width: double.infinity,
          height: 1.h,
          color: AppColors.lightGrey,
        ),
        verticalSpacer(5),
      ],
    ),
  );
}

Widget detailHeading(String title, String detail) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(title, FontWeight.w500, 11,
            GoogleFonts.beVietnamPro().fontFamily.toString(), AppColors.black),
        Flexible(
          child: customText(
              detail,
              FontWeight.w500,
              11,
              GoogleFonts.beVietnamPro().fontFamily.toString(),
              AppColors.black),
        ),
      ],
    ),
  );
}
