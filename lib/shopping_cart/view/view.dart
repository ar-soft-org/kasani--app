import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/host_home/cubit/host_home_cubit.dart';
import 'package:kasanipedido/screens/widgets/category_card.dart';
import 'package:kasanipedido/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:kasanipedido/shopping_cart/shopping_cart.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/widgets/app_bar.dart';
import 'package:kasanipedido/widgets/custom_btn.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShoppingCartBloc(
        shoppingCartRepository: context.read<ShoppingCartRepository>(),
      )
        ..add(const ShoppingCartSubscriptionRequested())
        ..add(const ShoppingCartProductsDataRequested()),
      child: const ShoppingCartView(),
    );
  }
}

class ShoppingCartView extends StatelessWidget {
  const ShoppingCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartScreen();
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products =
        context.select((ShoppingCartBloc bloc) => bloc.state.products);
    final productsData =
        context.select((ShoppingCartBloc bloc) => bloc.state.productsData);
    return Scaffold(
      backgroundColor: AppColors.ice,
      appBar: customAppBar(context, 'Carrito', true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalSpacer(40),
            Text(
              'Lista de productos seleccionados',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontSize: 16.sp,
                color: AppColors.blue,
              ),
            ),
            verticalSpacer(10),
            Expanded(
              child: ListView.builder(
                itemCount: products.isEmpty ? 1 : products.length + 1,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  if (index < products.length) {
                    final item = products[index];
                    final data = getProductData(item, productsData);
                    return addItemCard(
                        headTitle: item.nombreProducto,
                        title: item.descripcionProducto,
                        comment: data.observation,
                        data: data,
                        count: data.quantity.toString(),
                        mScale: item.unidadMedida,
                        isHeadingVisible: true,
                        showTopActions: true,
                        increment: () {
                          final updated =
                              data.copyWith(quantity: data.quantity + 1);
                          if (updated.quantity == 1) {
                            context
                                .read<ShoppingCartBloc>()
                                .add(ShoppingCartProductDataAdd(data: updated));
                          } else {
                            context.read<ShoppingCartBloc>().add(
                                ShoppingCartProductDataUpdated(data: updated));
                          }
                        },
                        decrement: () {
                          final updated =
                              data.copyWith(quantity: data.quantity - 1);
                          if (updated.greaterThanZero) {
                            context.read<ShoppingCartBloc>().add(
                                ShoppingCartProductDataUpdated(data: updated));
                          } else {
                            context.read<ShoppingCartBloc>().add(
                                ShoppingCartProductDataDeleted(
                                    id: updated.productId));
                          }
                        },
                        onEdit: (String value) {
                          final updated =
                              data.copyWith(quantity: int.parse(value));
                          context.read<ShoppingCartBloc>().add(
                              ShoppingCartProductDataUpdated(data: updated));
                        },
                        context: context,
                        onCountDelete: () {
                          final updated = data.copyWith(quantity: 1);
                          context
                              .read<ShoppingCartBloc>()
                              .add(ShoppingCartProductDataAdd(data: updated));
                        });
                  } else {
                    return Column(
                      children: [
                        if (products.isEmpty)
                          Text('Aún no se han agregado productos',
                              style: TextStyle(fontSize: 13.sp)),
                        verticalSpacer(20),
                        Align(
                          alignment: Alignment.center,
                          child: customButton(
                            context,
                            true,
                            'Agregar Producto',
                            12.sp,
                            () {
                              context
                                  .read<HostHomeCubit>()
                                  .setTab(HostHomeTab.home);
                            },
                            170.sp,
                            31.sp,
                            Colors.transparent,
                            AppColors.blue,
                            8.sp,
                            showShadow: true,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 10.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Center(
                child: customButton(context, false, 'Continuar', 16, () {
                  if (products.isEmpty) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                          content: Text(
                              'No hay productos en el carrito de compras')));
                    return;
                  }
                  final bloc = context.read<ShoppingCartBloc>();
                  Navigator.of(context)
                      .pushNamed('order_booking', arguments: {'bloc': bloc});
                }, 308, 58, Colors.transparent, AppColors.lightCyan, 100,
                    showShadow: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ProductData getProductData(Product item, Map<String, ProductData> data) {
    return data[item.idProducto] ??
        ProductData.initialValue(item.idProducto, item.precio.toString());
  }
}
