import 'package:coa_progress_tracking_app/utilities/tiles/custom_tile.dart';
import 'package:flutter/material.dart';

final class EmotionTile extends CustomTile {
      final String emoji;
      final List<Color> gradientColors;

      EmotionTile({
            super.key,

            // EmotionTile-specific
            required this.emoji,
            required this.gradientColors,

            // CustomTile-specific
            super.handler,
            super.speechString,
            super.nextPage,

            // super
            required super.tileName,
            required super.tileIcon,
            required super.tileColor,
            required super.noText,
            required super.tileTextColor,
            super.isSpeechEnabled = true,

            // General Formatting
            super.paddingInsets,
            super.borderRadius,
            super.columnAlignment,

            // Container
            super.containerWidthMultiplier,
            super.containerHeightMultiplier,
            super.containerWidth,
            super.containerHeight,
            super.isSquare,

            // Text
            super.tileTextStyle, // Disable
            super.tileTextSize, // Disable
            super.customTextItem, // Disable

            // Icon
            super.iconSize, // Disable
            super.imageIcon, // Disable
            super.iconButton, // Disable
            super.customIcon, // Disable
            super.assetImage, // Disable

            // Children
            super.customChildren, // disable
            super.prependDefaultChildren, // disable
            super.appendDefaultChildren, // disable
            super.customViewInsteadOfIcon, // disable
      }) : super();

      @override
      Widget build(BuildContext context) {
            Size size = MediaQuery.of(context).size;
            return Padding(
                  padding: paddingInsets,
                  child: GestureDetector(
                        onTap: () {
                              onTapHandler(context);
                        },
                        child: ClipRRect(
                              borderRadius: BorderRadius.circular(borderRadius),
                              child: Container(
                                    height: getContainerHeight(size),
                                    width: getContainerWidth(size),
                                    color: tileColor,
                                    child: Column(
                                          mainAxisAlignment:
                                          columnAlignment,
                                          children:
                                          [
                                                Container(
                                                    width: getContainerHeight(size),
                                                    height: getContainerWidth(size),
                                                    decoration: BoxDecoration(gradient: SweepGradient(colors: gradientColors)),
                                                    child: Column(
                                                          children: [
                                                                Text(
                                                                    emoji,
                                                                    style: TextStyle(
                                                                        fontSize: getContainerHeight(size) * 0.5,
                                                                        shadows: const <Shadow>[Shadow(
                                                                              blurRadius: 10.0,
                                                                              color: Colors.black,
                                                                        )]
                                                                    )
                                                                ),
                                                                getText(),
                                                          ],
                                                    )
                                                )
                                          ],
                                    ),
                              ),
                        ),
                  ),
            );
      }
}