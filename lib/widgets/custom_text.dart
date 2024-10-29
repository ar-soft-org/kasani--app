import 'package:kasanipedido/exports/exports.dart';

Widget customText(
  String text,
  FontWeight fontWeight,
  double fontSize,
  String fontFamily,
  Color color, {
  int maxLines = 2,
}) {
  return Text(
    text,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      fontSize: fontSize.sp,
      color: color,
    ),
  );
}
