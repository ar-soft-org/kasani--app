import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';
import 'package:kasanipedido/domain/repository/client/models/client.dart';
import 'package:kasanipedido/edit_product/bloc/edit_product_bloc.dart';
import 'package:kasanipedido/models/subcategory/subcategory_model.dart';
import 'package:kasanipedido/screens/widgets/category_card.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';
import 'package:kasanipedido/vendor/bloc/vendor_bloc.dart';

import 'package:kasanipedido/widgets/app_bar.dart';
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
    // get categories and subcategories
    if (state is AuthHostSuccess) {
      BlocProvider.of<HomeCubit>(context)
          .fetchCategoriesSubCategories(state.host);
      BlocProvider.of<HomeCubit>(context).fetchProducts(state.host);
    }

    if (state is AuthVendorSuccess) {
      BlocProvider.of<HomeCubit>(context).fetchCategoriesSubCategories(
          state.vendor,
          employeId: state.vendor.idEmpleado);
      BlocProvider.of<HomeCubit>(context)
          .fetchProducts(state.vendor, employeId: state.vendor.idEmpleado);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getTitle(Client? client) {
    StringBuffer title = StringBuffer();
    title.write('Realiza tu Pedido');
    if (client != null) {
      title.write(' - ');
      title.write(client.nombres);
    }

    return title.toString();
  }

  @override
  Widget build(BuildContext context) {
    final VendorState? vendorState =
        context.select((VendorBloc? bloc) => bloc?.state);

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
          backgroundColor: AppColors.ice,
          appBar: customAppBar(
              context, getTitle(vendorState?.currentClient), false),
          body: RefreshIndicator(
            onRefresh: () async {
              final state = BlocProvider.of<AuthCubit>(context).state;
              if (state is AuthHostSuccess) {
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
                        Column(children: [
                          verticalSpacer(10),
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
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  child: textField(
                                    controller,
                                    46,
                                    356,
                                    'Buscar',
                                    '',
                                    100,
                                    Colors.white,
                                    false,
                                    true,
                                    true,
                                    () {},
                                    textColor: AppColors.purple,
                                    context,
                                    bold: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          verticalSpacer(5),
                          const CombinedCategoriesSection()
                        ]),
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

class CombinedCategoriesSection extends StatelessWidget {
  const CombinedCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 65.h,
                child: const SubCategorySection(),
              ),
              SizedBox(
                height: 65.h,
                child: const CategoriesSection(),
              ),
            ],
          ),
        ),
      ],
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
      count: data.getQuantity,
      mScale: getAbbreviatedUnit(item.unidadMedida),
      // isHeadingVisible: false,
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
      onEdit: (String value) {
        if (data.hasNotQuantity) {
          context.read<HomeCubit>().addProductData(
                item,
                data: data.copyWith(quantity: num.parse(value).toDouble()),
              );
          context
              .read<EditProductBloc>()
              .add(EditProductAddProduct(product: item));
        } else {
          final updated = data.copyWith(quantity: num.parse(value).toDouble());
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
              index: index,
              isSelected:
                  currentSubCategory?.idSubCategoria == item.idSubCategoria,
              onTap: (String subCategoryId) {
                BlocProvider.of<HomeCubit>(context)
                    .setCurrentSelection(id: subCategoryId, isCategory: false);
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
    required this.index,
  });

  final SubCategoria item;
  final Function(String) onTap;
  final bool isSelected;
  final int index;

  @override
  Widget build(BuildContext context) {
    String getImage(String id) {
      switch (id) {
        case '1':
          return AppImages.fish;
        case '2':
          return AppImages.mariscosCat;
        default:
          return AppImages.mariscosCat;
      }
    }

    return circleCard(
      context,
      getImage(item.idSubCategoria),
      item.nombreSubCategoria,
      Colors.cyan,
      0,
      index == 1 ? Colors.cyan : AppColors.greyText,
      () => onTap(item.idSubCategoria),
      isSelected ? AppColors.selectCat : AppColors.purple,
      isSelected ? FontWeight.w700 : FontWeight.w400,
    );
  }
}

String getAbbreviatedUnit(String unit) {
  switch (unit.toLowerCase()) {
    case 'documento':
      return 'DOC';
    case 'kilogramo':
      return 'KG';
    case 'gramo':
      return 'G';
    case 'unidad':
      return 'UND';
    case 'paquete':
      return 'PAQ';
    default:
      return unit;
  }
}
