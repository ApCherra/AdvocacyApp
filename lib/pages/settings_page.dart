import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';
import 'package:flutter/material.dart';
import 'package:coa_progress_tracking_app/utilities/app_bar_wrapper.dart';
import 'package:mutex/mutex.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

// Adds the global variables from LocationModule
final List<Map<String, dynamic>> geoPoints = [];
bool isLocationServicesEnabled = true;
Timer? timer;
Timer? timer2;
List<int> geoptListStrings = [];

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double volume = 0.2;
  String username = "Unknown Username";
  String name = "Unknown Name";
  String password = "Unknown Password";

  // Controller for renaming.
  final TextEditingController renameTextController = TextEditingController();

  bool isGpsEnabled = false;
  late LocationPermission permission;
  double long = 0.0, lat = 0.0;

  final mutex = Mutex();

  @override
  void initState() {
    super.initState();
    getVolume();
    // Retrieve profile data on init
    getProfileData();

    // Initializes GPS permissions
    checkGPSPermissions();
    
    if (isLocationServicesEnabled) {
      // Start timers for location tracking if enabled
      timer = Timer.periodic(const Duration(minutes: 1), (Timer t) => addCurrentPositionToList());
      timer2 = Timer.periodic(const Duration(minutes: 5), (Timer t) => syncLocationDataWithServer());
    }
  }

  // GPS Permission checking
  void checkGPSPermissions() async {
    bool isGPSEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission currentPermission = await Geolocator.checkPermission();

    if (!isGPSEnabled) {
      // Request user to enable GPS
      showDialog(context: context, builder: (_) {
        return AlertDialog(title: Text("GPS Services Disabled!"), content: Text("Please enable Location Services via Settings on this device!"));
      });
    } else {
      // GPS is enabled, check for app permissions
      if (currentPermission == LocationPermission.denied) {
        currentPermission = await Geolocator.requestPermission();
      }
      if (currentPermission == LocationPermission.whileInUse ||
          currentPermission == LocationPermission.always) {
        setState(() {
          isGpsEnabled = true;
        });
      }
    }
  }

  // Add the current location to the location list.
  // This data will be stored in the DB.
  void addCurrentPositionToList() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final getPointData = {
      "date" : DateTime.timestamp(),
      "latitude" : position.latitude,
      "longitude" : position.longitude,
    };

    await mutex.protect(() async {
        geoPoints.add(getPointData);
    });
  }

  // Supabase Update Logic
  // Sync data points to server. Remove logged data once completed.
  // TODO: Verify sync works
  void syncLocationDataWithServer() async {
    await mutex.protect(() async {
      await sbClient
          .from('locations')
          .insert(geoPoints);

      geoPoints.clear();
    });
  }

  // Methods from ProfilePage
  void getProfileData() async {
    name = SupabaseDB.instance.getName();

    // Set username
    username = SupabaseDB.instance.user?.userMetadata?["username"] ?? "Failed to retrieve.";

    // Set password field.
    password = "Click Button To Reset.";
  }

  // Display an alert with a text field.
  // Help From (Stack Overflow) [https://stackoverflow.com/questions/66805535/flutter-flatbutton-is-deprecated-alternative-solution-with-width-and-height]
  Future<void> displayRenamePrompt(BuildContext context, String field) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('What should we rename \'$field\' to?'),
          content:
          TextField(
            controller: renameTextController,
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  foregroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.red)),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                if (field == "Name") {
                  final name = renameTextController.text;
                  final spaceIndex = name.indexOf(' ');
                  final firstName = name.substring(0, spaceIndex);

                  final isSpaceInMiddle =
                      spaceIndex < renameTextController.text.length - 1;

                  final lastName = isSpaceInMiddle
                      ? name.substring(spaceIndex + 1)
                      : ''; // No last name provided.

                  setState(() {
                    this.name = name;
                  });

                  // Update first and last name
                  await SupabaseDB.instance.updateUser("firstName", firstName);
                  await SupabaseDB.instance.updateUser("lastName", lastName);

                } else {
                  await SupabaseDB.instance.updateUser(
                      field.toLowerCase(), renameTextController.text);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Update the profile based on the button pressed.
  Future updateProfileField(String fieldName) async {
    switch (fieldName) {
      case "Password":
        final email = SupabaseDB.instance.user?.email ?? "";

        await sbClient.auth.resetPasswordForEmail(email);

        showDialog(context: context, builder: (_) {
          return AlertDialog(
              title: Text("Reset link sent!"),
              content: Text("Check your email for details to reset your password!"));
        });

        break;
      case "Name":
        renameTextController.text = SupabaseDB.instance.getName();

        displayRenamePrompt(context, fieldName);
        break;
      case "Username":
        renameTextController.text = SupabaseDB
          .instance
          .user?.userMetadata?['username'] ?? "<Unset>";

        displayRenamePrompt(context, fieldName);
        break;
      default: break;
    }
  }

  void getVolume() async {
    double currentVolume = await PerfectVolumeControl.getVolume();
    debugPrint("current volume is: $currentVolume");
    setState(() {
      volume = currentVolume;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
        backgroundColor: Colors.grey[300],

        /// ***** App Bar ***** ///
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBarWrapper(
            title: "Settings",
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                //add more rows for additional settings
                //NOTE: volume container
                buildProfileContainer("Username", username, width, height),
                buildProfileContainer("Name", name, width, height),
                buildProfileContainer("Password", password, width, height),
                buildLocationContainer(width, height),
                Container(
                  //color: Colors.grey[100],
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: const Border(
                            bottom: BorderSide(color: Colors.grey)
                        )
                    ),
                    child: Row(
                      //NOTE: NOTIFICATIONS ROW
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IntrinsicWidth(
                          child: Container(
                              constraints: BoxConstraints(
                                minWidth: width * 0.1,
                                maxWidth: width * 0.6,
                              ),
                              // username textbox container
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.025,
                                  vertical: height * 0.025),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.015),
                              decoration: BoxDecoration(
                                //color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  'Volume',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.black,
                                    fontSize: width * 0.05,
                                  ),
                                ),
                              )),
                        ),
                        Flexible(
                          child: Container(
                            //color: Colors.red,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.04,
                                  vertical: height * 0.01),
                              child: Transform.scale(
                                scale: 1 + (height * 0.00025),
                                child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 7,
                                    ),
                                    child: SizedBox(
                                        width: width * 0.3,
                                        height: height * 0.1,
                                        child: Slider(
                                          divisions: 5,
                                          max: 100,
                                          value: volume,
                                          onChanged: (newBool) {
                                            setState(() {
                                              volume = newBool;
                                            });
                                            debugPrint("volume is:  $volume");

                                            PerfectVolumeControl.setVolume(
                                                volume / 100);
                                            //print("width is: $width");
                                          },
                                        ))),
                              )),
                        )
                      ],
                    )),
                //NOTE: Notifications container

              ],
            )));
  }

  Widget buildProfileContainer(String title, String value, double width,
      double height) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100],
          border: const Border(bottom: BorderSide(color: Colors.grey))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IntrinsicWidth(
            child: Container(
                constraints: BoxConstraints(
                  minWidth: width * 0.1,
                  maxWidth: width * 0.6,
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.025, vertical: height * 0.025),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02, vertical: height * 0.015),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text(
                    '$title: $value',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black,
                      fontSize: width * 0.05,
                    ),
                  ),
                )
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.01),
              child: SizedBox(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Implement the logic to edit the profile field
                    updateProfileField(title);
                  },
                  icon: title == "Password" ?
                    const Icon(Icons.lock_reset) : // Reset Password
                    const Icon(Icons.edit), // Edit Field
                  label: title == "Password" ?
                    const Text('Reset') : // Reset Password
                    const Text('Edit'), // Edit Field
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700], // or any other color
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildLocationContainer(double width, double height) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: const Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // GPS status and location tracking toggle

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.025, vertical: height * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location Tracking",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black,
                      fontSize: width * 0.05,
                    ),
                  ),
                  Switch(
                    value: isGpsEnabled,
                    onChanged: (bool value) {
                      if (value) {
                        checkGPSPermissions();
                      } else {
                        setState(() {
                          isGpsEnabled = false;
                        });
                      }
                    },
                  ),
                  Text(
                    isGpsEnabled ? "GPS Enabled" : "GPS Disabled",
                    style: TextStyle(
                      color: isGpsEnabled ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

