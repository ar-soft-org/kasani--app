
import 'package:kasanipedido/exports/exports.dart';
import 'package:kasanipedido/utils/app_constant.dart';


class OrderBookingScreen extends StatefulWidget {

  const OrderBookingScreen({super.key});

  @override
  State<OrderBookingScreen> createState() => _OrderBookingScreenState();
}

class _OrderBookingScreenState extends State<OrderBookingScreen> {
  String? _selectedValue;
  PageController? _pageController;
  List<int> counts = List<int>.filled(2, 0);
  TextEditingController controller = TextEditingController();
  int _currentPage = 0;
  void _nextPage() {
    if (_currentPage < 2) {
      _pageController!.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController!.addListener(() {
      setState(() {
        _currentPage = _pageController!.page!.round();
      });
    });
  }
  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:_currentPage==2?Colors.white: AppColors.ice,
      appBar: customAppBar(context, _currentPage==0?"Datos de Entrega":_currentPage==1?"Datos del Pedido":"",  _currentPage==2?false:true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalSpacer(30),
          buildIndicator(_currentPage),
          verticalSpacer(10),
          Expanded(
            child: Center(
              child: PageView(
                controller: _pageController,
                children: [
                  orderBookingPageView(context,() {
                    setState(() {
                      _currentPage = _currentPage + 1;
                    });
                  },
                     _selectedValue,
                          ( selected) {
                            setState(() {

                              _selectedValue =selected ;

                            });


                      },


                  ),
                  orderDetailedPageView(context,controller,_nextPage,counts,

                        (){
                    setState(() {

                    });

                  },(){
                    setState(() {

                    });

                  }
                  ),
                  orderCompletePageView()
                ],
              ),
            ),
          ),
        ],
      ),
     bottomNavigationBar: _currentPage==2? SizedBox():Container(
       height: 110.h,
       padding:  EdgeInsets.symmetric(horizontal: 23.w,vertical: 10.h),
       decoration:  BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.only(topLeft: Radius.circular(60.r),topRight: Radius.circular(60.r))
       ),
       child:  Center(
         child: customButton(context,false,
             _currentPage==0?"Continuar":"Finalizar Pedido",16,_nextPage,308,55,Colors.transparent,AppColors.lightCyan,100,showShadow: true),
       ),
     ),
    );
  }

}



