import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/exports/exports.dart';
import 'package:kasanipedido/order_booking/bloc/order_booking_bloc.dart';
import 'package:kasanipedido/shopping_cart/shopping_cart.dart';
import 'package:kasanipedido/vendor/bloc/vendor_bloc.dart';

class OrderBookingPage extends StatelessWidget {
  const OrderBookingPage({super.key});

  static Widget initWithVendorBloc(
    BuildContext context,
    VendorBloc bloc,
    ShoppingCartBloc shoppingCartBloc,
  ) {
    return BlocProvider.value(
      value: bloc,
      child: OrderBookingPage.init(context, shoppingCartBloc),
    );
  }

  static init(BuildContext context, ShoppingCartBloc shoppingCartBloc) {
    return MultiBlocProvider(providers: [
      BlocProvider.value(value: shoppingCartBloc),
      BlocProvider(
        create: (_) => OrderBookingBloc(
          orderBookingRepository:
              RepositoryProvider.of<OrderRepository>(context),
        ),
      ),
    ], child: const OrderBookingPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => OrderBookingBloc(
              orderBookingRepository:
                  RepositoryProvider.of<OrderRepository>(context),
            ),
        child: const OrderBookingView());
  }
}

class OrderBookingView extends StatelessWidget {
  const OrderBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderBookingScreen();
  }
}

class OrderBookingScreen extends StatefulWidget {
  const OrderBookingScreen({super.key});

  @override
  State<OrderBookingScreen> createState() => _OrderBookingScreenState();
}

class _OrderBookingScreenState extends State<OrderBookingScreen> {
  String? _selectedValue;
  PageController? _pageController;

  late GlobalKey<FormState> formKey;

  int _currentPage = 0;
  void _nextPage() {
    final isValid = validateByStep(_currentPage);

    if (!isValid) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Complete toda la información')));
      return;
    }

    if (_currentPage < 2) {
      _pageController!.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();

    _pageController = PageController();
    _pageController!.addListener(() {
      setState(() {
        // context.read();
        _currentPage = _pageController!.page!.round();
      });
    });

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthHostSuccess) {
      context.read<OrderBookingBloc>().add(OrderBookingSubsidiariesRequested(
          subsidiaries: authState.host.locales));
    } else if (authState is AuthVendorSuccess) {
      final vendorState = context.read<VendorBloc>().state as VendorState?;
      if (vendorState != null && vendorState.currentClient != null) {
        context.read<OrderBookingBloc>().add(OrderBookingSubsidiariesRequested(
            subsidiaries: vendorState.currentClient!.locales));
      }
    } else {
      throw UnimplementedError();
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  bool validateByStep(int currentStep) {
    final state = context.read<OrderBookingBloc>().state;
    switch (currentStep) {
      case 0:
        return state.isStepOneCompleted;
      case 1:
        return true;
      default:
        throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final createOrderStatus =
        context.select((OrderBookingBloc bloc) => bloc.state.createOrderStatus);

    return Scaffold(
      backgroundColor: _currentPage == 2 ? Colors.white : AppColors.ice,
      appBar: customAppBar(
          context,
          _currentPage == 0
              ? 'Datos de Entrega'
              : _currentPage == 1
                  ? 'Datos del Pedido'
                  : '',
          _currentPage == 2 ? false : true),
      body: BlocListener<OrderBookingBloc, OrderBookingState>(
        listenWhen: (previous, current) {
          return previous.errorMessage != current.errorMessage ||
              previous.createOrderStatus != current.createOrderStatus;
        },
        listener: (context, state) {
          if (state.createOrderStatus == CreateOrderStatus.success) {
            /// clear shopping cart
            context
                .read<ShoppingCartBloc>()
                .add(const ShoppingCartAllDataCleared());
            if (_currentPage >= 1) {
              Navigator.of(context).pushReplacementNamed('order_completed');
            } else {
              _nextPage();
            }
          }
          if (state.errorMessage != '') {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            verticalSpacer(30),
            buildIndicator(_currentPage),
            verticalSpacer(10),
            Expanded(
              child: Center(
                child: PageView(
                  physics: isLastPage
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  controller: _pageController,
                  children: [
                    OrderBookingPageView(
                      selectedButton: _selectedValue,
                      onChange: (selected) {
                        setState(() {
                          _selectedValue = selected;
                        });
                      },
                    ),
                    OrderDetailedPageView(
                      formKey: formKey,
                      onSavedComment: (String value) {
                        context
                            .read<OrderBookingBloc>()
                            .add(OrderBookingCommentSaved(comment: value));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _currentPage == 2
          ? const SizedBox.shrink()
          : Container(
              height: 110.h,
              padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 10.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60.r),
                      topRight: Radius.circular(60.r))),
              child: Center(
                child: customButton(
                    context,
                    false,
                    _currentPage == 0
                        ? 'Continuar'
                        : createOrderStatus == CreateOrderStatus.loading
                            ? 'Creando Pedido'
                            : 'Finalizar Pedido',
                    16, () {
                  if (createOrderStatus == CreateOrderStatus.loading) {
                    return;
                  }

                  if (_currentPage >= 1) {
                    // capture comment
                    formKey.currentState?.save();

                    log('create order');
                    final state = context.read<AuthCubit>().state;
                    final productsData = context.read<ShoppingCartBloc>().state;

                    if (state is AuthHostSuccess) {
                      context
                          .read<OrderBookingBloc>()
                          .add(OrderBookingOrderCreated(
                            user: state.host,
                            clientId: state.host.idCliente,
                            email: state.host.correo,
                            productsData:
                                productsData.productsData.values.toList(),
                          ));
                    } else if (state is AuthVendorSuccess) {
                      final VendorState? vendorState =
                          context.read<VendorBloc>().state;
                      context
                          .read<OrderBookingBloc>()
                          .add(OrderBookingOrderCreated(
                            user: state.vendor,
                            employeId: state.vendor.idEmpleado,
                            clientId: vendorState?.currentClient?.idCliente,
                            // FIXME: Consultar que email se debe enviar
                            email: state.vendor.correo,
                            productsData:
                                productsData.productsData.values.toList(),
                          ));
                    } else {
                      throw UnimplementedError();
                    }
                    // navigation through listener

                    return;
                  }

                  _nextPage();
                }, 308, 55, Colors.transparent, AppColors.lightCyan, 100,
                    showShadow: true),
              ),
            ),
    );
  }

  bool get isLastPage {
    return _currentPage == 2;
  }
}
