import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';
import 'package:coa_progress_tracking_app/pages/Bathroom.dart';
import 'package:coa_progress_tracking_app/pages/FoodDrink.dart';
import 'package:coa_progress_tracking_app/pages/emotions.dart';
import 'package:coa_progress_tracking_app/pages/games_page.dart';
import 'package:coa_progress_tracking_app/pages/report_page.dart';
import 'package:coa_progress_tracking_app/pages/settings_page.dart';
import 'package:coa_progress_tracking_app/pages/speech_page.dart';
import 'package:coa_progress_tracking_app/pages/BodyParts.dart';
import 'package:coa_progress_tracking_app/pages/playground_page.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/base_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/factory_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/row_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Colors for tiles
  final Map<String, Color> tileColors = {
    'Potty': Colors.lightBlue.shade300,
    'Celebrations': const Color(0xFF7C0D0E),
    'Games': Colors.green[900]!,
    'Food & Drink': Colors.orange.shade300,
    'Emotions': Colors.purple.shade300,
    'Speech': const Color(0xFF5D514A),
    'Body Parts': Colors.greenAccent
    // ... add more if needed
  };

  // The textColor for tiles
  final tileTextColor = Colors.white;

  // Determines if the last tile is centered.
  final centerLastTile = false;

  // List of tilesData
  final Map<String, Map<String, dynamic>> tilesData = {
    'Speech' : {
      'icon': Icons.record_voice_over,
      'nextPage': const SpeechPage(), // Replace with actual page
    },
    'Celebrations' : {
      'icon': Icons.attractions_outlined,
      'nextPage': const PlaygroundPage(),
    },
    'Body Parts' : {
      'icon': Icons.person,
      'nextPage': const BodyPartsPage(),
    },
    'Games': {
      'icon': Icons.videogame_asset,
      'nextPage': const GamePage(),
    },
    'Food & Drink': {
      'icon': Icons.fastfood,
      'nextPage': const FoodDrinkPage(),
    },
    'Emotions': {
      'icon': Icons.emoji_emotions,
      'nextPage': const EmotionsPage(),
    },
    'Potty' : {
      'icon': Icons.bathroom,
      'nextPage': const BathroomPage(),
    },
  };

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        key: Key('getAction'),

        resizeToAvoidBottomInset: false,
        // backgroundColor: backgroundColor,
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
                gradient: SweepGradient(
                    colors: [
                      Color(0xFF333366), // dark blue
                      Color(0xFF222244), // even darker blue/purple
                      Color(0xFF333366), // dark blue
                      Color(0xFF222244), // even darker blue/purple
                      Color(0xFF333366), // dark blue
                    ],
                    tileMode: TileMode.clamp
                )
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hello User
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getGreeting(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat.MMMMEEEEd().format(DateTime.now()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: _getActionButtons(),
                          ),
                        ],
                      ),

                      // Tiles
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              ..._getTileRows()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }

  List<TileRow>_getTileRows() {
    List<TileRow> rows = [];

    var max = tilesData.length - 1;

    var keys = tilesData.keys;

    for (var index = 0; index < max; index += 2) {
      rows.add(
          TileRow(
            first: _getTileFrom(keys.elementAt(index), tilesData[keys.elementAt(index)]!),
            second: _getTileFrom(keys.elementAt(index + 1), tilesData[keys.elementAt(index + 1)]!),
          )
      );
    }

    // Process last tile if needed
    if ((max + 1) % 2 == 1) {
      var tile = _getTileFrom(keys.last, tilesData.values.last);

      rows.add(_getOddRow(tile));
    }

    return rows;
  }

  BaseTile _getTileFrom(String name, Map<String, dynamic> tileAttrs) {
    return TileFactory.getTile(
        name: name,
        color: tileColors[name]!,
        icon: tileAttrs['icon'],
        nextPage: tileAttrs['nextPage'],
        isSquare: true,
        textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: tileTextColor,
        )
    );
  }

  TileRow _getOddRow(BaseTile tile) {
    if (centerLastTile) {
      return TileRow(first: tile);
    } else {
        return TileRow(
          first: tile,
          second: TileFactory.getBlankFromTile(tile),
        );
    }
  }

  List<BaseTile> _getActionButtons() {
    return [
      _getActionFrom(Icons.auto_graph, nextPage: const ReportPage()), // Reports Button
      _getActionFrom(Icons.settings, nextPage: const SettingsPage()), // Setting Button
      _getActionFrom(Icons.logout, handler: sbClient.auth.signOut) // Logout Button
    ];
  }

  BaseTile _getActionFrom(IconData? icon, {StatefulWidget? nextPage, Function? handler}) {
    return TileFactory.getTile(
        name: '',
        color: Colors.grey,
        noText: true,
        icon: icon,
        containerWidth: 50,
        containerHeight: 50,
        iconSize: 30,
        borderRadius: 12,
        nextPage: nextPage,
        handler: handler,
    );
  }

  // Return a time-based greeting such as good morning.
  String getTimeGreeting() {
    DateTime now = DateTime.now();
    if (now.hour < 4) {
      // 00:00 - 03:59 [midnight - 3am]
      return "Have a Good Night";
    } else if (now.hour <= 11) {
      // 04:00 - 11:59 [4am - noon)
      return "Good Morning";
    } else if (now.hour < 17) {
      // 12:00 - 16:59 [noon - 4pm]
      return "Good Afternoon";
    } else if (now.hour < 20) {
      // 17:00 - 19:59 [5pm - 7pm]
      return "Good Evening";
    }
    // 20:00 - 23:59 [8pm - midnight)
    return "Good Night";
  }

  String getGreeting() {
    return "${getTimeGreeting()}, ${SupabaseDB.instance.getName()}!";
  }
}