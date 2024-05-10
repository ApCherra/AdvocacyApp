import 'package:flutter/cupertino.dart';

/// Class to pass onto FactoryTile.getTile()
@deprecated
final class TileDataRaw {
  /// Name of the tile to create
  final String name;
  /// Icon to display on tile
  final IconData icon;
  /// Define a next page (Optional)
  final StatefulWidget? action;
  /// Define a handler (Optional)
  final Function? handler;
  /// Indicate whether speech is enabled or not
  final bool isSpeechEnabled;

  /// Initializer
  const TileDataRaw({
    required this.name,
    required this.icon,
    this.action,
    this.handler,
    this.isSpeechEnabled = true,
  });
}