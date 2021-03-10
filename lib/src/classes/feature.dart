import 'dart:convert';

import '../geojson_vi_base.dart';
import 'geometry.dart';
import 'multi_point.dart';
import 'line_string.dart';
import 'multi_line_string.dart';
import 'point.dart';
import 'polygon.dart';
import 'multi_polygon.dart';
import 'geometry_collection.dart';

/// Định nghĩa nguyên mẫu đối tượng địa lý
class GeoJSONFeature {
  /// Trong GeoJSON mục B.1.  Normative Changes có nói
  /// A Feature object's "id" member is a string or number
  /// If a Feature has a commonly used identifier, that identifier
  /// SHOULD be included as a member of the Feature object with the name
  /// "id", and the value of this member is either a JSON string or number.
  /// TODO: Có thể viết báo đề xuất thêm id là bắt buộc và chứng minh
  /// cho việc này là việc tìm kiếm và truy xuất,...
  /// Vẽ lại mô hình UML

  GeoJSONType get type => GeoJSONType.feature;
  late Geometry geometry;

  GeoJSONFeature(this.geometry);

  String? id;
  // String? get id => _id;
  // set id(String? value) => _id = value;

  Map<String, dynamic> properties = <String, dynamic>{};
  // Map<String, dynamic> get properties => _properties;
  // set properties(Map<String, dynamic> value) => _properties = value;

  List<double>? _bbox; // [west, south, east, north]
  List<double>? get bbox => _bbox;

  String? _title;
  String? get title => _title;
  set title(String? value) => _title = value;

  GeoJSONFeature.fromMap(Map data) {
    geometry = Geometry.fromMap(data['geometry']);
    if(data.containsKey('id')) id = data['id'];
    if(data.containsKey('properties')) properties =  data['properties'];
    if (data.containsKey('bbox')) {
      final bboxMap = data['bbox'] as List;
      if (bboxMap.length == 4) {
        _bbox = data['bbox'];
      }
    }
    // List<dynamic> b = data['bbox'];
    // var bb = <double>[];
    // if (b != null) {
    //   b.forEach((element) {
    //     bb.add(element.toDouble());
    //   });
    //   if (bb.isNotEmpty && bb.length == 4) {
    //     _bbox = bb;
    //   }
    // }
    _title = data['title'];
  }

  Map<String, dynamic> get geometrySerialize {
    switch (geometry.type) {
      case GeometryType.point:
        final geom = geometry as GeoJSONPoint;
        return geom.toMap();
      case GeometryType.lineString:
        final geom = geometry as GeoJSONLineString;
        return geom.toMap();
      case GeometryType.multiPoint:
        final geom = geometry as GeoJSONMultiPoint;
        return geom.toMap();
      case GeometryType.polygon:
        final geom = geometry as GeoJSONPolygon;
        return geom.toMap();
      case GeometryType.multiLineString:
        final geom = geometry as GeoJSONMultiLineString;
        return geom.toMap();
      case GeometryType.multiPolygon:
        final geom = geometry as GeoJSONMultiPolygon;
        return geom.toMap();
      case GeometryType.geometryCollection:
        final geom = geometry as GeoJSONGeometryCollection;
        return geom.toMap();
      default:
    }
    return {};
  }

  /// A collection of key/value pairs of geospatial data
  Map<String, dynamic> toMap() => {
        'type': type.name,
        if (id != null) 'id': id,
        'properties': properties,
        'bbox': (bbox != null) ? bbox : geometry.bbox,
        // if (bbox != null) 'bbox': bbox,
        if (title != null) 'title': title,
        'geometry': geometrySerialize
      };

  /// A collection of key/value pairs of geospatial data as String
  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
