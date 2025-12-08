import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
enum ToolType { none, rectangle, polygon }
class UnduhBasemapController extends GetxController {
 RxString selectionMode = 'none'.obs; // none, cursor, rect
  RxList<String> selectedRegions = <String>[].obs;

  // Untuk drag rectangle
  LatLng? startDrag;
  LatLng? endDrag;
  RxBool isDragging = false.obs;

  // GeoJSON dummy (ganti nanti)
  List<Map<String, dynamic>> geojsonData = [];

  void setGeojson(List<Map<String, dynamic>> data) {
    geojsonData = data;
    update();
  }

  void startRect(LatLng latLng) {
    startDrag = latLng;
    endDrag = latLng;
    isDragging.value = true;
  }

  void updateRect(LatLng latLng) {
    endDrag = latLng;
    isDragging.value = true;
  }

  void finishRect() {
    if (startDrag == null || endDrag == null) return;
    isDragging.value = false;

    final minLat = _min(startDrag!.latitude, endDrag!.latitude);
    final maxLat = _max(startDrag!.latitude, endDrag!.latitude);
    final minLng = _min(startDrag!.longitude, endDrag!.longitude);
    final maxLng = _max(startDrag!.longitude, endDrag!.longitude);

    for (var f in geojsonData) {
      final id = f["properties"]["id"].toString();
      final coords = f["geometry"]["coordinates"][0] as List;

      bool inside = coords.any((p) {
        final lat = p[1], lng = p[0];
        return lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;
      });

      if (inside && !selectedRegions.contains(id)) {
        selectedRegions.add(id);
      }
    }
    update();
  }

  double _min(double a, double b) => a < b ? a : b;
  double _max(double a, double b) => a > b ? a : b;
}
