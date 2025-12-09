import 'dart:ui';

import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class UnduhBasemapController extends GetxController {
  Rx<List<Polygon>> polygons = Rx([]);
  Rx<List<LatLng>> polygonPoints = Rx([]);
  var isDrawing = false.obs;
  var saveButtonEnable = false.obs;
  var editButton = false.obs;
  var editButtonRectangle = false.obs;
  var isNewPolygon =
      false.obs; // True indicates the next point starts a new polygon
  var isNewRectangle =
      false.obs; // True indicates the next point starts a new rectangle

  void addPolygon(LatLng pointPath) {
    if (editButton.value == false) {
      return;
    }
    if (isNewPolygon.value) {
      // Start a new polygon
      polygonPoints.value = [
        pointPath,
      ]; // Clear existing points and add the first one
      polygons.value.add(
        Polygon(
          points: polygonPoints.value,
          color: const Color.fromRGBO(130, 0, 0, 0.5), // Example color
          borderColor: const Color.fromRGBO(
            130,
            0,
            0,
            1,
          ), // Example border color
          borderStrokeWidth: 2,
          isFilled: true,
        ),
      );
      polygons.refresh(); // Notify GetX about the change in the list
      isNewPolygon.value = false; // Next points will extend this polygon
    } else {
      // Add points to the current active polygon
      if (polygons.value.isNotEmpty) {
        polygonPoints.value.add(pointPath);
        // Update the last polygon with the new set of points
        polygons.value.last = Polygon(
          points: List.from(
            polygonPoints.value,
          ), // Create a new list to ensure reactivity
          color: polygons.value.last.color,
          borderColor: polygons.value.last.borderColor,
          borderStrokeWidth: polygons.value.last.borderStrokeWidth,
          isFilled: polygons.value.last.isFilled,
        );
        polygons.refresh(); // Notify GetX about the change in the list item
      }
    }
  }

  // Call this method when a button is clicked to indicate a new polygon should start
  void startNewPolygonDrawing() {
    if (isDrawing.value) return; // cegah jika sedang gambar rectangle

    isDrawing.value = true;
    saveButtonEnable.value = true;
    editButton.value = true;
    isNewPolygon.value = true;
    polygonPoints.value = [];
  }

  void saveNewPolygonDrawing() {
    editButton.value = false;
    isNewPolygon.value = false;
    saveButtonEnable.value = false;
    polygonPoints.value = [];
    isDrawing.value = false;
  }

  void startNewRectangleDrawing() {
    if (isDrawing.value) return; // cegah jika sedang gambar polygon

    isDrawing.value = true;
    saveButtonEnable.value = true;
    editButtonRectangle.value = true;
    isNewRectangle.value = true;
    polygonPoints.value = [];
  }

  void saveNewRectangleDrawing() {
    editButtonRectangle.value = false;
    isNewRectangle.value = false;
    saveButtonEnable.value = false;
    polygonPoints.value = [];
    isDrawing.value = false;
  }

  void saveButton() {
    if (editButton.value) {
      if (polygonPoints.value.length < 3) {
        cancelPolygonDrawing(); // polygon tidak valid, cancel
      } else {
        saveNewPolygonDrawing();
      }
    } else if (editButtonRectangle.value) {
      if (polygonPoints.value.length < 2) {
        cancelRectangleDrawing(); // rectangle tidak valid, cancel
      } else {
        saveNewRectangleDrawing();
      }
    }
  }

  void addRectangle(LatLng pointPath) {
    if (!editButtonRectangle.value) {
      return;
    }

    // Jika kita sedang memulai rectangle baru (dari tombol startNewRectangleDrawing)
    if (isNewRectangle.value) {
      // mulai rectangle baru: simpan titik pertama dan buat placeholder polygon baru
      polygonPoints.value = [pointPath];
      isNewRectangle.value = false;

      // Buat rectangle sekali-sementara (empat corner sama dengan titik pertama)
      final List<LatLng> initialCorners = [
        LatLng(pointPath.latitude, pointPath.longitude),
        LatLng(pointPath.latitude, pointPath.longitude),
        LatLng(pointPath.latitude, pointPath.longitude),
        LatLng(pointPath.latitude, pointPath.longitude),
        LatLng(pointPath.latitude, pointPath.longitude),
      ];

      polygons.value.add(
        Polygon(
          points: initialCorners,
          color: const Color.fromRGBO(0, 0, 130, 0.5),
          borderColor: const Color.fromRGBO(0, 0, 130, 1),
          borderStrokeWidth: 2,
          isFilled: true,
        ),
      );
      polygons.refresh();
      return;
    }

    // Jika belum ada titik sama sekali (mis. user tidak memanggil startNewRectangleDrawing),
    // kita perlakukan sebagai mulai baru juga — tapi jangan ubah isNewRectangle.
    if (polygonPoints.value.isEmpty) {
      polygonPoints.value = [pointPath];

      // tambahkan placeholder polygon agar update berikutnya tidak menimpa polygon lama
      final List<LatLng> initialCorners = [
        LatLng(pointPath.latitude, pointPath.longitude),
        LatLng(pointPath.latitude, pointPath.longitude),
        LatLng(pointPath.latitude, pointPath.longitude),
        LatLng(pointPath.latitude, pointPath.longitude),
        LatLng(pointPath.latitude, pointPath.longitude),
      ];

      polygons.value.add(
        Polygon(
          points: initialCorners,
          color: const Color.fromRGBO(0, 0, 130, 0.5),
          borderColor: const Color.fromRGBO(0, 0, 130, 1),
          borderStrokeWidth: 2,
          isFilled: true,
        ),
      );
      polygons.refresh();
      return;
    }

    // Jika sudah ada 1 titik => ini adalah titik kedua untuk mendefinisikan diagonal rectangle
    if (polygonPoints.value.length == 1) {
      polygonPoints.value.add(pointPath);
      _updateRectanglePolygon();
      return;
    }

    // Jika sudah ada 2 titik => kita sedang resize salah satu diagonal point
    if (polygonPoints.value.length == 2) {
      final LatLng p1 = polygonPoints.value[0];
      final LatLng p2 = polygonPoints.value[1];

      final double dist1 = _distance(p1, pointPath);
      final double dist2 = _distance(p2, pointPath);

      if (dist1 < dist2) {
        polygonPoints.value[0] = pointPath;
      } else {
        polygonPoints.value[1] = pointPath;
      }
      _updateRectanglePolygon();
      return;
    }

    // Safety fallback: jika lebih dari 2, reset ke behavior standar (ambil pertama 2)
    if (polygonPoints.value.length > 2) {
      polygonPoints.value = [polygonPoints.value.first, polygonPoints.value[1]];
      _updateRectanglePolygon();
    }
  }

  // Helper to calculate distance between two LatLng points (simplified for comparison)
  double _distance(LatLng p1, LatLng p2) {
    final double dx = p1.latitude - p2.latitude;
    final double dy = p1.longitude - p2.longitude;
    return dx * dx + dy * dy; // Squared distance for performance
  }

  // Helper to create/update the rectangle polygon from two diagonal points
  void _updateRectanglePolygon() {
    if (polygonPoints.value.length < 2) {
      return; // Not enough points to form a rectangle
    }

    final LatLng p1 = polygonPoints.value[0];
    final LatLng p2 = polygonPoints.value[1];

    // Calculate the four corners of the rectangle
    final LatLng corner1 = LatLng(p1.latitude, p1.longitude);
    final LatLng corner2 = LatLng(p1.latitude, p2.longitude);
    final LatLng corner3 = LatLng(p2.latitude, p2.longitude);
    final LatLng corner4 = LatLng(p2.latitude, p1.longitude);

    final List<LatLng> rectangleCorners = [
      corner1,
      corner2,
      corner3,
      corner4,
      corner1, // Close the polygon
    ];

    if (polygons.value.isEmpty) {
      polygons.value.add(
        Polygon(
          points: rectangleCorners,
          color: const Color.fromRGBO(
            0,
            0,
            130,
            0.5,
          ), // Example color for rectangle
          borderColor: const Color.fromRGBO(0, 0, 130, 1),
          borderStrokeWidth: 2,
          isFilled: true,
        ),
      );
    } else {
      // Update the last polygon (assuming it's the rectangle being edited)
      polygons.value.last = Polygon(
        points: rectangleCorners,
        color: polygons.value.last.color,
        borderColor: polygons.value.last.borderColor,
        borderStrokeWidth: polygons.value.last.borderStrokeWidth,
        isFilled: polygons.value.last.isFilled,
      );
    }
    polygons.refresh(); // Notify GetX about the change
  }

  void cancelRectangleDrawing() {
    if (editButtonRectangle.value) {
      if (polygons.value.isNotEmpty) {
        polygons.value.removeLast();
        polygons.refresh();
      }
    }
    polygonPoints.value = [];
    editButtonRectangle.value = false;
    isNewRectangle.value = false;
    saveButtonEnable.value = false;
    isDrawing.value = false;
  }

  void cancelPolygonDrawing() {
    if (editButton.value) {
      if (polygons.value.isNotEmpty) {
        polygons.value.removeLast();
        polygons.refresh();
      }
    }
    polygonPoints.value = [];
    editButton.value = false;
    isNewPolygon.value = false;
    saveButtonEnable.value = false;
    isDrawing.value = false;
  }
}
