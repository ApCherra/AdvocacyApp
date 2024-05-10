import 'package:coa_progress_tracking_app/utilities/tiles/base_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/blank_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/custom_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/emotion_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/nav_tile.dart';
import 'package:coa_progress_tracking_app/utilities/tiles/speech_tile.dart';

import 'package:flutter/material.dart';

final class TileFactory {

  static BaseTile getTile({
    // Text info
    required String name,
    String? speechString,
    Color color = Colors.black,
    bool noText = false,
    Color textColor = const Color(0xFFEADDC8),
    TextStyle? textStyle,
    double? textSize,
    Text? textItem,

    /// Emoji-tile specific
    String? emoji,
    List<Color>? gradientColors,

    // Icon options
    IconData? icon,
    Icon? customIcon,
    ImageIcon? imageIcon,
    IconButton? iconButton,
    AssetImage? assetImage,
    double? iconSize,

    // Custom layout specifications
    EdgeInsetsGeometry paddingInsets = const EdgeInsets.all(15.0),
    double borderRadius = 20,
    MainAxisAlignment columnAlignment = MainAxisAlignment.center,

    // Custom Children
    bool? prependDefaultChildren,
    bool? appendDefaultChildren,
    List<Widget>? customChildren,
    StatelessWidget? customViewInsteadOfIcon,

    // Container-specific fields
    double? containerWidthMultiplier,
    double? containerHeightMultiplier,
    double? containerWidth,
    double? containerHeight,
    bool isSquare = false,

    StatefulWidget? nextPage,
    bool isSpeechEnabled = true,
    Function? handler
  }) {

    if (gradientColors != null || emoji != null) {
      return EmotionTile(
        handler: handler,
        emoji: emoji ?? "",
        gradientColors: gradientColors ?? [],

        // super
        tileName: name,
        tileIcon: icon,
        noText: noText,
        tileColor: color,
        tileTextColor: textColor,
        isSpeechEnabled: isSpeechEnabled,

        // General Formatting
        paddingInsets: paddingInsets,
        borderRadius: borderRadius,
        columnAlignment: columnAlignment,

        // Container
        containerWidthMultiplier: containerWidthMultiplier,
        containerHeightMultiplier: containerHeightMultiplier,
        containerWidth: containerWidth,
        containerHeight: containerHeight,
        isSquare: isSquare,

        // Text
        tileTextStyle: textStyle,
        tileTextSize: textSize,
        customTextItem: textItem,

        // Icon
        iconSize: iconSize,
        imageIcon: imageIcon,
        iconButton: iconButton,
        customIcon: customIcon,
        assetImage: assetImage,

        // Children
        customChildren: customChildren,
        prependDefaultChildren: prependDefaultChildren,
        appendDefaultChildren: appendDefaultChildren,
        customViewInsteadOfIcon: customViewInsteadOfIcon,
      );
    } else if (handler != null || speechString != null) {
      return CustomTile(
        handler: handler,
        speechString: speechString,
        nextPage: nextPage,

        // super
        tileName: name,
        tileIcon: icon,
        noText: noText,
        tileColor: color,
        tileTextColor: textColor,
        isSpeechEnabled: isSpeechEnabled,

        // General Formatting
        paddingInsets: paddingInsets,
        borderRadius: borderRadius,
        columnAlignment: columnAlignment,

        // Container
        containerWidthMultiplier: containerWidthMultiplier,
        containerHeightMultiplier: containerHeightMultiplier,
        containerWidth: containerWidth,
        containerHeight: containerHeight,
        isSquare: isSquare,

        // Text
        tileTextStyle: textStyle,
        tileTextSize: textSize,
        customTextItem: textItem,

        // Icon
        iconSize: iconSize,
        imageIcon: imageIcon,
        iconButton: iconButton,
        customIcon: customIcon,
        assetImage: assetImage,

        // Children
        customChildren: customChildren,
        prependDefaultChildren: prependDefaultChildren,
        appendDefaultChildren: appendDefaultChildren,
        customViewInsteadOfIcon: customViewInsteadOfIcon,
      );
    } else if (nextPage != null) {
      return NavTile(
        nextPage: nextPage,

        // super
        tileName: name,
        tileIcon: icon,
        noText: noText,
        tileColor: color,
        tileTextColor: textColor,
        isSpeechEnabled: isSpeechEnabled,

        // General Formatting
        paddingInsets: paddingInsets,
        borderRadius: borderRadius,
        columnAlignment: columnAlignment,

        // Container
        containerWidthMultiplier: containerWidthMultiplier,
        containerHeightMultiplier: containerHeightMultiplier,
        containerWidth: containerWidth,
        containerHeight: containerHeight,
        isSquare: isSquare,

        // Text
        tileTextStyle: textStyle,
        tileTextSize: textSize,
        customTextItem: textItem,

        // Icon
        iconSize: iconSize,
        imageIcon: imageIcon,
        iconButton: iconButton,
        customIcon: customIcon,
        assetImage: assetImage,

        // Children
        customChildren: customChildren,
        prependDefaultChildren: prependDefaultChildren,
        appendDefaultChildren: appendDefaultChildren,
        customViewInsteadOfIcon: customViewInsteadOfIcon,
      );
    } else {
      return SpeechTile(
        // super
        tileName: name,
        tileIcon: icon,
        noText: noText,
        tileColor: color,
        tileTextColor: textColor,
        isSpeechEnabled: isSpeechEnabled,

        // General Formatting
        paddingInsets: paddingInsets,
        borderRadius: borderRadius,
        columnAlignment: columnAlignment,

        // Container
        containerWidthMultiplier: containerWidthMultiplier,
        containerHeightMultiplier: containerHeightMultiplier,
        containerWidth: containerWidth,
        containerHeight: containerHeight,
        isSquare: isSquare,

        // Text
        tileTextStyle: textStyle,
        tileTextSize: textSize,
        customTextItem: textItem,

        // Icon
        iconSize: iconSize,
        imageIcon: imageIcon,
        iconButton: iconButton,
        customIcon: customIcon,
        assetImage: assetImage,

        // Children
        customChildren: customChildren,
        prependDefaultChildren: prependDefaultChildren,
        appendDefaultChildren: appendDefaultChildren,
        customViewInsteadOfIcon: customViewInsteadOfIcon,
      );
    }
  }

  static getBlankFromTile(BaseTile from) {
    return BlankTile(
      width: from.containerWidth ?? 0,
      height: from.containerHeight ?? 0,
    );
  }

  static getBlankFromSize(Size size) {
    return BlankTile(
      width: size.width,
      height: size.height,
    );
  }

  static getBlankExplicit(double width, double? height) {
    return BlankTile(
      width: width,
      height: height ?? width,
    );
  }

}