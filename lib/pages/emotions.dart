import 'package:coa_progress_tracking_app/auth/util/supabase_db.dart';
import 'package:coa_progress_tracking_app/utilities/app_bar_wrapper.dart';
import 'package:coa_progress_tracking_app/utilities/emotion_translator.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/base_tile.dart';
import 'package:flutter/material.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/factory_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/row_tile.dart';


class EmotionsPage extends StatefulWidget {
  // Constructor with an optional key parameter.


  const EmotionsPage({Key? key}) : super(key: key);


  // createState is overridden to create the mutable state for this widget.
  @override
  State<EmotionsPage> createState() => _FoodDrinkPageState();


}


// The state class for FoodDrinkPage which holds the state and logic for the widget.
class _FoodDrinkPageState extends State<EmotionsPage> {
  // Creating an instance of FlutterTts to handle text-to-speech operations.
  final user = null; //FirebaseAuth.instance.currentUser!;
  final tileColor = const Color(0xFF2634AF);
  final tileTextColor = const Color(0xFFEADDC8);

  /// Save the selected feelings to the server.
  Future<void> sendFeelings(String emotion) async {

    // Get the int code to save in server
    final emotionCode = EmotionTranslator.instance
        .getEmotionCode(forEmotion: emotion);

    // Insert the value into the server.
    // ID, Date of Creation, and User ID are handled server-side.
    await sbClient
        .from("emotions")
        .insert({ "emotion" : emotionCode });
  }


  /// Given two colors return an array of the two colors
  /// for the colors of a tile.
  List<Color> _getColorsListFrom({required Color leftRight, required Color upDown}) {
    return [
      leftRight,
      upDown,
      leftRight,
      upDown,
      leftRight,
    ];
  }


  /// Given the tileName, return a tile with proper attributes.
  BaseTile _getTile(({List<Color> colors, String emoji, String tileName}) tileRecord, double width) {
    return TileFactory.getTile(
        name: tileRecord.tileName,
        color: Colors.white,

        /// Invoke Emotion Tile
        emoji: tileRecord.emoji,
        gradientColors: tileRecord.colors,

        isSquare: true,
        isSpeechEnabled: true,
        handler: () {
          sendFeelings(tileRecord.tileName);
          showDialog(context: context, builder: (_) {
            return AlertDialog(content: Text("${tileRecord.tileName} Feeling Recorded!"));
          }).then((value) {
            Navigator.pop(context);
          });
        }
    );
  }


  @override
  Widget build(BuildContext context) {


    Size size = MediaQuery.of(context).size;
    final width = size.width * 0.35;


    final List<({List<Color> colors, String emoji, String tileName})> emotionsAndSyms = [
      (tileName: "Bad",
      emoji: "🤬",
      colors: _getColorsListFrom(leftRight: const Color(0xFFB22222) /* firebrick */, upDown: const Color(0xFF7C0000) /* dark red */)
      ),
      // (tileName: "Fine",
      // emoji: "🤨",
      // colors: _getColorsListFrom(leftRight: const Color(0xFF778899) /* light slate gray */, upDown: const Color(0xFF2F4F4F) /* dark slate gray */)
      // ),
      (tileName: "Good",
      emoji: "🤭",
      colors: _getColorsListFrom(leftRight: const Color(0xFFBDB76B) /* dark khaki */, upDown: const Color(0xFF808000) /* olive */)
      ),
      (tileName: "Excellent",
      emoji: "🥰",
      colors: _getColorsListFrom(leftRight: const Color(0xFFADFF2F) /* green yellow */, upDown: const Color(0xFF006400) /* dark green */)
      ),
      (tileName: "Alright",
      emoji: "😐",
      colors: _getColorsListFrom(leftRight: const Color(0xFFA9A9A9) /* dark gray */, upDown: const Color(0xFF696969) /* dim gray */)
      ),
      // (tileName: "Horrible",
      // emoji: "😭",
      // colors: _getColorsListFrom(leftRight: const Color(0xFF8B0000) /* dark red */, upDown: const Color(0xFFA52A2A) /* brown */)
      // ),
      (tileName: "Sad",
      emoji: "😢",
      colors: _getColorsListFrom(leftRight: const Color(0xFFADD8E6) /* light blue */, upDown: const Color(0xFF00BFFF) /* deep sky blue */)
      ),
      (tileName: "Happy",
      emoji: "🤣",
      colors: _getColorsListFrom(leftRight: const Color(0xFFEEE8AA) /* pale goldenrod */, upDown: const Color(0xFFDAA520) /* golden rod */)
      ),
      (tileName: "Angry",
      emoji: "😤",
      colors: _getColorsListFrom(leftRight: const Color(0xFFFF6347) /* tomato */, upDown: const Color(0xFFB22222) /* firebrick */)
      ),
      (tileName: "Overwhelmed",
      emoji: "😓",
      colors: _getColorsListFrom(leftRight: const Color(0xFFFFA07A) /* light salmon */, upDown: const Color(0xFFCD5C5C) /* indian red */)
      ),
    ];


    var count = (emotionsAndSyms.length / 2).ceil();
    var isOddLen = emotionsAndSyms.length % 2 == 1;


    return Scaffold(
      backgroundColor: const Color(0xFF5CFFC6),


      /// ***** App Bar ***** ///
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBarWrapper(
          key: Key('EmotionsKey'),

          title: "Emotion Logging",
          color: Color(0xFF000000),
        ),
      ),
      body:
      Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int offset) {
              var index = offset * 2;


              var tileInfo = emotionsAndSyms[index];


              BaseTile firstTile = _getTile(tileInfo, width);


              // Check if we are at the end index, ensure we have another element to add.
              if (offset == (count - 1) && isOddLen) {
                return TileRow(
                    first: firstTile,
                    second: TileFactory.getBlankFromTile(firstTile));
              }


              tileInfo = emotionsAndSyms[index + 1];


              BaseTile secondTile = _getTile(tileInfo, width);




              return TileRow(first: firstTile, second: secondTile);
            },
          ),
        ),
      ),
    );
  }
}


