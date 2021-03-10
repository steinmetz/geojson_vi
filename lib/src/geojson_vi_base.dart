import 'dart:convert';
import 'dart:io';

import 'package:geojson_vi/geojson_vi.dart';

import 'classes/feature_collection.dart';
import 'classes/feature.dart';

/// The abstract class of GeoJSON
abstract class GeoJSON {
  /// The GeoJSON file path
  String get path;

  /// The FeatureCollection object
  GeoJSONFeatureCollection get featureCollection;

  /// Load GeoJSON from file with file path
  static Future<GeoJSON> load(String path) async {
    return await _GeoJSON._load(path);
  }

  /// Create new GeoJSON with file path
  static GeoJSON create(String path) {
    var geoJSON = _GeoJSON(path);
    geoJSON._featureCollection = GeoJSONFeatureCollection();
    //TODO I am not sure 
    // geoJSON._featureCollection ?= GeoJSONFeatureCollection();
    return geoJSON;
  }

  /// Create new GeoJSON from GeoJSON String
  static GeoJSON fromString(String data) {
    return _GeoJSON._fromString(data);
  }

  /// Save to file or save as for new file path
  Future<File> save({String newPath});

  /// Clear all cached
  void clearAll();

  /// Clear cached for the path
  void clear(String path);
}

/// The GeoJSON Type
enum GeoJSONType { feature, featureCollection }

extension GeoJSONTypeExtension on GeoJSONType {
  String get name {
    switch (this) {
      case GeoJSONType.feature:
        return 'Feature';
      case GeoJSONType.featureCollection:
        return 'FeatureCollection';
      default:
        throw Exception('Invalid GeoJSONType');
    }
  }
}

/// The implement of the GeoJSON abstract class
class _GeoJSON implements GeoJSON {
  /// Private cache
  static final _cache = <String, _GeoJSON>{};

  /// Default private constructor with cache applied
  factory _GeoJSON(String path) {
    // _GeoJSON geoJSON;
    // if (_cache[path] == null) {
    //   geoJSON = _GeoJSON._init(path);
    // }
    // _cache.putIfAbsent(path, () => _GeoJSON._init(path));
    return _cache.putIfAbsent(path, () => _GeoJSON._init(path));
  }

  /// Private constructor
  _GeoJSON._init(this._path);

  /// Private GeoJSON file path
  String _path;

  /// Private FeatureCollection object
  late GeoJSONFeatureCollection _featureCollection;

  /// Private load
  static Future<_GeoJSON> _load(String path) async {
    var file = File(path);
    if (!await file.exists()) {
      throw Exception('File doesn\'t exists');
    }
    var geoJSON = _GeoJSON(path);
    if (geoJSON._featureCollection != null) {
      return geoJSON;
    } else {
      /// Read file as string
      await file.readAsString().then((data) async {
        var json = jsonDecode(data);
        if (json != null) {
          String type = json['type'];
          switch (type) {
            case 'FeatureCollection':
              geoJSON._featureCollection =
                  GeoJSONFeatureCollection.fromMap(json);
              break;
            case 'Feature':
              final fc = GeoJSONFeatureCollection();
              fc.features.add(GeoJSONFeature.fromMap(json));
              geoJSON._featureCollection = fc;
              break;
            case 'Point':
              final fc = GeoJSONFeatureCollection();
              fc.features
                  .add(GeoJSONFeature(GeoJSONPoint.fromMap(json)));
              geoJSON._featureCollection = fc;
              break;
            case 'MultiPoint':
              final fc = GeoJSONFeatureCollection();
              fc.features
                  .add(GeoJSONFeature(GeoJSONMultiPoint.fromMap(json)));
              geoJSON._featureCollection = fc;
              break;
            case 'LineString':
              final fc = GeoJSONFeatureCollection();
              fc.features
                  .add(GeoJSONFeature(GeoJSONLineString.fromMap(json)));
              geoJSON._featureCollection = fc;
              break;
            case 'MultiLineString':
              final fc = GeoJSONFeatureCollection();
              fc.features.add(
                  GeoJSONFeature(GeoJSONMultiLineString.fromMap(json)));
              geoJSON._featureCollection = fc;
              break;
            case 'Polygon':
              final fc = GeoJSONFeatureCollection();
              fc.features
                  .add(GeoJSONFeature(GeoJSONPolygon.fromMap(json)));
              geoJSON._featureCollection = fc;
              break;
            case 'MultiPolygon':
              final fc = GeoJSONFeatureCollection();
              fc.features.add(
                  GeoJSONFeature(GeoJSONMultiPolygon.fromMap(json)));
              geoJSON._featureCollection = fc;
              break;
            case 'GeometryCollection':
              final fc = GeoJSONFeatureCollection();
              fc.features.add(GeoJSONFeature(
                  GeoJSONGeometryCollection.fromMap(json)));
              geoJSON._featureCollection = fc;
              break;
          }
        }
      }).catchError((onError) {
        print(onError ?? 'Unkonwn error!');
        return null;
      });

      /// For empty file
      geoJSON._featureCollection = GeoJSONFeatureCollection();
      //TODO I am not sure here
      // geoJSON._featureCollection ??= GeoJSONFeatureCollection();
      return geoJSON;
    }
  }

  /// GeoJSON From String
  ///
  /// FeatureCollection, Feature and all the Geometries like
  /// Point, MultiPoint, LineString, MultiLineString, Polygon,
  /// MultiPolygon and GeometryCollection string
  static _GeoJSON _fromString(String data) {
    _cache.remove('tmp');
    var geoJSON = _GeoJSON('tmp');

    var json = jsonDecode(data);
    if (json != null) {
      String type = json['type'];
      switch (type) {
        case 'FeatureCollection':
          final fc = GeoJSONFeatureCollection.fromMap(json);
          geoJSON._featureCollection = fc;
          break;
        case 'Feature':
          final fc = GeoJSONFeatureCollection();
          fc.features.add(GeoJSONFeature.fromMap(json));
          geoJSON._featureCollection = fc;
          break;
        case 'Point':
          final fc = GeoJSONFeatureCollection();
          fc.features.add(GeoJSONFeature(GeoJSONPoint.fromMap(json)));
          geoJSON._featureCollection = fc;
          break;
        case 'MultiPoint':
          final fc = GeoJSONFeatureCollection();
          fc.features
              .add(GeoJSONFeature(GeoJSONMultiPoint.fromMap(json)));
          geoJSON._featureCollection = fc;
          break;
        case 'LineString':
          final fc = GeoJSONFeatureCollection();
          fc.features
              .add(GeoJSONFeature(GeoJSONLineString.fromMap(json)));
          geoJSON._featureCollection = fc;
          break;
        case 'MultiLineString':
          final fc = GeoJSONFeatureCollection();
          fc.features
              .add(GeoJSONFeature(GeoJSONMultiLineString.fromMap(json)));
          geoJSON._featureCollection = fc;
          break;
        case 'Polygon':
          final fc = GeoJSONFeatureCollection();
          fc.features.add(GeoJSONFeature(GeoJSONPolygon.fromMap(json)));
          geoJSON._featureCollection = fc;
          break;
        case 'MultiPolygon':
          final fc = GeoJSONFeatureCollection();
          fc.features
              .add(GeoJSONFeature(GeoJSONMultiPolygon.fromMap(json)));
          geoJSON._featureCollection = fc;
          break;
        case 'GeometryCollection':
          final fc = GeoJSONFeatureCollection();
          fc.features.add(
              GeoJSONFeature(GeoJSONGeometryCollection.fromMap(json)));
          geoJSON._featureCollection = fc;
          break;
      }
    }
    return geoJSON;
  }

  @override
  String get path => _path;

  @override
  GeoJSONFeatureCollection get featureCollection => _featureCollection;

  @override
  Future<File> save({String? newPath}) {
    var filePath = newPath ?? path;
    var file = File(filePath);
    return file.writeAsString(
      JsonEncoder().convert(_featureCollection.toMap()),
    );
  }

  @override
  void clear(String path) {
    _cache.remove(path);
  }

  @override
  void clearAll() {
    _cache.clear();
  }
}
