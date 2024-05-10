// TODO: Import Supabase libs

import 'package:coa_progress_tracking_app/utilities/Pair.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:coa_progress_tracking_app/utilities/app_bar_wrapper.dart';

// TODO: Add DBInstance
/*
final DBInstance = FirebaseFirestore.instance;
final global_current_user = FirebaseAuth.instance.currentUser!;
final geoptList = <GeoPoint>[];
 */
bool? locationSlider = true;

Timer? timer;
Timer? timer2;

List<int> geoptListStrings = [];



// this function creates a geopoint and adds it to the global geopoint list
void myLocationFunction() async
{
  // TODO: Change as needed.
  // TODO: Rename function.

  // double long = 0.0;
  // double lat = 0.0;
  // //Pair<double, double> longlatPair = Pair(0.0, 0.0);
  //
  // Pair<double, double> longlatPair = await getLatLoong() as Pair<double, double>;
  // lat = longlatPair.Goal; // pair.second
  // long = longlatPair.Name; // pair.first
  // print("lat: ${lat.toString()}, long: ${long.toString()}");
  //
  // //add geopoint to list
  // geoptList.add(GeoPoint(lat, long));
  // //geoptListStrings.add(5);
  // print("Added geopoint. geoptList length: ${geoptList.length}");

}

//this function is called every 5 minutes to add the geopointlist distance to firebase
void myLocationFunction2() async
{
  //print("geoptliststrings length: ${geoptListStrings.length}");
  //print("geoptList length: ${geoptList.length}");

  // TODO: Change function name
  // TODO: Update code as needed for Supabase.

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  //
  // final CollectionReference distanceCollection =
  // DBInstance.collection('distance');
  // //if geoptList length > 10, convert to a single distance and output to db
  //
  // double totalDistance = 0;
  // double localDistance = 0;
  // print("geoptList length: ${geoptList.length}");
  // if(geoptList.length > 4)
  // {
  //
  //   for (int i = 0; i < geoptList.length - 1; i++) {
  //     localDistance = calculate_distance(geoptList[i], geoptList[i + 1]);
  //     totalDistance += localDistance;
  //   }
  //
  //   //output total distance to database
  //   DateTime now = DateTime.now();
  //
  //
  //   var querySnapshot = distanceCollection
  //       .where('date', isEqualTo: "${now.month}/${now.day}/${now.year}")
  //       .where('user', isEqualTo: global_current_user.uid)
  //       .get()
  //       .then(
  //         (QuerySnapshot doc) async => {
  //       if (doc.size > 0)
  //         {updateDoc(doc, doc.docs.first.id, totalDistance)}
  //       else
  //         {
  //           await FirebaseFirestore.instance.collection('distance').add({
  //             'distance': totalDistance,
  //             'user': global_current_user.uid,
  //             'date': "${now.month}/${now.day}/${now.year}",
  //             'DateTime': DateTime.now(),
  //           })
  //         }
  //     },
  //     onError: (e) => print("error $e"),
  //   );
  //
  //   geoptList.clear();
  //   print("finished update in mylocation2 method");
  // }
  // print("finished mylocation2 method\n");

}

class LocationModule extends StatefulWidget {
  const LocationModule({super.key});

  @override
  State<LocationModule> createState() => _LocationModuleState();
}

class _LocationModuleState extends State<LocationModule> {
  bool gps_enabled = false;
  bool has_permission = false;
  late LocationPermission permission;
  late Position position;
  double long = 0.0, lat = 0.0;
  // TODO: Get ref to user if needed.
  // final user = FirebaseAuth.instance.currentUser!;
  int count = 0;

  // TODO: Get the length of locations.
  // final Future<int> locationTableLength =
  //     FirebaseFirestore.instance.collection('location').snapshots().length;


  checkGPSPermissions() async {
    gps_enabled = await Geolocator.isLocationServiceEnabled();
    if (gps_enabled == true) {
      print('gps enabled');
      //get permission for location services
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('No location permissions');
        } else {
          print('Location permissions enabled');
          has_permission = true;
        }
      } else {
        print('Location permissions enabled');
        has_permission = true;
      }
    }
    setState(() {});
  }



  //LocationModuleEngine engine = new LocationModuleEngine();



  @override
  void initState() {
    super.initState();
    setState(() {
      checkGPSPermissions();
    });
    setState(() {

    });

    //WORK MANAGER CODE for running in background
    // Workmanager().initialize(
    //   callbackDispatcher3,
    //   isInDebugMode: true,
    // );
    //
    // Workmanager().registerPeriodicTask(
    //   "task-identifier",
    //   "simpleTask",
    //   frequency: Duration(minutes: 15),
    //   inputData: {
    //     'strlist': geoptListStrings,
    //   },
    // );
    // Workmanager().registerOneOffTask("task-identifier", "simpleTask");

    if(timer2 == null)
    {
      timer = Timer.periodic(const Duration(seconds: 20), (Timer t) => myLocationFunction());
      timer2 = Timer.periodic(const Duration(minutes: 2), (Timer t) => myLocationFunction2());
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //double locationSlider = 0;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
              backgroundColor: Colors.grey[100],

              /// ***** App Bar ***** ///
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: AppBarWrapper(
                  title: "Location",
                ),
              ),
              body: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Text("Location Status",
                            style: TextStyle(fontSize: width * 0.1)),
                      ),
                      Text(gps_enabled ? "GPS is Enabled" : "GPS is not enabled",
                          style: const TextStyle(fontSize: 30)),
                      Text(
                          has_permission
                              ? "GPS has permission"
                              : "GPS doesn't have permission",
                          style: const TextStyle(fontSize: 30)),
                      Checkbox(
                        value: locationSlider,
                        onChanged: (newBool) {
                          setState(() {
                            locationSlider = newBool;
                          });
                          print("location tracking is: $locationSlider");
                          if(locationSlider == false)
                          {
                            timer?.cancel();
                            timer2?.cancel();
                            print("timer canceled.");
                            setState(() {gps_enabled = false;});
                          }
                          else if(locationSlider == true && timer2?.isActive == false)
                          {
                            timer = Timer.periodic(const Duration(minutes: 1), (Timer t) => myLocationFunction());
                            timer2 = Timer.periodic(const Duration(minutes: 5), (Timer t) => myLocationFunction2());
                            print("timer restarted");
                            setState(() {gps_enabled = true;});
                          }
                        },
                      ),
                    ],
                  )));
        });
  }
}

// TODO: Write new updateDoc func.
// updateDoc(QuerySnapshot doc, String docID, double totalDistance) {
//   Map<String, dynamic> data = doc.docs.first.data() as Map<String, dynamic>;
//   data['distance'] += totalDistance;
//   data['DateTime'] = DateTime.now(); //TODO: check (3/20)
//
//   final docRef = DBInstance.collection('distance').doc(docID);
//   docRef.update(data).then(
//         (value) => print("Document updated"),
//     onError: (e) => print("error $e"),
//   );
// }

Future<Pair> getLatLoong() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  double long = position.longitude;
  double lat = position.latitude;
  print("got lat: $lat, got long: $long");

  Pair<double, double> coords = Pair(long, lat);
  return coords;
}

//this function calculates the distance between two geopoints
// TODO: Use new type as needed.
// double calculate_distance(GeoPoint point1, GeoPoint point2) {
//   return Geolocator.distanceBetween(
//       point1.latitude, point1.longitude, point2.latitude, point2.longitude);
// }




// **********************************
// OLD CODE BELOW FOR REFERENCE
// **********************************


// **** Work manager function not working because cant pass dynamic geopoint list
// @pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher3() {
//   Workmanager().executeTask((task, inputData) async {
//     print("Native called background task: yoo6"); //simpleTask will be emitted here.
//
//     //print("test: $test");
//     //print("geoptListStrings length: ${geoptList.length}");
//
//     print("finished isolate method\n");
//
//     return Future.value(true);
//   });
// }

// @pragma('vm:entry-point')
// void isolateLocationTracking(int instance)
// {
//   //await Firebase.initializeApp();
//   //var db = FirebaseFirestore.instance;
//   // final CollectionReference distanceCollection =
//   // FirebaseFirestore.instance.collection('distance');
//   double long = 0.0, lat = 0.0;
//   //final user = FirebaseAuth.instance.currentUser!;
//   int count = 0;
//   double locationSlider = 0;
//   //final Future<int> locationTableLength =
//   //    FirebaseFirestore.instance.collection('location').snapshots().length;
//   final geopointList = <GeoPoint>[];
//   const int num_geopoints = 5; // NUMBER OF GEO POINTS PER DISTANCE VALUE
//   const int total_geopoints = 20; // TOTAL NUMBER OF GEO POINTS - not used
//   const int x_seconds = 5; //GEO POINTS ARE GENERATED EVERY X SECONDS
//   late Position position;
//
//
//   print("inside isolate");
//   while(true)
//     {
//       print(instance);
//     }
//   //sendData(x_seconds, geopointList);
//   // instance.collection('distance').add({
//   //               'distance': 7,
//   //               'user': "FFEzb4j59aPCUtXqiSJ93q7jgyr2",
//   //               'date': "yo",});
//
//
// }

// const fetchBackground = "fetchBackground";
//
//
//
// //this function converts X geopoints points into a single distance and outputs to firebase
// Future convertToDistance(List<GeoPoint> geopointList) async {
//
//   //first convert all points in the geopointList to a single distance
//   double total_distance = 0;
//   double local_distance = 0;
//   for (int i = 0; i < geopointList.length - 1; i++) {
//     local_distance = calculate_distance(geopointList[i], geopointList[i + 1]);
//     total_distance += local_distance;
//   }
//
//   //output total distance to database
//   DateTime now = DateTime.now();

// total_distance = 50; //TODO: REMOVE THIS ONLY FOR TESTING
//we get the current doc and update it if it exists, else create one for today
// var querySnapshot = distanceCollection
//     .where('date', isEqualTo: "${now.month}/${now.day}/${now.year}")
//     .where('user', isEqualTo: uid)
//     .get()
//     .then(
//       (QuerySnapshot doc) async => {
//     if (doc.size > 0)
//       //{updateDoc(doc, doc.docs.first.id, total_distance)}
//       print("failed update")
//     else
//       {
//         await FirebaseFirestore.instance.collection('distance').add({
//           'distance': total_distance,
//           'user': uid,
//           'date': "${now.month}/${now.day}/${now.year}",
//         })
//       }
//   },
//   onError: (e) => print("error $e"),
// );

// geopointList.clear();
// }
//

//

//
// // //this function creates a geopoint every X seconds and adds it to the geopointList
// // Future sendData(int x_seconds, List<GeoPoint> geopointList,
// //     int num_geopoints) async {
// //   final CollectionReference locationCollection =
// //       FirebaseFirestore.instance.collection('location');
// //
// //   double long = 0.0;
// //   double lat = 0.0;
// //   Pair<double, double> longlatPair = Pair(0.0, 0.0);
// //   //the main loop which iterates until total_geopoints.
// //   //TODO: CHANGE TO ITERATE WHILE APP IS OPEN OR OPEN IN BACKGROUND
// //   //was count < total_geopoints
// //   int count = 0;
// //   while (true && count < 10) {
// //     await Future(() async {
// //       //get location and latitude
// //       longlatPair = await getLatLong() as Pair<double, double>;
// //       print("lat: ${lat.toString()}, long: ${long.toString()}");
// //
// //       //add geopoint to list
// //       geopointList.add(GeoPoint(lat, long));
// //
// //       //when the list length reaches num_geopoints a distance value is created and pushed
// //       if (geopointList.length == num_geopoints) {
// //         convertToDistance(geopointList, global_current_user.uid);
// //       }
// //
// //       //geopoints are generated every x seconds
// //       sleep(Duration(seconds: x_seconds));
// //       count++;
// //     });
// //   }
// //   print("finished");
// // }


