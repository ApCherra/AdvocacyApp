import 'package:coa_progress_tracking_app/utilities/tiles/base_tile.dart';

/// Speech Tile. Speaks the tile's name only.
final class SpeechTile extends BaseTile {

  SpeechTile({
    super.key,
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
    super.tileTextStyle,
    super.tileTextSize,
    super.customTextItem,

    // Icon
    super.iconSize,
    super.imageIcon,
    super.iconButton,
    super.customIcon,
    super.assetImage,

    // Children
    super.customChildren,
    super.prependDefaultChildren,
    super.appendDefaultChildren,
    super.customViewInsteadOfIcon,
  }) : super();

}
