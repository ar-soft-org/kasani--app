
import 'package:kasanipedido/exports/exports.dart';


Widget customText(String text,FontWeight fontWeight,
    double fontSize,String fontFamily,Color color){
  return Text(
    text,
    style: TextStyle(
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      fontSize: fontSize.sp,
      color: color,
    ),
  );
}