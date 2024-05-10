import "package:flutter/material.dart";

import 'package:coa_progress_tracking_app/utilities/tiles/base_tile.dart';

final class NavTile extends BaseTile {
  /// Pass along parameters to base class
  NavTile({
    super.key,
    // NavTile Specific
    required super.nextPage,

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
