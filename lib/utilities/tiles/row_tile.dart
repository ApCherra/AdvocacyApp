import 'package:coa_progress_tracking_app/utilities/tiles/factory_tile.dart';
import "package:flutter/material.dart";

import 'package:coa_progress_tracking_app/utilities/tiles/base_tile.dart';

/// Layout a 1x2 row item.
class TileRow extends StatelessWidget {
  /// Tile to display on the left side
  final BaseTile? first;
  /// Tile to display on the right side
  final BaseTile? second;
  /// A custom amount of items in children
  final List<BaseTile>? children;

  /// Boolean to edit all children and set the space
  final bool giveChildrenEqualSize;

  final int? explicitSize;

  /// Initializer
  const TileRow({
    super.key,
    this.first,
    this.second,
    this.children,
    this.giveChildrenEqualSize = true,
    this.explicitSize,
  });

  @override
  Widget build(BuildContext context) {

    var row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _getChildren(),
    );

    return row;

  }

  List<Widget> _getChildren() {
    List<BaseTile> widgets = children ?? [];

    if (giveChildrenEqualSize && (widgets.isNotEmpty || explicitSize != null)) {
      var multiplierDivisor = explicitSize ?? (widgets.length);
      var newMultiplier = 0.7 / multiplierDivisor;
      for (var widget in widgets) {
        widget.setWidthMultiplier(newMultiplier);
        widget.setHeightMultiplier(newMultiplier);
      }
    }
    // else

    if (first != null) {
      widgets.add(first!);
    }

    if (second != null) {
      widgets.add(second!);
    }

    if (explicitSize != null) {
      var numberOfWidgetsToAdd = explicitSize! - widgets.length;

      for (var num = 0; num < numberOfWidgetsToAdd; ++num) {
        widgets.add(TileFactory.getBlankFromTile(widgets.first));
      }
    }

    return widgets;

  }

}
