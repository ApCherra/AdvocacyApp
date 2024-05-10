import 'package:flutter/material.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/factory_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/row_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/base_tile.dart';
import 'package:coa_progress_tracking_app/utilities/app_bar_wrapper.dart';

class BodyPartsPage extends StatefulWidget {
  const BodyPartsPage({super.key});

  @override
  State<BodyPartsPage> createState() => _BodyPartsPageState();
}

class _BodyPartsPageState extends State<BodyPartsPage> {
  final tileColor = const Color(0xFFA0DAA9); // Soft green color for body parts
  final tileTextColor = const Color(0xFFFFFFFF); // White color for text
  
  AssetImage _getAssetForBodyPart(String part) {
    return AssetImage("assets/bodyparts/$part.png");
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> bodyPartsItems = [
      TileFactory.getTile(name: "Head", icon: Icons.face, color: tileColor, textColor: tileTextColor, isSquare: true),
      TileFactory.getTile(name: "Hands", icon: Icons.pan_tool, color: tileColor, textColor: tileTextColor, isSquare: true),
      TileFactory.getTile(name: "Feet", assetImage: _getAssetForBodyPart("foot"), color: const Color(0xFFA0DAA9), textColor: tileTextColor, isSquare: true),
      TileFactory.getTile(name: "Stomach", assetImage: _getAssetForBodyPart("stomach"), color: tileColor, textColor: tileTextColor, isSquare: true),
      TileFactory.getTile(name: "Arms", assetImage: _getAssetForBodyPart("arms"), color: tileColor, textColor: tileTextColor, isSquare: true),
      TileFactory.getTile(name: "Legs", assetImage: _getAssetForBodyPart("legs"), color: tileColor, textColor: tileTextColor, isSquare: true),
      TileFactory.getTile(name: "Eyes", icon: Icons.visibility, color: tileColor, textColor: tileTextColor, isSquare: true),
      TileFactory.getTile(name: "Chin", assetImage: _getAssetForBodyPart("chin"), color: tileColor, textColor: tileTextColor, isSquare: true),
      TileFactory.getTile(name: "Nose", assetImage: _getAssetForBodyPart("nose"), color: tileColor, textColor: tileTextColor, isSquare: true),
      TileFactory.getTile(name: "Ears", icon: Icons.hearing, color: tileColor, textColor: tileTextColor, isSquare: true),
      // Add more body part items here...
    ];

    int count = (bodyPartsItems.length / 2).ceil();
    bool isOddLen = bodyPartsItems.length % 2 == 1;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      /// ***** App Bar ***** ///
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBarWrapper(
          title: "Body Parts",
          color: Color(0xFFA0DAA9), // Color for the app bar that matches the tileColor
        ),
      ),

      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF5F5DC), // beige
                    Color(0xFFFFF8E7), // ivory
                  ],
                  tileMode: TileMode.clamp
              )
          ),
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int offset) {
              int index = offset * 2;
              // Cast the Widget to BaseTile if you're sure that's what getTile returns.
              BaseTile firstTile = bodyPartsItems[index] as BaseTile;

              if (offset == (count - 1) && isOddLen) {
                // Only one tile in the last row if an odd number of items
                return TileRow(first: firstTile, explicitSize: 2);
              }

              // Cast the Widget to BaseTile here as well.
              BaseTile secondTile = bodyPartsItems[index + 1] as BaseTile;
              return TileRow(first: firstTile, second: secondTile);
            },
          ),

        ),
      ),
    );
  }
}
