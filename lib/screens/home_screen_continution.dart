import 'package:kasanipedido/exports/exports.dart';

class ContinueHomeScreen extends StatefulWidget {
  const ContinueHomeScreen({super.key});

  @override
  State<ContinueHomeScreen> createState() => _ContinueHomeScreenState();
}

class _ContinueHomeScreenState extends State<ContinueHomeScreen> {
  List<int> counts = List<int>.filled(3, 0);
  List<int> count = List<int>.filled(3, 0);
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.ice, // Dark background color
      appBar: AppBar(
        title: Text(
          'Nuevo Pedido',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              verticalSpacer(20),
              textField(controller, 46, 356, 'Langostino', '', 100,
                  Colors.white, true, false, true, false, () {}, context),
              verticalSpacer(15),
              Text(
                'FRESCOS',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontSize: 16.sp,
                  color: AppColors.darkBlue,
                ),
              ),
              ListView.builder(
                itemCount: count.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return addItemCard(
                    title: 'Langostinos. eget lectus lobortis viverra.',
                    count: count[index].toString(),
                    mScale: 'Kg',
                    isHeadingVisible: true,
                    showTopActions: false,
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
              Text(
                'CONGELADOS',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontSize: 16.sp,
                  color: AppColors.darkBlue,
                ),
              ),
              ListView.builder(
                itemCount: count.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return addItemCard(
                    title: 'Langostinos. eget lectus lobortis viverra.',
                    count: counts[index].toString(),
                    mScale: 'Kg',
                    isHeadingVisible: true,
                    showTopActions: false,
                    increment: () {
                      setState(() {
                        if (counts[index] > 0) {
                          --counts[index];
                        }
                      });
                    },
                    decrement: () {
                      setState(() {
                        print(count);
                        ++counts[index];
                      });
                    },
                    context: context,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
