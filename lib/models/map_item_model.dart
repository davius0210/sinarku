import 'package:geobase/geobase.dart';
import 'package:latlong2/latlong.dart';

enum MapItemType { marker, polyline, polygon }

class MapItemModel {
  final String id;
  final MapItemType type;
  // Gunakan Geometry dari Geobase: Point, LineString, atau Polygon
  final Geometry geometry;
  String? title;

  MapItemModel({
    required this.id,
    required this.type,
    required this.geometry,
    this.title,
  });

 
}