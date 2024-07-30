import 'package:kasanipedido/exports/exports.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<int> count = List<int>.filled(3, 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ice,
      appBar: customAppBar(context, "FAVORITOS", true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('*Vista Maqueta'),
            verticalSpacer(60),
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return addItemCard(
                  title: "Langostinos. eget lectus lobortis viverra.",
                  count: count[index].toString(),
                  mScale: "Kg",
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
          ],
        ),
      ),
    );
  }
}
