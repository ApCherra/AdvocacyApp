import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:intl/intl.dart';

import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';

class Progress<DateTime, String, int> {
  final DateTime date;
  final String comment;
  final int distance;

  Progress(this.date, this.comment, this.distance);
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // var distanceCollection = FirebaseFirestore.instance.collection("distance");
  // final user = FirebaseAuth.instance.currentUser!;
  List<Progress> progressList = [];
  DateTime today = DateTime.now();

  DateTime selectedDay = DateTime.now();
  late List<CleanCalendarEvent> selectedEvent;
  Map<DateTime, List<CleanCalendarEvent>> events = {};

  void _handleData(date) {
    setState(() {
      selectedDay = date;
      selectedEvent = events[selectedDay] ?? [];
    });
  }

  // Set the data in progressList based on data returned from DB.
  void setData(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      debugPrint("No such distance data for user.");
    }

    for (var item in data) {
      progressList.add(
          Progress(
              item['date'] ?? 0,
              item['comment'] ?? "No Comment.",
              item['distance'] ?? -1
          )
      );
    }

    // TODO: Investigate working nature of code.
    for (Progress progress in progressList) {
      DateTime dateTime = DateFormat('MM/dd/yyyy').parse(progress.date);
      List<CleanCalendarEvent> newEvent = [
        CleanCalendarEvent(
          '${progress.distance.roundToDouble()}m',
          color: Colors.green,
          description: progress.comment,
          isAllDay: true,
          startTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 2, 0, 0),
          endTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 2, 0, 0),
        )
      ];

      events[dateTime] = newEvent;
    }
  }

  @override
  void initState() {
    selectedEvent = events[selectedDay] ?? [];
    super.initState();
    getProgressData();
  }

  Future<void> getProgressData() async {
    // TODO: Get the progress data from user. [Need to Verify]

    // Note: it is handled from the server that only the user's data is returned.
    final query = await sbClient
        .from('distance')
        .select('*')
        .then(setData);

    // var querySnapshot =
    // await distanceCollection.where("user", isEqualTo: user.uid).get().then(
    //       (QuerySnapshot querySnapshot) async {
    //     if (querySnapshot.size > 0) {
    //       //add weekly progress
    //       // for each document record feeling and update calendar date
    //       for (var doc in querySnapshot.docs) {
    //         try {
    //           progressList.add(Progress(
    //               doc.get("date"), doc.get("comment"), doc.get("distance")));
    //         } catch (e) {
    //           progressList.add(
    //               Progress(doc.get("date"), "No comment", doc.get("distance")));
    //         }
    //       }
    //
    //       for (Progress progress in progressList) {
    //         DateTime dateTime = DateFormat('MM/dd/yyyy').parse(progress.date);
    //         List<CleanCalendarEvent> newEvent = [
    //           CleanCalendarEvent(
    //             '${progress.distance.roundToDouble()}m',
    //             color: Colors.green,
    //             description: progress.comment,
    //             isAllDay: true,
    //             startTime: DateTime(DateTime.now().year, DateTime.now().month,
    //                 DateTime.now().day + 2, 0, 0),
    //             endTime: DateTime(DateTime.now().year, DateTime.now().month,
    //                 DateTime.now().day + 2, 0, 0),
    //           )
    //         ];
    //
    //         events[dateTime] = newEvent;
    //       }
    //     } else {
    //       //no milestones
    //       print('No distances recorded for this user :(');
    //     }
    //   },
    //   onError: (e) => print("error $e"),
    // );
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Calendar(
              startOnMonday: true,
              selectedColor: Colors.green,
              todayColor: Colors.green,
              eventColor: Colors.green,
              onRangeSelected: (range) {
                print('selected Day ${range.from},${range.to}');
              },
              onDateSelected: (date) {
                return _handleData(date);
              },
              events: events,
              isExpanded: true,
              dayOfWeekStyle: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              bottomBarTextStyle: const TextStyle(
                color: Colors.white,
              ),
              hideBottomBar: false,
              hideArrows: false,
              weekDays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            ),
          ),
        ],
      ),
    );
  }
}


// eventListBuilder:
// (BuildContext context, List<CleanCalendarEvent> events) {
// return
// Text(
// selectedEvent[0].description,
// style: TextStyle(
// fontFamily: 'Inter',
// color: Colors.black,
// fontSize: 12,
// ),
// );
// },