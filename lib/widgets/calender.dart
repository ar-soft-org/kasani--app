
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:table_calendar/table_calendar.dart';

import '../exports/exports.dart';

class CustomCalender{
  Widget customCalender(BuildContext context)
  {


    return
      CalendarCarousel<Event>(
        maxSelectedDate:DateTime(2100),
        height: 300.h,
        width: 375.w,
        dayPadding: 0,
        weekFormat: false,

        markedDateMoreShowTotal:
        null,
        weekDayPadding:EdgeInsets.symmetric(horizontal: 0.w,vertical: 10.h) ,
        weekDayMargin: const EdgeInsets.all(0) ,
        todayButtonColor: Colors.red,
        disableDayPressed:true,
        showOnlyCurrentMonthDate: true,
        headerMargin:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
        iconColor: AppColors.greyText,
        todayTextStyle: TextStyle(color: Colors.white,fontSize: 18.sp,fontWeight: FontWeight.w400),
        daysTextStyle: TextStyle(color: Colors.black,fontSize: 14.sp,fontWeight:FontWeight.w600),
        headerTextStyle: TextStyle(color: Colors.black,fontSize: 16.sp,fontWeight: FontWeight.w600),
        weekendTextStyle: TextStyle(color: Colors.black,fontSize: 12.sp,fontWeight: FontWeight.w400),
        weekdayTextStyle: TextStyle(color:  Colors.grey,fontSize: 12.sp,fontWeight: FontWeight.bold),
        onDayPressed: (DateTime date, List<Event> events) {

        },
        selectedDayBorderColor: Colors.red,
        selectedDayButtonColor: Colors.red,

        showHeaderButton: true,

        markedDatesMap: CustomCalender._markedDateMap,
        markedDateShowIcon: true,
        markedDateIconMaxShown: 1,
        childAspectRatio: 30/25,

        markedDateIconBuilder: (event) {
          return event.icon;
        },
      );
  }
  static EventList<Event> _markedDateMap = new EventList<Event>(

    events: {


    },
  );
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: 5,
      child: Container(
        height: 310.h,
        width: 330.w,

        padding: EdgeInsets.symmetric(vertical: 4.h),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: TableCalendar(
            locale: 'en_US',
            rowHeight: 35.h,
            daysOfWeekHeight: 23.h,



            headerStyle: HeaderStyle(
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
             daysOfWeekStyle: DaysOfWeekStyle(

              weekdayStyle: TextStyle(
                  color: AppColors.calenderLable,

               ),
              weekendStyle: TextStyle(
                color: AppColors.calenderLable,

              ), // Change weekday label color
            ),



            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
              ),
              selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red
              ),
              todayTextStyle: TextStyle(
                  color: Colors.black
              ),
              tablePadding: EdgeInsets.symmetric(
                  horizontal: 24.w, vertical: 10.h),
              cellPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
              cellMargin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),

            ),

            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            onDaySelected: _onDaySelected,
          ),
        ),
      ),
    );
  }
}