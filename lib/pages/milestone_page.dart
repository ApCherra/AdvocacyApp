// TODO: Import Supabase libs
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:coa_progress_tracking_app/utilities/reward_animator.dart';
import 'package:coa_progress_tracking_app/utilities/app_bar_wrapper.dart';


// TODO: Fix function names

// TODO: Fix naming conventions.

class Milestone<T1, T2, T3, T4, T5, T6, T7> {
  final T1 Name;
  final T2 Type;
  final T3 Goal;
  final T4 StartDateTime;
  final T5 EndDateTime;
  final T6 Progress;
  final T7 Claimed;

  Milestone(this.Name, this.Type, this.Goal, this.StartDateTime,
      this.EndDateTime, this.Progress, this.Claimed);
}

class MilestonePage extends StatefulWidget {
  const MilestonePage({super.key});

  @override
  State<MilestonePage> createState() => _MilestonePageState();
}

class _MilestonePageState extends State<MilestonePage> {
  final milestonesList = [];
  // Milestone<String, String, DateTime, DateTime, String> weeklyMilestone = new Milestone("test", "testgoal", DateTime.now(), DateTime.now(), "MainWeekly");

  // TODO: get the currnet user.
  late TextEditingController controller = TextEditingController();
  late TextEditingController goalcontroller = TextEditingController();
  late TextEditingController typecontroller = TextEditingController();
  late DateTime startDateTime;
  late DateTime endDateTime;

  final RewardAnimator _rewardAnimator = RewardAnimator();

  num dailyMilestoneGoal = 2000;
  num currentDailyProgress = 0;
  DateTime today = DateTime.now();

  Future getMilestoneData() async {
    // Get user collection
  }

  Future<void> getDailyMilestoneProgress() async {
    DateTime today = DateTime.now();
    DateTime startDate = DateTime(today.year, today.month, today.day, 0);
    DateTime endDate = DateTime(today.year, today.month, today.day, 23);
  }

  double showDailyValue() {
    if ((currentDailyProgress / dailyMilestoneGoal) < 1) {
      //TODO: DAILY GOAL ACHIEVED
      return (currentDailyProgress / dailyMilestoneGoal);
    } else {
      //TODO: IMPLEMENT CONFETTI AND AUDIO
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    getMilestoneData();
    today = DateTime.now();
    startDateTime = DateTime.now();
    endDateTime = DateTime(today.year, today.month, today.day + 1);
  }

  Future saveNewMilestone() async {
    setState(() {
      milestonesList.add(Milestone(controller.text, typecontroller.text,
          int.parse(goalcontroller.text), startDateTime, endDateTime, 0, 0));
      controller.clear();
      typecontroller.clear();
      goalcontroller.clear();
    });

    setState(() {});
  }

  Future<DateTime?> showCalender() async {
    final DateTime? result = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: DateTime(today.year, today.month, today.day),
        lastDate: DateTime(today.year, 12));
    if (result != null) {
      //set datetime
    }
    return result;
  }

  //create new milestone
  void createNewMilestone() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                actions: [
                  //save
                  MaterialButton(
                    onPressed: () {
                      saveNewMilestone();
                      Navigator.of(context).pop();
                    },
                    color: Colors.black,
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      controller.clear();
                    },
                    color: Colors.black,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                content: SizedBox(
                  height: 0.5 * MediaQuery.of(context).size.height,
                  //color: Colors.grey[200],
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //get user input
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Milestone Name",
                            ),
                          ),
                        ),
                        Text(
                          "Milestone Type",
                          style: TextStyle(
                            fontSize: width * 0.035,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const InputDecorator(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Milestone Type",
                            ),
                            child: Text('Distance'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: TextField(
                            controller: goalcontroller,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Goal",
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        Text(
                          "Starting Date",
                          style: TextStyle(
                            fontSize: width * 0.035,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 0.01 * height, bottom: 0.01 * height),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: EdgeInsets.only(left: 0.01 * height),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${startDateTime.month}/${startDateTime.day}/${startDateTime.year}",
                              ),
                              IconButton(
                                  onPressed: () async {
                                    DateTime? result = await showCalender();
                                    setState(() {
                                      startDateTime = result!;
                                    });
                                  },
                                  icon: const Icon(
                                      Icons.calendar_month_outlined)),
                            ],
                          ),
                        ),
                        Text(
                          "Ending Date",
                          style: TextStyle(
                            fontSize: width * 0.035,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0.01 * height),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: EdgeInsets.only(left: 0.01 * height),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${endDateTime.month}/${endDateTime.day}/${endDateTime.year}"),
                              IconButton(
                                  onPressed: () async {
                                    DateTime? result = await showCalender();
                                    setState(() {
                                      endDateTime = result!;
                                    });
                                  },
                                  icon: const Icon(
                                      Icons.calendar_month_outlined)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          });
        });
  }

  Future<void> editMilestone() async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                actions: [
                  //save
                  MaterialButton(
                    onPressed: () {
                      double newGoal = double.parse(goalcontroller.text);
                      // TODO: Call updateDailyMilestoneGoal func.
                      //updateDailyMilestoneGoal(newGoal);
                      Navigator.of(context).pop();
                    },
                    color: Colors.black,
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      goalcontroller.clear();
                    },
                    color: Colors.black,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                content: SizedBox(
                  height: 0.1 * MediaQuery.of(context).size.height,
                  //color: Colors.grey[200],
                  child: Column(
                    children: [
                      //get user input
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: TextField(
                          controller: goalcontroller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Goal",
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          });
        });
  }

  void deleteMilestone(int index) async {
    String name = milestonesList[index].Name;
    setState(() {
      milestonesList.removeAt(index);
    });
  }

  doNothing() {}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Stack(
        children: [
          Column(
            children: [
              //DAILY MILESTONE CARD:
              GestureDetector(
                onTap: () async {
                  await editMilestone();
                  setState(() {});
                },
                child: SizedBox(
                  //card
                  height: height * 0.1,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                leading: Icon(Icons.access_time, size: width * 0.05),
                                title: Text(
                                  'Daily Milestone',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.05),
                                ),
                                subtitle: Container(
                                  margin: EdgeInsets.only(top: height * 0.01),
                                  child: Text(
                                    'Goal: $dailyMilestoneGoal',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.normal,
                                        fontSize: width * 0.035,
                                        color: Colors.black.withOpacity(0.65)),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: Text(
                                    'Current: ${currentDailyProgress.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.normal,
                                      fontSize: width * 0.035,
                                      color: Colors.black.withOpacity(0.65),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: currentDailyProgress >= dailyMilestoneGoal,
                                  child: GestureDetector(
                                    onTap: () {
                                      _rewardAnimator.doConfetti();
                                      final player=AudioPlayer();
                                      player.play(AssetSource("dogs_out_short.mp3"));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                        height: width * 0.06,
                                        width: width * 0.18,
                                        color: Colors.blueAccent,
                                        child: Text(
                                          "Claim",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                              fontSize: width * 0.05
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            //alignment: Alignment.bottomCenter,
                            child: LinearProgressIndicator(
                              value: showDailyValue(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              /// MILESTONE LISTVIEW BUILDER:
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    itemCount: milestonesList.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        endActionPane: ActionPane(
                          extentRatio: 0.2,
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                deleteMilestone(index);
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          margin: EdgeInsets.symmetric(
                              horizontal: width * 0.040, vertical: height * 0.005),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ///milestone name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints:
                                    BoxConstraints(maxWidth: width * 0.55),
                                    child: Text(
                                      '${milestonesList[index].Name}',
                                      //overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: width * 0.05,
                                      ),
                                    ),
                                    //color: Colors.green,
                                  ),
                                  Container(
                                    //color: Colors.green,
                                    margin: EdgeInsets.only(top: height * 0.01),
                                    child: Text(
                                      'Goal: ${milestonesList[index].Goal}',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.normal,
                                        fontSize: width * 0.035,
                                        color: Colors.black.withOpacity(0.65),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //current progress towards goal
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    //color: Colors.green,
                                    margin: EdgeInsets.only(top: height * 0.01),
                                    child: Text(
                                      'Current: ${milestonesList[index].Progress.round()}',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.normal,
                                        fontSize: width * 0.035,
                                        color: Colors.black.withOpacity(0.65),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: milestonesList[index].Progress >= milestonesList[index].Goal && milestonesList[index].Claimed == 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        _rewardAnimator.doConfetti();
                                        final player=AudioPlayer();
                                        player.play(AssetSource("dogs_out_short.mp3"));
                                        deleteMilestone(index);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          height: width * 0.06,
                                          width: width * 0.18,
                                          color: Colors.blueAccent,
                                          child: Text(
                                            "Claim",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                                fontSize: width * 0.05
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          _rewardAnimator,
        ],
      ),
    );
  }
}
