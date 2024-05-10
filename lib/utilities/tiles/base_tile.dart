import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

// BaseTile class is not intended to be initialized directly.
abstract class BaseTile extends StatelessWidget {
  // Tile-background
  /// Name to display on tile
  final String tileName;
  /// Color of tile background
  final Color tileColor;
  /// Indicate if there should be an icon-only tile
  final bool noText;

  // Tile Text
  /// Color of tile text
  final Color? tileTextColor;
  /// Give a specific text style (Optional)
  final TextStyle? tileTextStyle;
  /// Specify a text size
  final double? tileTextSize;
  /// Define a custom text item, ignoring all passed params
  final Text? customTextItem;

  // Icon options
  /// Icon to display on tile
  final IconData? tileIcon;
  /// Use a customIcon
  final Icon? customIcon;
  /// Use an image icon
  final ImageIcon? imageIcon;
  /// Use an iconButton
  final IconButton? iconButton;
  /// Use an AssetImage
  final AssetImage? assetImage;

  // Default icon customization
  /// Use a specific iconSize
  final double? iconSize;

  // Custom layout specifications
  /// The padding insets to use for padding on layout
  final EdgeInsetsGeometry paddingInsets;
  /// The border radius to use for the clipping rect
  final double borderRadius;
  /// Customize the column's Alignment
  final MainAxisAlignment columnAlignment;

  // Custom Children
  final bool? prependDefaultChildren;
  final bool? appendDefaultChildren;
  /// Customize children in tile
  final List<Widget>? customChildren;
  /// Use a custom icon/view instead of the default icon.
  StatelessWidget? customViewInsteadOfIcon;

  // Container-specific fields
  /// Container's width multiplier
  double? containerWidthMultiplier;
  double? containerHeightMultiplier;
  double? containerWidth;
  double? containerHeight;
  final bool isSquare;

  // Attributes
  /// Enables or disables speech
  final bool isSpeechEnabled;
  /// Next page to display
  final StatefulWidget? nextPage;

  /// Provide the string to speak, this is overridden in CustomTile.
  String getSpeechString() {
    return tileName;
  }

  /// Return the audio path based on this tile's name.
  String? getAudioAssetPath() {
    // This should be changed to read from settings to either use a male or female voice.
    // Temporarily set to true for use with female voice.
    var isFemale = true;

    var fileName = getSpeechString().replaceAll(RegExp("[^a-zA-Z0-9]"), "_").toLowerCase();

    if (isFemale) { // Return path to female voice
      return "voices/female/$fileName.mp3";
    } else { // Return path to male voice
      return "voices/male/$fileName.mp3";
    }
  }

  /// Speak the tile's name using a Human voice
  Future<bool> speakHuman() async {
    var success = false;
    var assetPath = getAudioAssetPath();

    // Check if the asset exists, then play.
    try {
      // Ensure the asset exists.
      await rootBundle.load("assets/$assetPath");

      // Play the audio file, assetPath is unsafely unwrapped since it is known to exist.
      final AudioPlayer player = AudioPlayer(playerId: "AP-Tile-$tileName");
      await player.play(AssetSource(assetPath!));
      success = true;
    } catch (e) {
      // Set success to false if we could not locate the file.
      success = false;
    }

    return success;
  }

  /// Speak the tile's name
  void speak() async {
    var didSpeakHuman = await speakHuman();

    // Attempt to speak with human voice, fall back to TTS.
    if (didSpeakHuman == false) {
      final FlutterTts tts = FlutterTts();
      await tts.setLanguage("en-US");
      await tts.setVolume(1);
      await tts.setSpeechRate(0.4);
      await tts.speak(tileName);
    }
  }

  /// Handle tap event handler. This is called below.
  void onTapHandler(BuildContext context) {
    if (isSpeechEnabled) {
      speak();
    }

    if (nextPage != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return nextPage!;
          }));
    }
  }

  void setWidthMultiplier(double newMultiplier) {
    containerWidthMultiplier = newMultiplier;
  }

  void setHeightMultiplier(double newMultiplier) {
    containerHeightMultiplier = newMultiplier;
  }

  /// Get the container height. Use the specified containerHeight, if any.
  /// If no explicit height is given, default to view size * multiplier (default 0.35)
  /// Param: size - size to get relative height
  @protected
  double getContainerHeight(Size size) {
    if (isSquare) {
      return min(_calculateHeight(size), _calculateWidth(size));
    } else {
      return _calculateHeight(size);
    }
  }

  /// Actual calculation of height
  double _calculateHeight(Size size) {
    if (containerHeight == null) {
      var multiplier = containerHeightMultiplier ?? 0.35;
      containerHeight = size.height * multiplier;
    }

    return containerHeight!;
  }

  /// Get the container width. Use the specified containerWidth, if any.
  /// If no explicit width is given, default to view size * multiplier (default 0.35)
  /// Param: size - size to get relative width
  @protected
  double getContainerWidth(Size size) {
    if (isSquare) {
      return min(_calculateWidth(size), _calculateHeight(size));
    } else {
      return _calculateWidth(size);
    }
  }

  /// Actual calculation of width
  double _calculateWidth(Size size) {
    if (containerWidth == null) {
      var multiplier = containerWidthMultiplier ?? 0.35;
      containerWidth = size.width * multiplier;
    }

    return containerWidth!;
  }

  /// Get the icon to display. This can by any stateless widget. Only
  /// one item will be returned.
  /// Priority:
  StatelessWidget _getIcon(size) {
    var defaultIconSize = iconSize ?? size.width * 0.2;

    /// Use a custom icon (such as emoji text box) instead of the
    /// default icon.
    if (customViewInsteadOfIcon != null) {
      if (customViewInsteadOfIcon is Text) {
        debugPrint("Size of custom Text: ${ (customViewInsteadOfIcon as Text).style?.fontSize ?? 0 }. TEXT='$tileName'");
        return _getTextFromView(customViewInsteadOfIcon as Text, defaultIconSize);
      }

      if (customViewInsteadOfIcon is Container) {
        debugPrint("Size of custom Container: ${ (customViewInsteadOfIcon as Container).constraints }. TEXT='$tileName'");
        return _getContainerFromView(customViewInsteadOfIcon as Container, defaultIconSize);
      }

      return customViewInsteadOfIcon!;
    }

    /// Use an ImageIcon object
    if (imageIcon != null) {
      debugPrint("Size of icon: ${ imageIcon!.size }. TEXT='$tileName'");
      return imageIcon!;
    }

    /// Use a ButtonIcon object
    if (iconButton != null) {
      debugPrint("Size of icon button: ${ imageIcon!.size }. TEXT='$tileName'");
      return iconButton!;
    }

    /// Use an AssetImage
    if (assetImage != null) {
      debugPrint("Size of ${assetImage!.assetName}: $defaultIconSize. TEXT='$tileName'");
      return ImageIcon(
        assetImage!,
        color: tileTextColor,
        size: defaultIconSize,
      );
    }

    debugPrint("Size of custom icon: ${ customIcon != null ? customIcon!.size : defaultIconSize }. TEXT='$tileName'");

    /// Default icon:
    return customIcon ??
        Icon(
      tileIcon,
      color: tileTextColor,
      size: defaultIconSize,
    );
  }

  Container _getContainerFromView(Container containerRef, double size) {

    if (containerRef.child is Column) {
      return Container(
        alignment: containerRef.alignment,
        padding: containerRef.padding,
        color: containerRef.color,
        decoration: containerRef.decoration,
        foregroundDecoration: containerRef.foregroundDecoration,
        width: size,
        height: size,
        margin: containerRef.margin,
        transform: containerRef.transform,
        transformAlignment: containerRef.transformAlignment,
        clipBehavior: containerRef.clipBehavior,
        child: containerRef.child,
      );
    }

    return Container(
      alignment: containerRef.alignment,
      padding: containerRef.padding,
      color: containerRef.color,
      decoration: containerRef.decoration,
      foregroundDecoration: containerRef.foregroundDecoration,
      width: size,
      height: size,
      margin: containerRef.margin,
      transform: containerRef.transform,
      transformAlignment: containerRef.transformAlignment,
      clipBehavior: containerRef.clipBehavior,
      child: containerRef.child,
    );
  }

  Text _getTextFromView(Text txtRef, double size) {
    /// Warning: You may loose formatting here!

    /// Retain most old settings, but set icon size.
    return Text(txtRef.data ?? "",
        style: TextStyle(
          color: txtRef.style?.color,
          backgroundColor: txtRef.style?.backgroundColor,
          fontSize: size,
          fontWeight: txtRef.style?.fontWeight,
          fontStyle: txtRef.style?.fontStyle,
          height: txtRef.style?.height,
          foreground: txtRef.style?.foreground,
          background: txtRef.style?.background,
          shadows: txtRef.style?.shadows,
          decoration: txtRef.style?.decoration,
          decorationColor: txtRef.style?.decorationColor,
          decorationStyle: txtRef.style?.decorationStyle,
          decorationThickness: txtRef.style?.decorationThickness,
          fontFamily: txtRef.style?.fontFamily,
        )
    );
  }

  /// Get the text object to display. Use the custom text item when
  /// available.
  @protected
  Text getText() {
    return customTextItem ??
    Text(
      tileName,
      style: tileTextStyle ??
        TextStyle(
            color: tileTextColor,
            fontSize: tileTextSize ?? 32,
            fontWeight: FontWeight.bold,)
    );
  }

  /// Get the children object. Prepend or append as needed. If customChildren
  /// is undefined, prependDefaultChildren and appendDefaultChildren are ignored.
  List<Widget> _getChildren(size) {
    List<Widget> children = customChildren ??
        ((noText) ?
          [ _getIcon(size) /* ICON ONLY */ ] :
          [ _getIcon(size), /* ICON AND TEXT */
            getText(),
          ]
        );

    if (customChildren == null) {
      return children;
    }

    if (prependDefaultChildren ?? false) {
      children = [
        ...children,
        _getIcon(size),
        getText(),
      ];
    }

    if (appendDefaultChildren ?? false) {
      return [
        _getIcon(size),
        getText(),
        ...children,
      ];
    }

    return children;
  }

  /// Initializer
  BaseTile({
    super.key,
    required this.tileName,
    required this.tileIcon,
    required this.tileColor,
    required this.noText,
    required this.tileTextColor,
    this.isSpeechEnabled = true,
    this.nextPage,
    this.paddingInsets = const EdgeInsets.all(15.0),
    this.borderRadius = 20,
    this.containerWidthMultiplier = 0.35,
    this.containerHeightMultiplier = 0.35,
    this.columnAlignment = MainAxisAlignment.center,
    this.containerWidth,
    this.containerHeight,
    this.isSquare = false,
    this.tileTextStyle,
    this.tileTextSize,
    this.customTextItem,
    this.iconSize,
    this.imageIcon,
    this.iconButton,
    this.customIcon,
    this.assetImage,
    this.customChildren,
    this.prependDefaultChildren,
    this.appendDefaultChildren,
    this.customViewInsteadOfIcon,
  });

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
              children: _getChildren(size),
            ),
          ),
        ),
      ),
    );
  }
}