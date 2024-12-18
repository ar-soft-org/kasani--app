import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';
import 'package:kasanipedido/edit_product/bloc/edit_product_bloc.dart';
import 'package:kasanipedido/models/subcategory/subcategory_model.dart';
import 'package:kasanipedido/screens/widgets/category_card.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';
import 'package:kasanipedido/widgets/UIKit/Standard/Atoms/list_wrapper.dart';
import 'package:kasanipedido/widgets/UIKit/Standard/Atoms/regular_text.dart';
import 'package:kasanipedido/widgets/textfields.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

import '../widgets/categories/categories.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProductBloc(
        shoppingCartRepository: context.read<ShoppingCartRepository>(),
      )..add(const EditProductProductsDataRequested()),
      child: const EditProductView(),
    );
  }
}

class EditProductView extends StatelessWidget {
  const EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = BlocProvider.of<AuthCubit>(context).state;
    if (state is AuthSuccess) {
      BlocProvider.of<HomeCubit>(context)
          .fetchCategoriesSubCategories(state.host);
      BlocProvider.of<HomeCubit>(context).fetchProducts(state.host);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.ice, // Dark background color
          appBar: AppBar(
            title: Text(
              'Realiza tu Pedido',
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
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              final state = BlocProvider.of<AuthCubit>(context).state;
              if (state is AuthSuccess) {
                BlocProvider.of<HomeCubit>(context)
                    .fetchCategoriesSubCategories(state.host);
              }
            },
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            verticalSpacer(15),
                            GestureDetector(
                              onTap: () {
                                final homeCubit = context.read<HomeCubit>();
                                Navigator.of(context)
                                    .pushNamed('continue_home', arguments: {
                                  'cubit': homeCubit,
                                });
                              },
                              child: AbsorbPointer(
                                child: Hero(
                                  tag: 'search',
                                  child: textField(
                                    controller,
                                    46,
                                    356,
                                    'Buscar',
                                    '',
                                    100,
                                    Colors.white,
                                    true,
                                    true,
                                    true,
                                    () {},
                                    context,
                                  ),
                                ),
                              ),
                            ),

                            verticalSpacer(15),
                            ListWrapper(
                              count: state.hasCategories ? 1 : 0,
                              emptyWidget:
                                  const RegularText('No hay categorías'),
                              child: SizedBox(
                                height: 65.h,
                                child: const CategoriesSection(),
                              ),
                            ),
                            verticalSpacer(5),
                            // subcategories
                            if (state.hasCurrentCategory)
                              SizedBox(
                                height: 167.h,
                                child: const SubCategorySection(),
                              ),

                            verticalSpacer(20),
                          ],
                        ),
                        // Products
                        const Expanded(
                          child:
                              SingleChildScrollView(child: ProductsSection()),
                        )
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData =
        context.select((EditProductBloc bloc) => bloc.state.productsData);
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      final products = state.currentProducts;

      return ListView.builder(
        itemCount: products.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = products[index];
          final data = productsData[item.idProducto] ??
              ProductData.initialValue(item.idProducto, item.precio);
          return ProductCard(
            item: item,
            data: data,
          );
        },
      );
    });
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.item,
    required this.data,
  });

  final Product item;
  final ProductData data;

  @override
  Widget build(BuildContext context) {
    return addItemCard(
      title: item.nombreProducto,
      count: data.quantity.toString(),
      mScale: item.unidadMedida,
      isHeadingVisible: false,
      showTopActions: false,
      increment: () {
        if (data.hasNotQuantity) {
          context.read<HomeCubit>().addProductData(item);
          context
              .read<EditProductBloc>()
              .add(EditProductAddProduct(product: item));
        } else {
          final updated = data.copyWith(quantity: data.quantity + 1);
          context.read<HomeCubit>().updateProductData(updated);
        }
      },
      decrement: () {
        if (data.hasNotQuantity) {
          return;
        }

        final updated = data.copyWith(quantity: data.quantity - 1);
        if (updated.hasNotQuantity) {
          context.read<HomeCubit>().deleteProductData(updated.productId);
        } else {
          context.read<HomeCubit>().updateProductData(updated);
        }
      },
      context: context,
    );
  }
}

class SubCategorySection extends StatelessWidget {
  const SubCategorySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!state.hasCurrentCategory) {
          return const SizedBox.shrink();
        }

        final subCategories = state.currentCategory!.subCategorias;
        final currentSubCategory = state.currentSubCategory;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: subCategories.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final item = subCategories[index];
            return SubCategoryCard(
              item: item,
              isSelected:
                  currentSubCategory?.idSubCategoria == item.idSubCategoria,
              onTap: (String subCategoryId) {
                BlocProvider.of<HomeCubit>(context)
                    .setCurrentSubCategory(subCategoryId);
              },
            );
          },
        );
      },
    );
  }
}

class SubCategoryCard extends StatelessWidget {
  const SubCategoryCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.isSelected,
  });

  final SubCategoria item;
  final Function(String) onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return categoryCard(
      AppImages.fish,
      item.nombreSubCategoria,
      () {
        // FIXME: Add onTap
        // setState(() {});
        onTap(item.idSubCategoria);
      },
      Colors.white,
      AppColors.darkBlue,
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
    );
  }
}
