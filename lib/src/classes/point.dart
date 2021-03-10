import 'dart:convert';

import 'geometry.dart';

class GeoJSONPoint implements Geometry {
  List<double> coordinates = <double>[];
  GeoJSONPoint(this.coordinates);

  @override
  GeometryType get type => GeometryType.point;

  GeoJSONPoint.fromMap(Map data) {
    var l = data['coordinates'];
    coordinates.clear();
    l.forEach((value) {
      coordinates.add(value.toDouble());
    });
  }

  @override
  double get area => 0;

  @override
  double get distance => 0;

  @override
  List<double> get bbox => [
        coordinates[0],
        coordinates[1],
        coordinates[0],
        coordinates[1],
      ];

  /// A collection of key/value pairs of geospatial data
  @override
  Map<String, dynamic> toMap() => {
        'type': type.name,
        'coordinates': coordinates,
      };

  /// A collection of key/value pairs of geospatial data as String
  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
