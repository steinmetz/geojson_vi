import 'dart:convert';

import 'point.dart';
import 'multi_point.dart';
import 'line_string.dart';
import 'multi_line_string.dart';
import 'polygon.dart';
import 'multi_polygon.dart';
import 'geometry_collection.dart';

/// Geometry type
enum GeometryType {
  point,
  multiPoint,
  lineString,
  multiLineString,
  polygon,
  multiPolygon,
  geometryCollection
}

extension GeometryTypeExtension on GeometryType {
  String get name {
    switch (this) {
      case GeometryType.point:
        return 'Point';
      case GeometryType.multiPoint:
        return 'MultiPoint';
      case GeometryType.lineString:
        return 'LineString';
      case GeometryType.multiLineString:
        return 'MultiLineString';
      case GeometryType.polygon:
        return 'Polygon';
      case GeometryType.multiPolygon:
        return 'MultiPolygon';
      case GeometryType.geometryCollection:
        return 'GeometryCollection';
      default:
        throw Exception('Invalid Geometry type name');
        //TODO: write a test for this invalid type
    }
  }
}

abstract class Geometry {
  GeometryType get type;

  double get area;
  double get distance;
  List<double> get bbox;

  factory Geometry.fromMap(Map data) {
    String type = data['type'];
    switch (type) {
      case 'Point':
        return GeoJSONPoint.fromMap(data);
      case 'MultiPoint':
        return GeoJSONMultiPoint.fromMap(data);
      case 'LineString':
        return GeoJSONLineString.fromMap(data);
      case 'MultiLineString':
        return GeoJSONMultiLineString.fromMap(data);
      case 'Polygon':
        return GeoJSONPolygon.fromMap(data);
      case 'MultiPolygon':
        return GeoJSONMultiPolygon.fromMap(data);
      case 'GeometryCollection':
        return GeoJSONGeometryCollection.fromMap(data);
    }
    throw Exception('Invalid Geometry type');
    //TODO: write a test for this invalid type
  }

  /// A collection of key/value pairs of geospatial data
  Map<String, dynamic> toMap();

  /// A collection of key/value pairs of geospatial data as String
  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
