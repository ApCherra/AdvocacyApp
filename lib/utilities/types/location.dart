import 'package:coa_progress_tracking_app/utilities/types/coordinate.dart';

final class Location {
  late DateTime? _date;
  late Coordinate _coordinate;
  Location({
    required Coordinate coordinate,
    DateTime? date,
  }) {
    _date = date;
    _coordinate = coordinate;
  }

  DateTime? date() {
    return _date;
  }

  updateDate(DateTime? newDate) {
    _date = newDate;
  }

  Coordinate coordinate() {
    return _coordinate;
  }

  updateCoordinate(Coordinate newCoordinate) {
    _coordinate = newCoordinate;
  }
}