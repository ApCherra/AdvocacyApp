import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';
import 'package:coa_progress_tracking_app/utilities/Pair.dart';
import 'package:coa_progress_tracking_app/utilities/types/coordinate.dart';
import 'package:coa_progress_tracking_app/utilities/types/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  // Order to load data.
  final bool ascendingOrder = false;

  // Used to determine if comment data should be written.
  bool isFirstFetch = true;

  // Milestone goals
  // Current goal, updated in _insertInDistance
  double currentGoal = 0;
  int totalGoal = 500;
  /// Used to Identify if the distance is for today
  int today = DateTime.now().day;

  // Used to determine row for selector handler
  int rowCount = 0;

  List<Location> locations = [];
  Map<String, Pair<double, DateTime>> distances = {};
  List<Map<String, dynamic>> oldComments = [];
  Map<DateTime, String> rawComments = {};
  List<Pair<String?, DateTime>> comments = [];
  List<DataRow> tableData = [];

  @override
  void initState() {
    super.initState();
    showLoading();

    loadLocationData();
    loadMilestoneData();
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
        DataCell(loading),
        DataCell(loading),
      ]));
    });
  }

  Future<void> loadLocationData() async {
    // Select all the locations. Sort by date.
    await sbClient
        .from('locations')
        .select()
        .order('date', ascending: ascendingOrder)
        .then((locs) {
          currentGoal = 0;
          _setMinutelyDistancesFrom(locs);
          _setupLocations(locs);
      }
    );

    // TODO: Implement add/modification of comments.
    await sbClient
        .from('distance')
        .select()
        .order('date', ascending: ascendingOrder)
        .then((newComments) {
          for (var commentData in newComments) {
            var date = DateTime.tryParse(commentData["date"]);
            // If the date is readable, then add the comment.
            if (date != null) {
              String comment = commentData["comment"];
              rawComments[DateTime(date.year, date.month, date.day, date.hour, date.minute)] = comment;
            }
          }
    });

    _generateTableData();
  }

  Future<void> loadMilestoneData() async {
    // Select all the locations. Sort by date.
    await sbClient
        .from('milestones')
        .select()
        .order('date', ascending: true)
        .then((milestones) {
          var now = DateTime.now().day;
          // This will loop through the available dates and select the most
          // recent, but not in the future date.
          for (var milestone in milestones) {
            DateTime date = DateTime.parse(milestone["date"]);
            if (date.day <= now) {
              setState(() {
                totalGoal = milestone["goal"];
              });
            }
          }
    }
    );
  }

  // Returns if two dates are within the same minute.
  bool _isSameMinute(DateTime current, DateTime last) {
    var dist = current.difference(last).inMinutes;

    if (dist <= 1 && dist >= -1) {
      return current.minute == last.minute;
    }

    return false;
  }

  // Calculates the distances based on the the input
  // coordinates. There must be at least two coords,
  // or the function will return 0.
  double sumLatLongs(List<Coordinate> coords) {
    double sum = 0;
    // There must exist 2+ coords.
    if (coords.length < 2) {
      return 0;
    }

    var max = coords.length;

    for (var i = 0; i < max - 1; i += 2) {
      sum += Geolocator.distanceBetween(
          coords[i].latitude(), coords[i].longitude(),
          coords[i + 1].latitude(), coords[i + 1].longitude()
      );
    }

    // Calculate last distance
    if (max % 2 == 1) {
      sum += Geolocator.distanceBetween(
          coords[max - 2].latitude(), coords[max - 2].longitude(),
          coords[max - 1].latitude(), coords[max - 1].longitude()
      );
    }

    return sum;
  }


  // Sum up distances from each minute.
  _setMinutelyDistancesFrom(List<Map<String, dynamic>> locsList) {

    // Keep track of the last date to check minute-by-minute
    DateTime? lastDate;

    // Keep track of all distances over a minute
    List<Coordinate> minuteDistances = [];

    // Iterate over all locations downloaded from database.
    for (var loc in locsList) {
      // Get Time Stamp of current loc's date
      DateTime date = DateTime.tryParse(loc['date']) ?? DateTime.now();

      // If lastDate is null, set to date.
      lastDate ??= date;

      // Check if we are in the same minute.
      if (_isSameMinute(date, lastDate!)) {
        // If we are in the same minute, simply add coords to the list.
        minuteDistances.add(
            Coordinate(
                latitude: loc['latitude'],
                longitude: loc['longitude']
            )
        );
      } else {
        // If we are in the next minute, sum the distances
        _insertInDistance(at: _getDateAndTimeFrom(lastDate), ifNotExist: Pair(sumLatLongs(minuteDistances), lastDate));
        // distances[] = ;

        // Take a copy of the last coord pair
        var lastCoord = minuteDistances.last;

        // Clear the list
        minuteDistances.clear();

        // Re-add the lsat coord for next calculation.
        minuteDistances.add(lastCoord);

        // Add the new coordinates
        minuteDistances.add(
            Coordinate(
                latitude: loc['latitude'],
                longitude: loc['longitude']
            )
        );
      }

      // Update the lastDate, for next calc.
      lastDate = date;
    }

    if (lastDate != null) {
      // Sum the last of data.
      _insertInDistance(at: _getDateAndTimeFrom(lastDate), ifNotExist: Pair(sumLatLongs(minuteDistances), lastDate));
    }
  }

  /// Insert the date into distance dictionary
  /// Also update the milestone distance or milestone goal for today
  _insertInDistance({String at = "", Pair<double, DateTime>? ifNotExist}) {
    ifNotExist ??= Pair(0, DateTime.now());
    if (distances.containsKey(at)) {
      distances[at]!.first += ifNotExist.first;
    }
    else {
      distances[at] = ifNotExist;
    }

    // Update the milestone distance for today
    if (ifNotExist.second.day == today) {
      setState(() {
        currentGoal += ifNotExist?.first ?? 0;
      });
    }
  }

  _setupLocations(List<Map<String, dynamic>> locs) {
    for (var loc in locs) {
      double latitude = 0;
      double longitude = 0;

      var lat = loc['latitude'];
      var lon = loc['longitude'];

      if (lat is double) {
        latitude = lat;
      } else {
        latitude = double.tryParse(lat) ?? 0;
      }

      if (lon is double) {
        longitude = lon;
      } else {
        longitude = double.tryParse(lon) ?? 0;
      }

      locations.add(
          Location(coordinate:
          Coordinate(
            latitude: latitude,
            longitude: longitude,
          ),
            date: DateTime.tryParse(loc['date']) ?? DateTime.now(),
          )
      );
    }
  }


  Widget  _getGoalLine() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Goal: ${currentGoal.ceil()}m / ${totalGoal}m',
            style: TextStyle(fontSize: 20.0),
          ),
          ElevatedButton(
            onPressed: () {
              _showAddMilestoneDialog(context);
            },
            child: Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getListView() {
    return Expanded(
      child: ListView(
        children: [
          _createTable(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          _getGoalLine(),
          _getListView(),
        ],
      ),
    );
  }


  void _showAddMilestoneDialog(BuildContext context) {
    // Defines the keys and controllers needed to validate and save form data.
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _milestoneNameController = TextEditingController();
    final TextEditingController _milestoneTypeController = TextEditingController();
    final TextEditingController _goalController = TextEditingController();
    DateTime _startingDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Milestone'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _milestoneNameController,
                    decoration: const InputDecoration(labelText: 'Milestone Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a milestone name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _milestoneTypeController,
                    decoration: const InputDecoration(labelText: 'Milestone Type'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a milestone type';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _goalController,
                    decoration: const InputDecoration(labelText: 'Goal'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return 'Please enter a numeric goal';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    title: const Text('Starting Date'),
                    subtitle: Text(
                      '${_startingDate.day}/${_startingDate.month}/${_startingDate.year}',
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _startingDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _startingDate) {
                        // Updates the starting date
                        _startingDate = picked;
                        // Calls setState to refresh the dialog UI with the new date.
                        (context as Element).markNeedsBuild();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {

                  // Update the milestone
                  var name = _milestoneNameController.text;
                  var type = _milestoneTypeController.text;
                  var goal = _goalController.text;
                  var dateStr = _startingDate.toIso8601String();
                  _updateMilestone(name, type, goal, dateStr);

                  // Clears the text fields
                  _milestoneNameController.clear();
                  _milestoneTypeController.clear();
                  _goalController.clear();

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // This method is called when the Save button in the dialog is pressed
  void saveMilestone(String name, String type, int goal, DateTime startDate) async {
    // Logic to save the milestone data to the database
    var response = await sbClient.from('milestones').insert({
      'name': name,
      'type': type,
      'goal': goal,
      'start_date': startDate.toIso8601String(),
    });

    // Now response' should be a PostgrestResponse object
    if (response.error != null) {
      // Handles the error
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save milestone: ${response.error.message}"))
      );
    }
  }

  void _generateTableData() {
    rowCount = 0;
    var entries = distances.entries;

    if (entries.isNotEmpty) {
      tableData.clear();
      for (var distance in entries) {
        setState(() {
          tableData.add(_getRowFrom(distance));
        });
      }

      // Entries loaded
      isFirstFetch = false;
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
          DataCell(offline),
          DataCell(offline),
        ]));
      });

      // Entries did not update, await network.
      isFirstFetch = true;
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

        if (result != 0) {
          return result;
        }

        first = a.cells[2];
        second = b.cells[2];

        result = (first.child as Text).data?.compareTo((second.child as Text).data ?? "") ?? 0;
      }

      return result;
    });
  }

  String? _getCommentWithDate(DateTime date) {
    String? value = rawComments[date];

    comments.add(Pair(value,date));

    return value;
  }

  String? _getLocalCommentWithDate(DateTime date) {

    for (var commentPair in comments) {
      if (_compareDate(commentPair.second, date)) {
        return commentPair.first;
      }
    }

    return null;
  }

  bool _compareDate(DateTime first, DateTime second) {
    return
      first.minute == second.minute &&
      first.hour == second.hour &&
      first.day == second.day &&
      first.month == second.month &&
      first.year == second.year;
  }

  DataRow _getRowFrom(MapEntry<String, Pair<double, DateTime>> distanceInfo) {
    // Need local variable to use as constant value for the editComment param.
    int count = rowCount;
    rowCount += 1;
    return DataRow(
        onSelectChanged: (isSelected) {
          isSelected ??= false;
          if (isSelected) {
            editComment(count);
          }
        },
        cells: [
      _getDateCell(distanceInfo.value.second), // Date
      _getTimeCell(distanceInfo.key), // Time
      _getDistanceCell(distanceInfo.value.first), // Distance
      _getCommentCell(distanceInfo.value.second), // Comment
    ]);
  }

  String _getDateAndTimeFrom(DateTime time) {
    return "${_formattedTime(time.month)}/${_formattedTime(time.day)}/${_formattedTime(time.year)} ${_formattedTime(time.hour)}:${_formattedTime(time.minute)}";
  }

  DataTable _createTable() {
    return DataTable(columns: _createCols(), rows: _createRows());
  }

  List<DataColumn> _createCols() {
    return [
      const DataColumn(label: Text("Date")),
      const DataColumn(label: Text("Time")),
      const DataColumn(label: Text("Distance (m)")),
      const DataColumn(label: Text("Comment")),
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
      return "Today";
    }

    if (difference == -1) {
      return "Yesterday";
    }

    return "${date.month}/${date.day}/${date.year}";
  }

  DataCell _getDateCell(DateTime? date) {
    if (date != null) {
      // Add day
      return DataCell(Text(_getDayStringFromDate(date)));
    } else {
      return DataCell(_getNaText("Date"));
    }
  }

  DataCell _getTimeCell(String? date) {
    if (date != null) {
      // Add day
      return DataCell(Text(date.split(" ").lastOrNull ?? ""));
    } else {
      return DataCell(_getNaText("Time"));
    }
  }

  DataCell _getDistanceCell(double? dist) {
    if (dist != null) {
      // Add day
      return DataCell(Text(dist.toStringAsFixed(3)));
    } else {
      return DataCell(_getNaText("Distance"));
    }
  }
  DataCell _getCommentCell(DateTime? date) {
    String? name;

    // If the date is non-null, set the name to the comment, if any
    if (date != null) {
      if (isFirstFetch) {
        name = _getCommentWithDate(
          // Strip the data down to only required attributes.
            DateTime(
              date.year,
              date.month,
              date.day,
              date.hour,
              date.minute,
            )
        );

      } else {
        name = _getLocalCommentWithDate(
          // Strip the data down to only required attributes.
            DateTime(
              date.year,
              date.month,
              date.day,
              date.hour,
              date.minute,
            )
        );
      }

    }

    if (name != null) {
      return DataCell(Text(name));
    } else {
      return DataCell(_getNaText("No comment", usesDefault: false));
    }
  }

  String _formattedTime(int time) {
    if (time < 10) {
      return "0$time";
    } else {
      return "$time";
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

  int? calculateCurrentGoal() {
    return null;
  }

  /// Add the milestone given the name, type, and goal.
  void _updateMilestone(String? name, String type, String goal, String dateStr) async {
    setState(() {
      totalGoal = int.tryParse(goal) ?? 500;
    });

    await sbClient.from('milestones').insert({
      'name': name,
      'type': type,
      'goal': goal,
      'date': dateStr,
      'user_id': SupabaseDB.instance.user?.id
    });

  }

  void _editCommentDialog(BuildContext context, int indexForComment) {
    // Defines the keys and controllers needed to validate and save form data.
    final formKey = GlobalKey<FormState>();
    final TextEditingController comment = TextEditingController();

    // Set the text to current comment.
    comment.text = _getCommentForRow(indexForComment);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Comment:'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: comment,
                    decoration: const InputDecoration(labelText: 'New Comment:'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a milestone name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Update the Comment
                  var newComment = comment.text;

                  _postCommentChange(newComment, indexForComment);

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Open the dialog. This is the event handler for a touch on the row.
  void editComment(int rowCount) {
    _editCommentDialog(context, rowCount);
  }

  // Post the comment change to the server and update the UI
  void _postCommentChange(String newComment, int index) async {
    if (index < comments.length) {

      await sbClient
          .from('distance')
          .upsert({
        'date': comments[index].second.toIso8601String(),
        'comment': newComment,
      }).whenComplete(() {
        // Update the local variable
        // Reload the table data
        setState(() {
          comments[index].first = newComment;
          _generateTableData();
        });
      });
    }
  }

  // Get the comment for the row at the index. Called from the Dialog method.
  String _getCommentForRow(int index) {
    String returnValue = "";

    // validate index
    if (index < comments.length) {
      returnValue = comments[index].first ?? "";
    }

    return returnValue;
  }
}



