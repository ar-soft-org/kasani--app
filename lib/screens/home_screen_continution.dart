import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';
import 'package:kasanipedido/edit_product/bloc/edit_product_bloc.dart';
import 'package:kasanipedido/screens/home_screen.dart';
import 'package:kasanipedido/screens/widgets/category_card.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/debouncer.dart';
import 'package:kasanipedido/widgets/UIKit/Standard/Atoms/list_wrapper.dart';
import 'package:kasanipedido/widgets/UIKit/Standard/Atoms/regular_text.dart';
import 'package:kasanipedido/widgets/app_bar.dart';
import 'package:kasanipedido/widgets/categories/category_section.dart';
import 'package:kasanipedido/widgets/textfields.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class ContinueHomePage extends StatelessWidget {
  const ContinueHomePage({
    super.key,
    this.homeCubit,
  });

  final HomeCubit? homeCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        if (homeCubit != null)
          BlocProvider.value(
            value: homeCubit!,
          ),
        BlocProvider(
          create: (context) => EditProductBloc(
            shoppingCartRepository: context.read<ShoppingCartRepository>(),
          )..add(const EditProductProductsDataRequested()),
        ),
      ],
      child: const ContinueHomeView(),
    );
  }
}

class ContinueHomeView extends StatelessWidget {
  const ContinueHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContinueHomeScreen();
  }
}

class ContinueHomeScreen extends StatefulWidget {
  const ContinueHomeScreen({super.key});

  @override
  State<ContinueHomeScreen> createState() => _ContinueHomeScreenState();
}

class _ContinueHomeScreenState extends State<ContinueHomeScreen> {
  late TextEditingController controller;

  bool searching = false;
  final Map<String, List<Product>> productsByCategory = {};

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(() {
      _debouncer.run(() {
        final text = controller.text;
        searchProduct(text);
        if (text.isEmpty) {
          setState(() {
            searching = false;
          });
          return;
        }

        setState(() {
          searching = true;
        });
      });
    });

    searchProduct(controller.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  searchProduct(String text) {
    final products = context.read<HomeCubit>().state.products;

    final filteredList = products
        .where((product) =>
            product.nombreProducto.toLowerCase().contains(text.toLowerCase()))
        .toList();

    // filter products by categories
    final Map<String, List<Product>> productsByCategory = {};
    for (final product in filteredList) {
      if (!productsByCategory.containsKey(product.categoria)) {
        productsByCategory[product.categoria] = [];
      }
      productsByCategory[product.categoria]!.add(product);
    }

    setState(() {
      this.productsByCategory.clear();
      this.productsByCategory.addAll(productsByCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        final currentCategory = state.currentCategory;

        if (currentCategory != null) {
          final products =
              state.productsByCategory![currentCategory.nombreCategoria];
          if (products != null) {
            products
                .sort((a, b) => a.nombreProducto.compareTo(b.nombreProducto));
          }
        }
      },
      builder: (context, state) {
        final productsData =
            context.select((EditProductBloc bloc) => bloc.state.productsData);

        return Scaffold(
          backgroundColor: AppColors.ice,
          appBar: customAppBar(context, 'Nuevo Pedido', true),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                verticalSpacer(10),
                Hero(
                  tag: 'search',
                  child: textField(
                    controller,
                    46,
                    356,
                    'Buscar',
                    '',
                    100,
                    Colors.white,
                    false,
                    false,
                    true,
                    () {},
                    context,
                    textColor: AppColors.purple,
                    bold: true,
                  ),
                ),
                verticalSpacer(5),
                Expanded(
                  child: Builder(builder: (_) {
                    if (searching) {
                      return ListWrapper(
                        count: productsByCategory.length,
                        emptyWidget: const RegularText('No hay productos'),
                        child: Scrollbar(
                          thickness: 10,
                          thumbVisibility: true,
                          radius: const Radius.circular(10),
                          interactive: true,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(right: 20.w),
                            child: Column(
                                children:
                                    productsByCategory.entries.map((entry) {
                              final category = entry.key;
                              final products = entry.value;
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                child: CategoryAndProducts(
                                  categoryName: category,
                                  products: products,
                                  productsData: productsData,
                                ),
                              );
                            }).toList()),
                          ),
                        ),
                      );
                    }

                    return Column(children: [
                      ListWrapper(
                        count: state.hasCategories ? 1 : 0,
                        emptyWidget: const RegularText('No hay categorías'),
                        child: SizedBox(
                          height: 65.h,
                          child: const CategoriesSection(),
                        ),
                      ),
                      verticalSpacer(20),
                      Builder(builder: (_) {
                        if (state.currentCategory != null) {
                          final categoryName =
                              state.currentCategory!.nombreCategoria;
                          final products = productsByCategory[
                              state.currentCategory!.nombreCategoria];
                          return Expanded(
                            child: CategoryAndProducts(
                              categoryName: categoryName,
                              products: products ?? [],
                              productsData: productsData,
                            ),
                          );
                        }

                        return Expanded(
                          child: Scrollbar(
                            thickness: 10,
                            thumbVisibility: true,
                            radius: const Radius.circular(10),
                            interactive: true,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(right: 20.w),
                                child: Column(
                                  children:
                                      productsByCategory.entries.map((entry) {
                                    final category = entry.key;
                                    final products = entry.value;
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      child: CategoryAndProducts(
                                        categoryName: category,
                                        products: products,
                                        productsData: productsData,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                    ]);
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CategoryAndProducts extends StatelessWidget {
  const CategoryAndProducts({
    super.key,
    required this.categoryName,
    required this.products,
    required this.productsData,
  });

  final String categoryName;
  final List<Product> products;
  final Map<String, dynamic> productsData;

  @override
  Widget build(BuildContext context) {
    ProductData getProductData(Product product) {
      if (!productsData.containsKey(product.idProducto)) {
        return ProductData(
            productId: product.idProducto,
            observation: '',
            price: num.parse(product.precio).toDouble(),
            quantity: 0);
      }
      return productsData[product.idProducto];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: GoogleFonts.inter().fontFamily,
            fontSize: 16.sp,
            color: AppColors.darkBlue,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final item = products[index];
              final data = getProductData(item);
              return addItemCard(
                  title: item.nombreProducto,
                  count: data.getQuantity,
                  mScale: getAbbreviatedUnit(item.unidadMedida),
                  // isHeadingVisible: true,
                  showTopActions: false,
                  data: data,
                  increment: () {
                    if (data.hasNotQuantity) {
                      context.read<HomeCubit>().addProductData(item);
                      context
                          .read<EditProductBloc>()
                          .add(EditProductAddProduct(product: item));
                    } else {
                      final updated =
                          data.copyWith(quantity: data.quantity + 1);
                      context.read<HomeCubit>().updateProductData(updated);
                    }
                  },
                  decrement: () {
                    if (data.hasNotQuantity) {
                      return;
                    }

                    final updated = data.copyWith(quantity: data.quantity - 1);
                    if (updated.hasNotQuantity) {
                      context
                          .read<HomeCubit>()
                          .deleteProductData(updated.productId);
                    } else {
                      context.read<HomeCubit>().updateProductData(updated);
                    }
                  },
                  context: context,
                  onEdit: (String value) {
                    log(value);
                    if (data.hasNotQuantity) {
                      context.read<HomeCubit>().addProductData(
                            item,
                            data: data.copyWith(
                                quantity: num.parse(value).toDouble()),
                          );
                      context
                          .read<EditProductBloc>()
                          .add(EditProductAddProduct(product: item));
                    } else {
                      final updated =
                          data.copyWith(quantity: num.parse(value).toDouble());
                      context.read<HomeCubit>().updateProductData(updated);
                    }
                  });
            },
          ),
        ),
        verticalSpacer(15),
      ],
    );
  }
}
