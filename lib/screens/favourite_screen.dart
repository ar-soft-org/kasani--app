import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/exports/exports.dart';
import 'package:kasanipedido/favorite_products/bloc/favorite_products_bloc.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class FavoriteProductsPage extends StatelessWidget {
  const FavoriteProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => FavoriteProductsBloc(shoppingCartRepository
    : RepositoryProvider.of<ShoppingCartRepository>(context)) ,child: const FavouriteScreen() ,);
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
      BlocProvider.of<FavoriteProductsBloc>(context).add(FavoriteProductsSuscribe(hostModel: state.host));
    }
    
  }

  List<int> count = List<int>.filled(3, 0);
  @override
  Widget build(BuildContext context) {
    final products = context.select((FavoriteProductsBloc bloc) => bloc.state.products);
    return Scaffold(
      backgroundColor: AppColors.ice,
      appBar: customAppBar(context, "FAVORITOS", true),
      body: RefreshIndicator(
        onRefresh: () async {
          final state = context.read<AuthCubit>().state;
          if (state is AuthSuccess) {
            BlocProvider.of<FavoriteProductsBloc>(context).add(FavoriteProductsSuscribe(hostModel: state.host));
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('*Vista Maqueta'),
              verticalSpacer(60),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final item = products[index];
                    return addItemCard(
                      title: item.nombreProducto,
                      count: "0",
                      mScale: item.unidadMedida,
                      isHeadingVisible: true,
                      isMessage: false,
                      increment: () {
                        setState(() {
                          if (count[index] > 0) {
                            --count[index];
                          }
                        });
                      },
                      decrement: () {
                        setState(() {
                          ++count[index];
                        });
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
                child: customButton(context, true, "Continuar comprando", 12,
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
                  child: customButton(context, false, "Continuar", 16, () {}, 308,
                      58, Colors.transparent, AppColors.lightCyan, 100,
                      showShadow: true),
                ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
