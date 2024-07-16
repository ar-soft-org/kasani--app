import '../exports/exports.dart';

Widget dropDown(
    BuildContext context,
    List<String> list,
    String textt,
    ) {
  return  DropdownButtonFormField<String>(
        menuMaxHeight: 150.h,
        enableFeedback: true,
        hint: customText(
            list[0].toString(),
          FontWeight.w400,
          11,
          GoogleFonts.beVietnamPro().fontFamily.toString(),
          Colors.black,
        ),
        value: list[0].toString(),
        isExpanded: true,
        isDense: true,
        alignment: Alignment.center,
        decoration:  InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.darkBlue),
        style: TextStyle(
          color: Colors.black,
          fontFamily: GoogleFonts.inter().fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 10.sp,
        ),
        dropdownColor: Colors.white,
        onChanged: (String? value) {

        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: customText(
                value,
                FontWeight.w400,
                11,
                GoogleFonts.beVietnamPro().fontFamily.toString(),
                Colors.black,
              ),
            ),
          );
        }).toList(),
      );
}