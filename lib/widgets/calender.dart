import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:kasanipedido/order_booking/bloc/order_booking_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../exports/exports.dart';

class CustomCalender {
  Widget customCalender(BuildContext context) {
    return CalendarCarousel<Event>(
      maxSelectedDate: DateTime(2100),
      height: 300.h,
      width: 375.w,
      dayPadding: 0,
      weekFormat: false,
      markedDateMoreShowTotal: null,
      weekDayPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
      weekDayMargin: const EdgeInsets.all(0),
      todayButtonColor: Colors.red,
      disableDayPressed: true,
      showOnlyCurrentMonthDate: true,
      headerMargin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      iconColor: AppColors.greyText,
      todayTextStyle: TextStyle(
          color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w400),
      daysTextStyle: TextStyle(
          color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w600),
      headerTextStyle: TextStyle(
          color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w600),
      weekendTextStyle: TextStyle(
          color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.w400),
      weekdayTextStyle: TextStyle(
          color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.bold),
      onDayPressed: (DateTime date, List<Event> events) {},
      selectedDayBorderColor: Colors.red,
      selectedDayButtonColor: Colors.red,
      showHeaderButton: true,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      childAspectRatio: 30 / 25,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;

  @override
  void initState() {
    _selectedDay = DateTime.now();
    _onDaySelected(_selectedDay, _selectedDay);

    super.initState();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      context.read<OrderBookingBloc>().add(OrderBookingDateSelected(
          dateStr:
              '${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    const cardBoxShadow = BoxShadow(
        offset: Offset(1, 1),
        blurRadius: 2,
        spreadRadius: 1,
        color: Color.fromRGBO(0, 0, 0, 0.05));

    const cardElevation = 1.0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: cardElevation,
      child: Container(
        height: 310.h,
        width: 330.w,
        padding: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: const [
              cardBoxShadow,
            ]),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: TableCalendar(
            locale: 'en_US',
            rowHeight: 35.h,
            daysOfWeekHeight: 23.h,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: AppColors.calenderLable,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: AppColors.calenderLable,
                // Change arrow color here
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: AppColors.calenderLable,
              ),
              weekendStyle: TextStyle(
                color: AppColors.calenderLable,
              ), // Change weekday label color
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.lightCyan),
              selectedDecoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.red),
              todayTextStyle: const TextStyle(color: Colors.white),
              tablePadding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              cellPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
              cellMargin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            ),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            focusedDay: _selectedDay,
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 90)),
            onDaySelected: _onDaySelected,
          ),
        ),
      ),
    );
  }
}
