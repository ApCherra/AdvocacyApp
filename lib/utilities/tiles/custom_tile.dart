import "package:flutter/material.dart";

import 'package:coa_progress_tracking_app/utilities/tiles/base_tile.dart';

class CustomTile extends BaseTile {
  /// Tile's handler for on-tap event
  final Function? handler;

  /// Speech String
  final String? speechString;

  /// Handle tap event handler. Overridden to call handler.
  @override
  void onTapHandler(BuildContext context) {
    super.onTapHandler(context);
    if (handler != null) {
      handler!();
    }
  }

  /// Override getSpeechString to provide speechString if it differs from the
  /// tile's text.
  @override
  String getSpeechString() {
    return speechString ?? tileName;
  }

  /// Pass along parameters to base class
  CustomTile({
    super.key,

    // CustomTile-specific
    this.handler,
    this.speechString,
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
