import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/models/subsidiary/subsidiary_model.dart';
import 'package:kasanipedido/order_booking/bloc/order_booking_bloc.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/widgets/calender.dart';
import 'package:kasanipedido/widgets/drop_down.dart';
import 'package:kasanipedido/widgets/vertical_spacer.dart';

class OrderBookingPageView extends StatelessWidget {
  const OrderBookingPageView({
    super.key,
    required this.onChange,
    required this.selectedButton,
  });

  final String? selectedButton;
  final Function(String?)? onChange;

  @override
  Widget build(BuildContext context) {
    // FIXME: box shadow se repite en table calendar
    const cardBoxShadow = BoxShadow(
        offset: Offset(1, 1),
        blurRadius: 2,
        spreadRadius: 1,
        color: Color.fromRGBO(0, 0, 0, 0.05));

    // FIXME: elevation se repite en table calendar
    const cardElevation = 1.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                // ignore: prefer_adjacent_string_concatenation
                '  ' + 'Seleccionar lugar de entrega',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                  fontSize: 14.sp,
                  color: AppColors.darkBlue,
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: cardElevation,
                child: Container(
                  // height: 94.h,
                  height: 70.h,
                  width: 322.w,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.white,
                      boxShadow: const [
                        cardBoxShadow,
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 38.h,
                          decoration: BoxDecoration(
                            color: AppColors.tfBg.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.strokeWhite),
                          ),
                          child: const Center(
                            child: SubsidiarySelector(),
                          ))
                    ],
                  ),
                ),
              ),
              verticalSpacer(15),
              Text(
                // ignore: prefer_adjacent_string_concatenation
                '  ' + 'Seleccionar fecha de entrega',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                  fontSize: 14.sp,
                  color: AppColors.darkBlue,
                ),
              ),
              verticalSpacer(5),
              const Align(
                alignment: Alignment.center,
                child: CalendarScreen(),
              ),
              verticalSpacer(15),
              Text(
                // '  ' + 'Seleccionar franja horaria',
                // ignore: prefer_adjacent_string_concatenation
                '  ' + 'Franja horaria',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                  fontSize: 14.sp,
                  color: AppColors.darkBlue,
                ),
              ),
              verticalSpacer(5),
              // FIXME: make card container a widget (reutilizeble)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: cardElevation,
                child: Container(
                    // height: 94.h,
                    height: 50.h,
                    width: 322.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white,
                        boxShadow: const [cardBoxShadow]),
                    child: const AddressSelector()),
              )
            ]),
      ),
    );
  }
}

class SubsidiarySelector extends StatelessWidget {
  const SubsidiarySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((OrderBookingBloc bloc) => bloc.state);

    final subsidiaries = state.subsidiaries;
    final currentSubsidiary = state.currentSubsidiary;

    return CustomDropdown<SubsidiaryModel>(
      list: subsidiaries
          .map(
            (e) => CustomDropdownMenuItem<SubsidiaryModel>(
                key: e.idLocal, value: e.nombreLocal, data: e),
          )
          .toList(),
      currentValue: currentSubsidiary != null
          ? CustomDropdownMenuItem<SubsidiaryModel>(
              key: currentSubsidiary.idLocal,
              value: currentSubsidiary.nombreLocal,
              data: currentSubsidiary)
          : null,
      onChanged: (value) {
        if (value != null) {
          context.read<OrderBookingBloc>().add(
                OrderBookingSubsidiarySelected(subsidiary: value.data),
              );
        }
      },
    );
  }
}

class AddressSelector extends StatelessWidget {
  const AddressSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final subsidiaries =
        context.select((OrderBookingBloc bloc) => bloc.state.subsidiaries);

    return ListView.builder(
      itemCount: 1,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: SizedBox(
            height: 25.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (subsidiaries.isNotEmpty)
                  Text(
                    subsidiaries.first.horaEntrega,
                    // 'De 08:00 am a 9:00 am',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                // FIXME: Consultar si será una lista para seleccionar
                // Radio(
                //     activeColor: AppColors.lightCyan,
                //     value: value,
                //     groupValue: selectedButton,
                //     onChanged: onChange)
              ],
            ),
          ),
        );
      },
    );
  }
}
