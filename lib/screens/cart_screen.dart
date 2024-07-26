import 'package:kasanipedido/exports/exports.dart';
class CartScreen extends StatefulWidget {

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int> count = List<int>.filled(2, 0);
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: AppColors.ice,
      appBar:customAppBar(context,"Carrito",true),
      body:  Padding(
        padding:  EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalSpacer(40),
            Text(
              "Lista de productos seleccionados",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontSize: 16.sp,
                color: AppColors.blue,
              ),
            ),
            verticalSpacer(10),
            ListView.builder(
              itemCount: count.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return   addItemCard("Langostinos. eget lectus lobortis viverra.",count[index].toString(),"Kg",
                    true,true,(){
                    setState(() {
                      if (count[index] > 0) {
                        --count[index];
                      }

                    });
                },(){
                      setState(() {
                        ++count[index];
                      });
                    });
              },),
        verticalSpacer(30),
        Align(
          alignment: Alignment.center,
          child: customButton(context,true,"Continuar comprando",12,() {
            Navigator.of(context).pushNamed('order_booking');
            // Get.to(
              // const OrderBookingScreen()
            // );

          },175,31,Colors.transparent,AppColors.blue,8,showShadow: true),
        ),

           const Spacer(),
           Container(
                height: 150,
             padding:  EdgeInsets.symmetric(horizontal: 23.w,vertical: 10.h),
                decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60.r),topRight: Radius.circular(60.r))
                ),
                child:  Center(
                  child: customButton(context,false,"Continuar",16,() {
                  },308,58,Colors.transparent,AppColors.lightCyan,100,showShadow: true),
                ),
              ),


          ],
        ),
      ),

    );
  }
}