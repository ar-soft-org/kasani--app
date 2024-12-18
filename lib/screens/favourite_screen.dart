import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';
import 'package:kasanipedido/edit_product/bloc/edit_product_bloc.dart';
import 'package:kasanipedido/exports/exports.dart';
import 'package:kasanipedido/favorite_products/bloc/favorite_products_bloc.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class FavoriteProductsPage extends StatelessWidget {
  const FavoriteProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FavoriteProductsBloc(
              shoppingCartRepository:
                  RepositoryProvider.of<ShoppingCartRepository>(context)),
        ),
        BlocProvider(
          create: (context) => EditProductBloc(
              shoppingCartRepository:
                  RepositoryProvider.of<ShoppingCartRepository>(context))
            ..add(const EditProductProductsDataRequested()),
        ),
      ],
      child: const FavouriteScreen(),
    );
  }
}

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    final state = context.read<AuthCubit>().state;

    if (state is AuthSuccess) {
      BlocProvider.of<FavoriteProductsBloc>(context)
          .add(FavoriteProductsSuscribe(hostModel: state.host));
    }
  }

  @override
  Widget build(BuildContext context) {
    final products =
        context.select((FavoriteProductsBloc bloc) => bloc.state.products);
    final productsData =
        context.select((EditProductBloc bloc) => bloc.state.productsData);
    return Scaffold(
      backgroundColor: AppColors.ice,
      appBar: customAppBar(context, 'FAVORITOS', true),
      body: RefreshIndicator(
        onRefresh: () async {
          final state = context.read<AuthCubit>().state;
          if (state is AuthSuccess) {
            BlocProvider.of<FavoriteProductsBloc>(context)
                .add(FavoriteProductsSuscribe(hostModel: state.host));
          }
        },
        child: Builder(
          builder: (context) {

            final state = context.watch<FavoriteProductsBloc>().state;

            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  verticalSpacer(60),
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final item = products[index];
                        final data = productsData[item.idProducto] ??
                            ProductData.initialValue(item.idProducto, item.precio);
            
                        return addItemCard(
                          title: item.nombreProducto,
                          count: data.quantity.toString(),
                          mScale: item.unidadMedida,
                          isHeadingVisible: true,
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
            
                            final updated =
                                data.copyWith(quantity: data.quantity - 1);
                            if (updated.hasNotQuantity) {
                              context
                                  .read<HomeCubit>()
                                  .deleteProductData(updated.productId);
                            } else {
                              context.read<HomeCubit>().updateProductData(updated);
                            }
                          },
                          context: context,
                        );
                      },
                    ),
                  ),
                  /*
                  verticalSpacer(20),
                  Align(
                    alignment: Alignment.center,
                    child: customButton(context, true, 'Continuar comprando', 12,
                        () {}, 175, 31, Colors.transparent, AppColors.blue, 8,
                        showShadow: true),
                  ),
                  const Spacer(),
                  Container(
                    height: 150,
                    padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60.r),
                            topRight: Radius.circular(60.r))),
                    child: Center(
                      child: customButton(context, false, 'Continuar', 16, () {}, 308,
                          58, Colors.transparent, AppColors.lightCyan, 100,
                          showShadow: true),
                    ),
                  ),
                  */
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
