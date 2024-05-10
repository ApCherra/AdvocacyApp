import 'package:coa_progress_tracking_app/utilities/app_bar_wrapper.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/factory_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/row_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BathroomPage extends StatefulWidget {
  // Constructor with an optional key parameter.
  const BathroomPage({Key? key}) : super(key: key);

  // createState is overridden to create the mutable state for this widget.
  @override
  State<BathroomPage> createState() => _BathroomPageState();
}

// The state class for BathroomPage which holds the state and logic for the widget.
class _BathroomPageState extends State<BathroomPage> {
  // Creating an instance of FlutterTts to handle text-to-speech operations.
  final FlutterTts tts = FlutterTts();

  // Define the text Color.
  final textColor = const Color(0xFFFFFFFF);

  // Colors for indicator.
  final greenColor = const Color(0xFF4A9700);
  final yellowColor = const Color(0xFFEFA000);
  final redColor = const Color(0xFF830000);

  // An integer to track the urgency level of the bathroom need.
  int _urgencyLevel = 1; // Starts with 'Average' as the default urgency level.

  // A method to convert text to speech.
  void textToSpeech(String text) async {
    await tts.setLanguage("en-US"); // Setting the language to US English.
    await tts.setVolume(1); // Setting the volume to maximum.
    await tts.setSpeechRate(0.4); // Setting a moderate speech rate.
    await tts.speak(text); // Instructing the tts engine to speak the text.
  }

  // Defines the urgencyText method which returns a string based on the urgency level.
  String urgencyText(int level) {
    switch (level) {
      case 1:
        return "A little bit"; // Represents low urgency.
      case 2:
        return "Average"; // Represents medium urgency.
      case 3:
        return "Emergency"; // Represents high urgency.
      default:
        return "Unknown"; // Fallback for an undefined urgency level.
    }
  }

  // Returns an icon that visually represents the urgency level.
  IconData getUrgencyIcon(int level) {
    switch (level) {
      case 1:
        return Icons.hourglass_bottom; // Represents 'can wait'.
      case 2:
        return Icons.directions_walk; // Represents 'soon'.
      case 3:
        return Icons.directions_run; // Represents 'right now'.
      default:
        return Icons.error; // Fallback icon for an undefined urgency level.
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBarWrapper(
          key: Key('BathroomKey'),

            title: "Bathroom",
            color: Color(0xFF4FC3F7) // Light blue
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
                    Color(0xFFFFFFFF), // white at the top
                    Color(0xFFB0E0E6), // Powder blue at the bottom
                  ],
                  tileMode: TileMode.clamp
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TileFactory.getTile(
                name: "Potty",
                icon: Icons.wc,
                speechString: "I need to go potty",
                color: const Color(0xFF4FC3F7), // Dark navy blue
                textColor: textColor,
                isSquare: true,
              ),
              const SizedBox(height: 40), // Adds some spacing
              Text(
                "Do you need to go potty now or can you wait?",
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30), // Increase this value to add more space


              TileRow(first: TileFactory.getTile(
                  name: urgencyText(1),
                  icon: getUrgencyIcon(1),
                  color: _urgencyLevel == 1 ? greenColor : Colors.lightBlueAccent,
                  textColor: _urgencyLevel == 1 ? textColor : Colors.white,
                  iconSize: 60,
                  isSquare: false,
                  borderRadius: 0,
                  containerHeight: 125,
                  containerWidth: 250,
                  handler: () {
                    setState(() {
                      _urgencyLevel = 1;
                    });
                  }
              ),
                second:
                TileFactory.getTile(
                    name: urgencyText(3),
                    icon: getUrgencyIcon(3),
                    color: _urgencyLevel == 3 ? redColor : Colors.lightBlueAccent,
                    textColor: _urgencyLevel == 3 ? textColor : Colors.white,
                    iconSize: 60,
                    isSquare: false,
                    borderRadius: 0,
                    containerHeight: 125,
                    containerWidth: 250,
                    handler: () {
                      setState(() {
                        _urgencyLevel = 3;
                      });
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}