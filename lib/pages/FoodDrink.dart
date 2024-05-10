import 'package:coa_progress_tracking_app/utilities/app_bar_wrapper.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/base_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/factory_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/row_tile.dart';
import 'package:flutter/material.dart';

class FoodDrinkPage extends StatefulWidget {
  // Constructor with an optional key parameter.
  const FoodDrinkPage({Key? key}) : super(key: key);

  // createState is overridden to create the mutable state for this widget.
  @override
  State<FoodDrinkPage> createState() => _FoodDrinkPageState();
}

// The state class for FoodDrinkPage which holds the state and logic for the widget.
class _FoodDrinkPageState extends State<FoodDrinkPage> {

  final textColor = const Color(0xFFEADDC8); // beige

  final tileColor = const Color(0xFF4FC3F7); // Royal purple

  ImageIcon _getBurgerIcon() {
    return const ImageIcon(
      AssetImage("assets/burger.png"),
      color: Color(0xFFE6D7CB),
      size: 100,
    );
  }

  Widget _getBurgerIconWithPadding() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24), // Adjust the padding as needed
      child: _getBurgerIcon(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final List foodItems =
    [
      // Old food color: const Color(0xFF482218) (brown) //
      TileFactory.getTile(name: "Food" , imageIcon: _getBurgerIcon(), color: const Color(0xFF482218), textColor: textColor, isSquare: true),
      TileFactory.getTile(name: "Drink", icon: Icons.local_drink, color: const Color(0xFF4FC3F7), textColor: const Color(0xFFFFFFFF), isSquare: true),
    ];
    var count = (foodItems.length / 2).ceil();
    var isOddLen = foodItems.length % 2 == 1;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBarWrapper(
            key: Key('FDKey'),

            title: "Food & Drink",
            color: Color(0xFF482218)
        ),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: SweepGradient(
                  colors: [
                    Color(0xFFCB997E),
                    Color(0xFFCB997E),// Terracotta
                    //Color(0xFF6B705C), // Olive Green
                    //Color(0xFFDDA15E) // Mustard Yellow

                  ],
                  tileMode: TileMode.clamp
              )
          ),
          /// Uncomment the follow section and comment the other child param
          /// for the buttons to be centered.
          // child: Center(
          //   child: TileRow(first: foodItems[0], second: foodItems[1]),
          // ),
            child: Center (
                child: TileRow(first: foodItems[0], second: foodItems[1])
            )
        ),
      ),
    );
  }
}

