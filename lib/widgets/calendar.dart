import 'package:flutter/material.dart';
import 'package:mis_lab03/model/Exam.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatelessWidget {
  final List<dynamic> events;

  const Calendar({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Exams calendar',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
        ),
        body: Container(
            child: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(_getDataSource()),
          todayHighlightColor: Colors.orange,
          backgroundColor: Colors.white30,
          showNavigationArrow: true,
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showAgenda: true,
            navigationDirection: MonthNavigationDirection.horizontal,
            agendaViewHeight: 80,
            agendaItemHeight: 65,
            agendaStyle: AgendaStyle(
              appointmentTextStyle: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        )));
  }

  List<Appointment> _getDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    for (var i in events) {
      final DateTime startTime = i.examDateTime;
      final DateTime endTime = startTime.add(const Duration(hours: 2));
      appointments.add(
          Appointment(i.courseName, startTime, endTime, Colors.orange, false));
    }
    return appointments;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Appointment {
  Appointment(
      this.eventName, this.from, this.to, this.background, this.isAllDay);
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
