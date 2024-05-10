import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';
import 'package:coa_progress_tracking_app/utilities/emotion_translator.dart';
import 'package:flutter/material.dart';

class EmotionViewerPage extends StatefulWidget {
  const EmotionViewerPage({super.key});

  @override
  State<EmotionViewerPage> createState() => _EmotionViewerPage();
}

class _EmotionViewerPage extends State<EmotionViewerPage> {
  // Order to load data.
  final bool ascendingOrder = true;
  final bool is24Hr = true;

  Map<DateTime, int> emotions = {};
  List<DataRow> tableData = [];

  @override
  void initState() {
    super.initState();

    showLoading();
    loadData();
  }

  // Show loading in the first row of the table
  void showLoading() {
    const loading = Text(
        "Loading",
        style: TextStyle(fontStyle: FontStyle.italic)
    );

    setState(() {
      tableData.add(const DataRow(cells: [
        DataCell(loading),
        DataCell(loading),
      ]));
    });
  }

  Future<void> loadData() async {
    // Select all the locations. Sort by date.
    await sbClient
        .from('emotions')
        .select()
        .order('created_at', ascending: ascendingOrder)
        .then((rawEmotions) {
      _processRawEmotions(rawEmotions);
    }
    );

    _generateTableData();
  }

  // Sum up distances from each minute.
  _processRawEmotions(List<Map<String, dynamic>> rawEmotions) {
    for (var emotion in rawEmotions) {
      var date = DateTime.tryParse(emotion["created_at"] as String);

      if (date != null) {
        emotions[date] = emotion["emotion"];
      }

    }
  }

  void _generateTableData() {
    var entries = emotions.entries;

    if (entries.isNotEmpty) {
      tableData.clear();
      for (var distance in entries) {
        setState(() {
          tableData.add(_getRowFrom(distance));
        });
      }
    } else {
      tableData.clear();
      const offline = Text(
          "Offline",
          style:
          TextStyle(fontStyle: FontStyle.italic)
      );

      setState(() {
        tableData.add(const DataRow(cells: [
          DataCell(offline),
          DataCell(offline),
        ]));
      });
    }

    tableData.sort((a,b) {
      int result = 0;
      var first = a.cells.firstOrNull;
      var second = b.cells.firstOrNull;

      if (first != null && second != null) {
        result = (first.child as Text).data?.compareTo((second.child as Text).data ?? "") ?? 0;

        if (result != 0) {
          return result;
        }

        first = a.cells[1];
        second = b.cells[1];

        result = (first.child as Text).data?.compareTo((second.child as Text).data ?? "") ?? 0;
      }

      return result;
    });
  }

  DataRow _getRowFrom(MapEntry<DateTime, int> emotionEntry) {
    return DataRow(cells: [
      _getDateCell(emotionEntry.key), // Date
      _getEmotion(emotionEntry.value), // Emotion
    ]);
  }

  DataTable _createTable() {
    return DataTable(columns: _createCols(), rows: _createRows());
  }

  List<DataColumn> _createCols() {
    return [
      const DataColumn(label: Text("Date")),
      const DataColumn(label: Text("Emotion")),
    ];
  }

  /// Negative value means it was before today.
  /// Positive value means it was after today.
  /// Zero value means it is today.
  int _differenceBetweenDates(DateTime first, {DateTime? second}) {
    second ??= DateTime.now();
    return second.difference(first).inDays;
  }

  String _getDayStringFromDate(DateTime date) {
    var difference = _differenceBetweenDates(date);

    if (difference == 0) {
      return "Today @ ${_getHourFormatted(date.hour, date.minute)}";
    }

    if (difference == -1) {
      return "Yesterday @ ${_getHourFormatted(date.hour, date.minute)}";
    }

    return "${date.month}/${date.day}/${date.year} @ ${_getHourFormatted(date.hour, date.minute)}";
  }

  DataCell _getDateCell(DateTime? date) {
    if (date != null) {
      // Add day
      return DataCell(Text(_getDayStringFromDate(date)));
    } else {
      return DataCell(_getNaText("Date"));
    }
  }

  DataCell _getEmotion(int? emotion) {
    if (emotion != null) {
      // Add day
      return DataCell(Text(EmotionTranslator.instance.getEmotionString(fromCode: emotion)));
    } else {
      return DataCell(_getNaText("Emotion"));
    }
  }

  Text _getNaText(String? field, {bool usesDefault = true}) {
    field ??= "Unknown";
    return Text(
      usesDefault ? "$field Unavailable!" : field,
      style: const TextStyle(fontStyle: FontStyle.italic),
    );
  }

  /// Return the rows, based on the locations given by locations and comments
  List<DataRow> _createRows() {
    return tableData;
  }

  _getHourFormatted(int hour, int minute) {
    var time = "";
    if (is24Hr) {
      // Add the hour to the time, adding 0 if needed
      time = "${hour < 10 ? "0" : ""}$hour:";
      // Add the minute to the time, adding 0 if needed
      time += "${minute < 10 ? "0" : ""}$minute";
    } else {
      // Return a 12-hr version
      // Add the hour to the time, adding 0 if needed
      time = "${hour < 10 ? "0" : ""}${hour % 12}:";
      // Add the minute to the time, adding 0 if needed with AM/PM
      time += "${minute < 10 ? "0" : ""}$minute ${hour < 12 ? "A" : "P"}M";
    }

    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: ListView(
          children: [
            _createTable()
          ],
        )
    );
  }
}