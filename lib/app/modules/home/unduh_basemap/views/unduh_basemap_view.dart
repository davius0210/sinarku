import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';


import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sinarku/models/map_item_model.dart';

import '../controllers/unduh_basemap_controller.dart';

class UnduhBasemapView extends GetView<UnduhBasemapController> {
  const UnduhBasemapView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Peta Batas Daerah"),
        backgroundColor: Colors.blueGrey,
        actions: [
          _modeButton(Icons.touch_app, "cursor"),
          _modeButton(Icons.crop_square, "rect"),
        ],
      ),
      body: Stack(
        children: [
          _mapWidget(context),
          Obx(() => controller.isDragging.value ? _dragPreview() : const SizedBox()),
        ],
      ),
    );
  }

  /// BUTTON SELECT MODE
  Widget _modeButton(IconData icon, String mode) {
    return Obx(() {
      final active = controller.selectionMode.value == mode;
      return IconButton(
        icon: Icon(icon, color: active ? Colors.yellowAccent : Colors.white),
        onPressed: () => controller.selectionMode.value = mode,
      );
    });
  }

  /// MAP WIDGET
  Widget _mapWidget(BuildContext context) {
    return Listener(
      onPointerDown: (e) {
        if (controller.selectionMode.value == "rect") {
          final pos = _tapToLatLng(context, e.localPosition);
          controller.startRect(pos);
        }
      },
      onPointerMove: (e) {
        if (controller.selectionMode.value == "rect") {
          final pos = _tapToLatLng(context, e.localPosition);
          controller.updateRect(pos);
        }
      },
      onPointerUp: (_) {
        if (controller.selectionMode.value == "rect") {
          controller.finishRect();
        }
      },
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-6.2, 106.8),
          initialZoom: 5.0,
          onTap: (tapPosition, latLng) {
            if (controller.selectionMode.value == "cursor") _selectByCursor(latLng);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          GetBuilder<UnduhBasemapController>(
            builder: (_) => PolygonLayer(
              polygons: controller.geojsonData.map((f) {
                final id = f["properties"]["id"].toString();
                final isSelected = controller.selectedRegions.contains(id);
                final coords = f["geometry"]["coordinates"][0] as List;

                return Polygon(
                  points: coords.map((c) => LatLng(c[1], c[0])).toList(),
                  borderColor: isSelected ? Colors.blueAccent : Colors.black26,
                  borderStrokeWidth: isSelected ? 2 : 1,
                  color: isSelected
                      ? Colors.blue.withOpacity(0.5)
                      : Colors.black12.withOpacity(0.2),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// CURSOR SELECT
  void _selectByCursor(LatLng latLng) {
    for (var f in controller.geojsonData) {
      final id = f["properties"]["id"].toString();
      final coords = f["geometry"]["coordinates"][0] as List;

      final inside = coords.any((p) {
        return (p[1] - latLng.latitude).abs() < 0.05 &&
               (p[0] - latLng.longitude).abs() < 0.05;
      });

      if (inside && !controller.selectedRegions.contains(id)) {
        controller.selectedRegions.add(id);
      }
    }
  }

  /// LIVE DRAG PREVIEW
  Widget _dragPreview() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.redAccent, width: 2),
            color: Colors.red.withOpacity(0.15),
          ),
        ),
      ),
    );
  }

  /// Convert Tap → LatLng
  LatLng _tapToLatLng(BuildContext context, Offset position) {
    final mapCamera = MapCamera.of(context);

    // Konversi Offset → Point<num>
    final point = Point(position.dx, position.dy);

    return mapCamera.pointToLatLng(point);
  }
}
