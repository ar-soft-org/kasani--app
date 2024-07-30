import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';
import 'package:kasanipedido/edit_product/bloc/edit_product_bloc.dart';
import 'package:kasanipedido/models/subcategory/subcategory_model.dart';
import 'package:kasanipedido/screens/widgets/category_card.dart';
import 'package:kasanipedido/utils/app_constant.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';
import 'package:kasanipedido/widgets/textfields.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProductBloc(
        shoppingCartRepository: context.read<ShoppingCartRepository>(),
      )..add(
          const EditProductProductsDataRequested(),
        ),
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
  @override
  void initState() {
    super.initState();
    final state = BlocProvider.of<AuthCubit>(context).state;
    // get categories and subcategories
    if (state is AuthSuccess) {
      BlocProvider.of<HomeCubit>(context)
          .fetchCategoriesSubCategories(state.host);
      BlocProvider.of<HomeCubit>(context).fetchProducts(state.host);
    }
  }

  int count1 = 3;

  TextEditingController controller = TextEditingController();
  List<int> counts = List<int>.filled(3, 0);
  List<int> count = List<int>.filled(3, 0);

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
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: AppColors.ice, // Dark background color
            appBar: AppBar(
              title: Text(
                "Realiza tu Pedido",
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
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          verticalSpacer(15),
                          textField(
                              controller,
                              46,
                              356,
                              "Buscar",
                              "",
                              100,
                              Colors.white,
                              true,
                              true,
                              true,
                              false,
                              () {},
                              context),
                          verticalSpacer(15),
                          if (state.hasCategories)
                            const SizedBox(
                                height: 80, child: CategoriesSection()),
                          verticalSpacer(15),

                          // subcategories
                          if (state.hasCurrentCategory)
                            const SizedBox(
                              height: 200,
                              child: SubCategorySection(),
                            ),

                          verticalSpacer(20),
                          // Products
                          const ProductsSection()
                        ]),
                  )),
            ));
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
      isMessage: false,
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

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: subCategories.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final item = subCategories[index];
            return SubCategoryCard(
              item: item,
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
  });

  final SubCategoria item;
  final Function(String) onTap;

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
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: state.categories.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final item = state.categories[index];
            return CategoryCard(
                categoryId: item.idCategoria,
                label: item.nombreCategoria,
                isSelected: false,
                onTap: (String categoryId) {
                  BlocProvider.of<HomeCubit>(context)
                      .setCurrentCategory(categoryId);
                });
          },
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.label,
    required this.categoryId,
    this.isSelected = false,
    required this.onTap,
  });

  final String categoryId;
  final String label;
  final bool isSelected;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return circleCard(
      context,
      // FIXME: Add image
      AppImages.frescos,
      label,
      Colors.cyan,
      0,
      index == 1 ? Colors.cyan : AppColors.greyText,
      // FIXME: onTap
      () {
        onTap(categoryId);
        // setState(() {
        //   index = 0;
        // });
      },
      isSelected ? AppColors.purple : AppColors.purple,
      isSelected ? FontWeight.w400 : FontWeight.w400,
    );
  }
}
