import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kasanipedido/order_booking/bloc/order_booking_bloc.dart';
import 'package:kasanipedido/screens/home_screen.dart';
import 'package:kasanipedido/screens/widgets/category_card.dart';
import 'package:kasanipedido/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/vendor/bloc/vendor_bloc.dart';
import 'package:kasanipedido/widgets/custom_text.dart';
import 'package:kasanipedido/widgets/horizontal_spacer.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

import '../history_detail_screen.dart';

class OrderDetailedPageView extends StatefulWidget {
  const OrderDetailedPageView({
    super.key,
    required this.formKey,
    required this.onSavedComment,
    required this.focusNode,
  });

  final GlobalKey<FormState> formKey;
  final Function(String) onSavedComment;
  final FocusNode focusNode;
  @override
  State<OrderDetailedPageView> createState() => _OrderDetailedPageViewState();
}

class _OrderDetailedPageViewState extends State<OrderDetailedPageView> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products =
        context.select((ShoppingCartBloc bloc) => bloc.state.products);
    final productsData =
        context.select((ShoppingCartBloc bloc) => bloc.state.productsData);

    return GestureDetector(
      onTap: () {
        widget.focusNode.unfocus();
      },
      child: Container(
        color: AppColors.ice,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            verticalSpacer(20),
            Expanded(
              child: SizedBox(
                // height: 160.h,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: products.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final item = products[index];
                    final data = getProductData(item, productsData);
                    return addItemCard(
                      title: item.nombreProducto,
                      count: data.getQuantity,
                      mScale: getAbbreviatedUnit(item.unidadMedida),
                      comment: data.observation,
                      data: data,
                      // isHeadingVisible: true,
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
                      context: context,
                    );
                  },
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.center,
            //   child: customButton(context, true, 'Continuar comprando', 12,
            //       () {}, 175, 31, Colors.transparent, AppColors.blue, 8,
            //       showShadow: true),
            // ),
            verticalSpacer(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: customText(
                'Comentarios finales',
                FontWeight.w500,
                12.sp,
                GoogleFonts.beVietnamPro().fontFamily.toString(),
                const Color(0XFF1B1B1B),
              ),
            ),
            verticalSpacer(5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: SizedBox(
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Form(
                    key: widget.formKey,
                    child: TextFormField(
                      controller: controller,
                      focusNode: widget.focusNode,
                      onSaved: (value) {
                        widget.onSavedComment(value ?? '');
                      },
                      minLines: 2,
                      maxLines: 5,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            verticalSpacer(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    color: Color(0xff5985E1),
                  ),
                  horizontalSpacer(15),
                  customText(
                    'Datos de entrega',
                    FontWeight.w500,
                    12,
                    GoogleFonts.beVietnamPro().fontFamily.toString(),
                    AppColors.black,
                  ),
                ],
              ),
            ),
            verticalSpacer(10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 11.5),
              child: _OrderSummary(),
            ),
          ]),
        ),
      ),
    );
  }

  ProductData getProductData(Product item, Map<String, ProductData> data) {
    return data[item.idProducto] ??
        ProductData.initialValue(item.idProducto, item.precio.toString());
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((OrderBookingBloc bloc) => bloc.state);

    final vendorState = context.select((VendorBloc? bloc) => bloc?.state);
    final client = vendorState?.currentClient;

    final date = DateTime.parse(state.dateStr!);
    final formatted = DateFormat('dd/MM/yyyy').format(date);

    return Column(
      children: [
        if (client != null) detailHeading('Cliente: ', ' ${client.nombres}'),
        detailHeading('Fecha de entrega: ', ' $formatted'),
        detailHeading(
            'Hora de entrega:  ', ' ${state.currentSubsidiary!.horaEntrega}'),
        detailHeading(
            'Lugar de entrega: ', ' ${state.currentSubsidiary!.nombreLocal}'),
      ],
    );
  }
}
