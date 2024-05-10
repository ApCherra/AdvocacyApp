# How to use Tiles

---

## Create a Tile
Use `TileFactory` to generate all tiles.

Advise:

    (1) Avoid directly initializing any BaseTile subclass!
    (2) TileFactory will handle all the legwork for you!


### TileFactory
#### getBlankFromTile()
- Returns a blank tile based on another tile's size.

#### getBlankFromSize()
- Returns a blank tile based on a size object.

#### getBlankFromExplicit()
- Returns a blank tile based on a width and optional height.
  - If no height is provided, height will be set to width. (Producing a square.)

#### getTile()
* See below for all parameters, required ones are noted.

---

## Types of Tiles
### Base Tile `BaseTile` (Do not directly invoke)
- Contains speech and navigation functions are called on tap.
- Holds variables for layout customization.
  - Calculations for size are computed here. _Objects cannot be resized._
- Text and Children are computed as needed.
- Speech enabled by default.

### Blank Tile `BlankTile`
- Should be called via `TileFactory.getBlank()`.
- Sets all variables to ensure there is no unintended user interaction or feedback.

### Custom Tile `CustomTile`
- Should be instantiated via `TileFactory.getTile()`.
- This can call a function on tap, hold custom views, and otherwise be modified from standard looks.
- New pages can be presented with a CustomTile.

### Navigation Tile `NavTile`
- Should be instantiated via `TileFactory.getTile()`.
- Should be used when a new page should be presented on tap.


### Speech Tile `SpeechTile`
- Should be instantiated via `TileFactory.getTile()`.
- Should be called when only speech feedback is needed on tap.

---

## Creating Tile Types
- If the tile **needs to call a specific routine** everytime it is taped, use `CustomTile`.
- If there is **no need for a specific routine**, then use `BaseTile`.

---

# Parameters for `TileFactory.getTile()`:
## Required
`String name` - Name to display on tile. Set to an empty string if you do not need default text.

## Optional, but Highly Recommended For Non-Custom Tiles

`Color color` [Default = `Colors.black`] - Background color of tile.

`Color textColor` [Default = `Colors.white`] - Text color of tile.

`IconData? icon` - The icon to add in tile (See `Icons`).

## Optional
### Speech
- `speechString` - The value to speak, disregarding the tile's name. If this is not passed, when tapped (and `isSpeechEnabled == true`), then speech will use `tileName`.
- `bool isSpeechEnabled` [Default = true] - Enabled/disable speech.
  - It will speak the value passed as `name`.

### Utility
- `StatefulWidget? nextPage` - The next page to present
- `Function? handler` - The routine to run on tile tap.

### Text
- `TextStyle? textStyle` - The custom TextStyle to show. Default will be given `name`
- `double? textSize` - Size of the text to display (useless if textStyle or textItem is non-null).
- `Text? textItem` - The textItem to present.

### Icon
- Show a custom icon with specific parameters.
  - `Icon? customIcon`
  - `ImageIcon? imageIcon`
  - `IconButton? iconButton`
- `double? iconSize` - Customize the size of the default icon. Use one of the above may render this ineffective.

### Custom Layout Specifications
- `EdgeInsetsGeometry paddingInsets` [Default = const EdgeInsets.all(15.0)] - Define custom padding for a tile.
- `double borderRadius` [Default = 20] - Modify the default corners.
- `MainAxisAlignment columnAlignment` [Default = MainAxisAlignment.center] - Modify the column alignment.

### Container-Specific

- `double? containerWidthMultiplier` -  Give a relative width, WRT the view's width. i.e., 0.5 will be 50% of the view's width.
- `double? containerHeightMultiplier` - Give a relative height, WRT the view's height. i.e., 0.5 will be 50% of the view's height.
- `double? containerWidth` - Give an exact width.
- `double? containerHeight` - Give an exact height.
- `bool isSquare` [Default = false] - Calculate based on if the tile is a square. (Use width for width and height.)

### Custom Children

- `bool? prependDefaultChildren` - Add the default icon and text **BEFORE** the `customChildren` array.
- `bool? appendDefaultChildren` - Add the default icon and text **AFTER** the `customChildren` array.
- `List<Widget>? customChildren` - Show custom children in the tile. Leave both `prependDefaultChildren` and `appendDefaultChildren` null or set to false if you only want the `customChildren` shown.