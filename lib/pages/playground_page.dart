import 'package:coa_progress_tracking_app/utilities/tiles/factory_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/tile_data_raw.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/custom_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/row_tile.dart';
import 'package:flutter/material.dart';
import 'package:coa_progress_tracking_app/utilities/app_bar_wrapper.dart';
import 'package:coa_progress_tracking_app/utilities/reward_animator.dart';
import 'package:audioplayers/audioplayers.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  final tileColor = const Color(0xFF7C0D0E);
  final tileTextColor = const Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    //_rewardAnimator = RewardAnimator();
  }

  @override
  Widget build(BuildContext context) {
    final RewardAnimator rewardAnimator = RewardAnimator();

    return Scaffold(
      backgroundColor: Colors.transparent,

      /// ***** App Bar ***** ///
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBarWrapper(
          key: Key('CelebrationsKey'),

            title: "Celebrations",
            color: Color(0xFF7C0D0E)
        ),
      ),
      body:
      Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: SweepGradient(
                  colors: [
                    Color(0xFFFFFFFF), //white
                    Color(0xFF7C0D0E), // red
                    Color(0xFFFFFFFF), //white
                    // Color(0xFFFFFFFF), //white
                    // Color(0xFFFFFFFF), //white
                    // Color(0xFF7C0D0E), // red
                    // Color(0xFF7C0D0E), // red
                    // Color(0xFFFFFFFF), //white
                  ],
                  tileMode: TileMode.clamp
              )
          ),
          child: Column(
            children: [
              rewardAnimator,
              TileRow(first:
              TileFactory.getTile(
                name: "Confetti!",
                icon: Icons.celebration,
                color: tileColor,
                textColor: tileTextColor,
                handler: rewardAnimator.doConfetti,
                isSquare: true,
              )
                  , second:
                  TileFactory.getTile(
                    name: "Go Cougs!",
                    icon: Icons.sports_football,
                    color: tileColor,
                    textColor: tileTextColor,
                    isSpeechEnabled: false,
                    isSquare: true,
                    handler: () {
                      final AudioPlayer player = AudioPlayer();
                      player.play(AssetSource("Go_Cougs.m4a"));
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

/*Future<ui.Image> loadUiImage(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<ui.Image> loadImage(File file) async {
    final data = await file.readAsBytes();
    return await decodeImageFromList(data);
  }*/
}
