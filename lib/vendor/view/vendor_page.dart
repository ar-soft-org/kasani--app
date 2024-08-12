import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/domain/repository/client/client_repository.dart';
import 'package:kasanipedido/domain/repository/client/models/client.dart';
import 'package:kasanipedido/utils/app_route_names.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/vendor/bloc/vendor_bloc.dart';
import 'package:kasanipedido/widgets/UIKit/Standard/Atoms/custom_button.dart';
import 'package:kasanipedido/widgets/custom_btn.dart';
import 'package:kasanipedido/widgets/horizontal_spacer.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';

class VendorPage extends StatelessWidget {
  const VendorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VendorBloc(
          clientRepository: RepositoryProvider.of<ClientRepository>(context)),
      child: const VendorView(),
    );
  }
}

class VendorView extends StatelessWidget {
  const VendorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const VendorScreen();
  }
}

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  final now = DateTime.now();
  final df = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthCubit>().state;

    if (authState is AuthVendorSuccess) {
      context
          .read<VendorBloc>()
          .add(LoadClientsEvent(vendor: authState.vendor));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ice,
      appBar: AppBar(
        title: Text(
          'INFORMACIÓN',
          style: TextStyle(
              color: AppColors.darkBlue,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 17.sp),
        ),
        centerTitle: true,
        elevation: 2,
        shadowColor: AppColors.ice,
        bottomOpacity: 0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppRouteNames.profilePage);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Icon(
                Icons.person,
                color: AppColors.darkBlue,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<VendorBloc, VendorState>(
        listenWhen: (previous, current) =>
            current.errorMessage != null && current.errorMessage != '' ||
            current.currentClient != null,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                ),
              );
          }

          if (state.currentClient != null) {
            Navigator.of(context).pushNamed('host', arguments: {
              'client': state.currentClient,
              'bloc': context.read<VendorBloc>(),
            });
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.clients.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('La lista de clientes está vacía.'),
                  SizedBox(height: 20.h),
                  const Text('Por favor, intente de nuevo.'),
                  SizedBox(height: 10.h),
                  MyButton(
                    text: 'Recargar',
                    onPressed: () {
                      final authState = context.read<AuthCubit>().state;

                      if (authState is AuthVendorSuccess) {
                        context
                            .read<VendorBloc>()
                            .add(LoadClientsEvent(vendor: authState.vendor));
                        return;
                      }

                      throw UnimplementedError();
                    },
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final authState = context.read<AuthCubit>().state;

              if (authState is AuthVendorSuccess) {
                context
                    .read<VendorBloc>()
                    .add(LoadClientsEvent(vendor: authState.vendor));
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  verticalSpacer(20),
                  Text(
                    df.format(now),
                    // '5 de Junio 2024',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: 14.sp,
                      color: AppColors.blackShade.withOpacity(0.9),
                    ),
                  ),
                  verticalSpacer(20),
                  Row(
                    children: [
                      Text(
                        'Estado',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                          fontSize: 14.sp,
                          color: AppColors.sand,
                        ),
                      ),
                      horizontalSpacer(40),
                      Text(
                        'Nombre',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontSize: 14.sp,
                          color: AppColors.sand,
                        ),
                      ),
                    ],
                  ),
                  verticalSpacer(10),
                  Container(
                    width: 375.w,
                    height: 1.h,
                    color: AppColors.strokeWhite,
                  ),
                  verticalSpacer(10),
                  ListView.builder(
                    itemCount: state.clients.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = state.clients[index];
                      return customListWidget(context, item: item);
                    },
                  ),
                  verticalSpacer(20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget customListWidget(
  BuildContext context, {
  required Client item,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // 'Sí',
            '--',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.inter().fontFamily,
              fontSize: 14.sp,
              color: AppColors.blackShade.withOpacity(0.9),
            ),
          ),
          horizontalSpacer(75),
          Flexible(
            child: Text(
              item.nombres,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontSize: 14.sp,
                color: Colors.black,
              ),
            ),
          ),
          horizontalSpacer(40),
          customButton(context, false, 'Crear Pedido', 11, () {
            /// navigation handle in bloc listener
            context.read<VendorBloc>().add(SelectClientEvent(client: item));
          }, 120, 28, Colors.transparent, AppColors.lightCyan, 100,
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
