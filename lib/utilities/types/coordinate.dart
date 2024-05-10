final class Coordinate {
  late double _latitude;
  late double _longitude;
  Coordinate({
    double latitude = 0,
    double longitude = 0
  }) {
    _latitude = latitude;
    _longitude = longitude;
  }

  double latitude() {
    return _latitude;
  }

  double longitude() {
    return _longitude;
  }

  Coordinate update({double? latitude, double? longitude})  {
    if (latitude != null) {
      _latitude = latitude;
    }

    if (longitude != null) {
      _longitude = longitude;
    }

    return this;
  }
}