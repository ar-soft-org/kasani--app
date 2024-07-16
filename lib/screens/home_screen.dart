import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/exports/exports.dart';
import 'package:kasanipedido/utils/app_constant.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int count1=3;

  List<int> counts = List<int>.filled(3, 0);
  List<int> count = List<int>.filled(3, 0);
  @override
  Widget build(BuildContext context) {
    TextEditingController controller=TextEditingController();
    return   Scaffold(
      backgroundColor: AppColors.ice, // Dark background color
      appBar:AppBar(
        title: Text("Realiza tu Pedido",style: TextStyle(color: AppColors.darkBlue,fontFamily: GoogleFonts.inter().fontFamily,fontWeight: FontWeight.w600,fontSize: 17.sp),),
        centerTitle: true,
        elevation: 2,
          shadowColor:AppColors.ice,
          bottomOpacity: 0,
          backgroundColor: Colors.white,
      ),
      body:  Padding(
        padding:  EdgeInsets.symmetric(horizontal: 18.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              verticalSpacer(15),
             textField(controller,46,356,"Buscar","",100,Colors.white,true,true,true,false,(){}),

              verticalSpacer(15),
               Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               circleCard(context, AppImages.frescos, "Frescose", Colors.cyan, 0,index==1? Colors.cyan:AppColors.greyText,(){
                                 setState(() {
                                   index=0;
                                 });
                               },
                                 index==0?AppColors.purple:AppColors.purple,
                                 index==0?FontWeight.w400:FontWeight.w400,),
                                 circleCard(
                                   context, AppImages.congelados, "Congelados", Colors.cyan, 0, AppColors.greyText,() {
                                 setState(() {
                                index=1;

                                 });
                               },
                                 index==1?AppColors.lightCyan:AppColors.purple,
                                 index==1?FontWeight.w700:FontWeight.w400,

                               ),

                               ]
                             ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  categoryCard(AppImages.fish,"Pescados",(){
                    setState(() {

                    });
                  },  Colors.white,AppColors.darkBlue),
                  categoryCard(AppImages.jellyfish,"Mariscos",(){
                    setState(() {

                    });

                  }, index==0?Colors.white:AppColors.lightCyan,index==0?AppColors.darkBlue:Colors.white,),

                ],
              ),
              verticalSpacer(20),

              index==0?ListView.builder(
                itemCount: count.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                return   addItemCard("Langostinos. eget lectus lobortis viverra.",count[index].toString(),"Kg",
                    false,false,(){
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
              },):ListView.builder(
                itemCount: counts.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return   addItemCard("In et eros eget lectus lobortis viverra.",counts[index].toString(),"Kg",
                      true,false,(){
                        setState(() {
                          if (counts[index] > 0) {
                            --counts[index];
                          }
                        });
                      },(){
                        setState(() {
                          ++counts[index];
                        });
                      });
                },)


            ],
          ),
        ),
      ),

    );
  }
}