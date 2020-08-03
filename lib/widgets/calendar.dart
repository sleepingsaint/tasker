import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasker/providers/providers.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    final DateProvider dateProvider = Provider.of<DateProvider>(context);
    final PriorityProvider priorityProvider =
        Provider.of<PriorityProvider>(context);
    final TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    return Container(
      child: TableCalendar(
        calendarController: _calendarController,
        initialCalendarFormat: CalendarFormat.week,
        initialSelectedDay: DateTime.now(),
        onDaySelected: (day, events) {
          dateProvider.updateTime = day;
          tasksProvider.refresh(
              dateProvider.time, priorityProvider.selectedPriorities);
          // dateProvider.notifyDateListeners();
        },
        onHeaderTapped: (focusedDay) {
          setState(() {
            _calendarController.setSelectedDay(DateTime.now());
            dateProvider.updateTime = DateTime.now();
            tasksProvider.refresh(
                dateProvider.time, priorityProvider.selectedPriorities);
          });
        },
        headerStyle: HeaderStyle(
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            border: const Border(
              top: BorderSide(),
              bottom: BorderSide(),
              left: BorderSide(),
              right: BorderSide(),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            color: Theme.of(context).primaryColor,
          ),
          formatButtonTextStyle: TextStyle(
            color: Theme.of(context)
                .copyWith(accentColor: Color(0xffF1FAEE))
                .accentColor,
          ),
        ),
        calendarStyle: CalendarStyle(
          todayColor: const Color(0xff457B9D),
          selectedColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }
}
