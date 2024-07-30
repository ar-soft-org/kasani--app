import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/screens/widgets/category_card.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/widgets/custom_btn.dart';
import 'package:kasanipedido/widgets/custom_text.dart';
import 'package:kasanipedido/widgets/horizontal_spacer.dart';
import 'package:kasanipedido/widgets/textfields.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';

import '../history_detail_screen.dart';

Widget orderDetailedPageView(
    BuildContext context,
    TextEditingController controller,
    void Function() onContinue,
    List<int> counts,
    void Function() onChange,
    void Function() onChangeIncrement) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpacer(20),
          customText(
              "Mi pedido",
              FontWeight.w600,
              12,
              GoogleFonts.beVietnamPro().fontFamily.toString(),
              const Color(0XFF1B1B1B)),
          SizedBox(
            height: 160.h,
            child: ListView.builder(
              itemCount: counts.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return addItemCard(
                  title: "Langostinos. eget lectus lobortis viverra.",
                  count: counts[index].toString(),
                  mScale: "Kg",
                  isHeadingVisible: true,
                  isMessage: true,
                  increment: () {
                    if (counts[index] > 0) {
                      --counts[index];
                    }
                    onChange();
                  },
                  decrement: () {
                    ++counts[index];
                    onChangeIncrement();
                  },
                  context: context,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: customButton(context, true, "Continuar comprando", 12, () {},
                175, 31, Colors.transparent, AppColors.blue, 8,
                showShadow: true),
          ),
          verticalSpacer(10),
          customText(
              "Mensaje",
              FontWeight.w600,
              12,
              GoogleFonts.beVietnamPro().fontFamily.toString(),
              const Color(0XFF1B1B1B)),
          verticalSpacer(5),
          textField(controller, 78, 356, "", "", 8, Colors.white, true, false,
              false, false, () {}, context),
          verticalSpacer(15),
          Row(
            children: [
              const Icon(
                Icons.local_shipping_outlined,
                color: Color(0xff5985E1),
              ),
              horizontalSpacer(15),
              customText(
                  "Datos de entrega",
                  FontWeight.w500,
                  14,
                  GoogleFonts.beVietnamPro().fontFamily.toString(),
                  AppColors.black),
            ],
          ),
          verticalSpacer(10),
          detailHeading("Fecha de entrega: ", "30/05"),
          detailHeading("Hora de entrega:  ", "De 11: 00 am a 1: 00 pm"),
          detailHeading("Lugar de entrega: ", " Local Socabaya"),
        ],
      ),
    ),
  );
}
