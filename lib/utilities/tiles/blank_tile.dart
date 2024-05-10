import 'package:coa_progress_tracking_app/utilities/tiles/custom_tile.dart';
import 'package:flutter/material.dart';

final class BlankTile extends CustomTile {

  BlankTile({
    super.key,
    required double width,
    required double height,
  }) :
        super(
        handler: null,
        nextPage: null,

        tileName: "",
        tileIcon: null,
        noText: true,
        tileColor: Colors.transparent,
        tileTextColor: Colors.transparent,
        isSpeechEnabled: false,

        // Container
        containerWidthMultiplier: null,
        containerHeightMultiplier: null,
        containerWidth: null,
        containerHeight: null,
        isSquare: width == height,

        // Text
        tileTextStyle: null,
        tileTextSize: null,
        customTextItem: null,

        // Icon
        iconSize: null,
        imageIcon: null,
        iconButton: null,
        customIcon: null,
        assetImage: null,

        // Children
        customChildren: null,
        prependDefaultChildren: null,
        appendDefaultChildren: null,
        customViewInsteadOfIcon: null,
      );
}