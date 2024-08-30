import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/widgets/custom_text.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.list,
    this.onChanged,
    this.initialValue,
  });

  final List<CustomDropdownMenuItem<T>> list;
  final Function(CustomDropdownMenuItem<T>?)? onChanged;
  final CustomDropdownMenuItem<T>? initialValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CustomDropdownMenuItem<T>>(
      menuMaxHeight: 150.h,
      enableFeedback: true,
      hint: customText(
        '--',
        FontWeight.w400,
        11.sp,
        GoogleFonts.beVietnamPro().fontFamily.toString(),
        Colors.black,
      ),
      value: initialValue,
      isExpanded: true,
      isDense: true,
      alignment: Alignment.center,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.keyboard_arrow_down_outlined,
          color: AppColors.darkBlue),
      style: TextStyle(
        color: Colors.black,
        fontFamily: GoogleFonts.inter().fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 10.sp,
      ),
      dropdownColor: Colors.white,
      onChanged: (value) {
        onChanged?.call(value);
      },
      items: list.map((CustomDropdownMenuItem<T> item) {
        return DropdownMenuItem<CustomDropdownMenuItem<T>>(
          value: item,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: customText(
                item.value,
                FontWeight.w400,
                11,
                GoogleFonts.beVietnamPro().fontFamily.toString(),
                Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CustomDropdownMenuItem<T> extends Equatable {
  final String value;
  final String key;
  final T data;

  const CustomDropdownMenuItem({
    required this.value,
    required this.key,
    required this.data,
  });

  @override
  List<Object?> get props => [
        value,
        key,
        data,
      ];
}
