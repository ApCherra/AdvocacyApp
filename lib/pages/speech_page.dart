import 'package:coa_progress_tracking_app/utilities/tiles/factory_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/row_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/base_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/tile_data_raw.dart';
import 'package:coa_progress_tracking_app/utilities/app_bar_wrapper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechPage extends StatefulWidget {
  const SpeechPage({super.key});

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  final tileColor = const Color(0xFF5D514A);
  final tileTextColor = const Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {

    final List speechItems =
    [
      // Give yes a green color.
      TileFactory.getTile(name: "Yes", icon: Icons.check, color: tileColor, textColor: tileTextColor, isSquare: true),
      // Give no a green color.
      TileFactory.getTile(name: "No", icon: Icons.cancel, color: tileColor, textColor: tileTextColor, isSquare: true),

      TileFactory.getTile(name: "Please", icon: Icons.emoji_emotions, color: tileColor, textColor: tileTextColor, isSquare: true),
      TileFactory.getTile(name: "Thank you", icon: Icons.handshake, color: tileColor, textColor: tileTextColor, isSquare: true),

      TileFactory.getTile(name: "Help", icon: Icons.waving_hand, color: tileColor, textColor: tileTextColor, isSquare: true),
    ];

    var count = (speechItems.length / 2).ceil();
    var isOddLen = speechItems.length % 2 == 1;

    return Scaffold(
      backgroundColor:  Color(0xFFFFFFFF),

      /// ***** App Bar ***** ///
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBarWrapper(
          key: Key('SpeechKey'),

          title: "Speech",
          color: Color(0xFF5D514A),
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
                    Color(0xFFF5F5DC), // beige
                    Color(0xFFFFF8E7),// ivory
                  ],
                  tileMode: TileMode.clamp
              )
          ),
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int offset) {

            var index = offset * 2;

            BaseTile firstTile = speechItems[index];

            // Check if we are at the end index, ensure we have another element to add.
            if (offset == (count - 1) && isOddLen) {
            return TileRow(first: firstTile, explicitSize: 2);
            }

            BaseTile secondTile = speechItems[index + 1];


            return TileRow(first: firstTile, second: secondTile);
            },
          ),
        ),
      ),
    );
  }
}