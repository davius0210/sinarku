import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sinarku/components/custom_button_component.dart';
import 'package:sinarku/components/custom_text_component.dart';
import 'package:sinarku/helper/colors_helper.dart';
import 'package:sinarku/helper/custom_toast_helper.dart';
import 'package:sinarku/helper/function_helper.dart';
import 'package:sinarku/helper/sync_helper.dart';

class RekamjejakController extends GetxController {
  final MapController mapController = MapController();
  final nameController = TextEditingController();
  var heading = 0.0.obs;

  var isRecording = false.obs;
  var isPaused = false.obs;
  var trackPoints = <LatLng>[].obs;
  var currentPosition = const LatLng(-6.2088, 106.8456).obs;
  var totalDistance = 0.0.obs;

  // Fitur Waktu
  var selectedDuration = 30.obs;
  var remainingSeconds = 0.obs;
  Timer? _timer;
  StreamSubscription<Position>? _positionStream;

  final List<int> timeOptions = [15, 30, 60, 120];

  void startRecording(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    isRecording.value = true;
    isPaused.value = false;
    remainingSeconds.value = selectedDuration.value * 60;
    trackPoints.clear();
    totalDistance.value = 0.0;

    _startTimer(context);
    _startGpsStream();
  }

  void _startTimer(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isRecording.value && !isPaused.value) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          stopAndShowDialog(context);
        }
      }
    });
  }

  void _startGpsStream() {
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 2,
          ),
        ).listen((Position position) {
          heading.value = position.heading;
          if (isRecording.value && !isPaused.value) {
            LatLng newPoint = LatLng(position.latitude, position.longitude);

            if (trackPoints.isNotEmpty) {
              double distance = Geolocator.distanceBetween(
                trackPoints.last.latitude,
                trackPoints.last.longitude,
                newPoint.latitude,
                newPoint.longitude,
              );
              totalDistance.value += distance;
            }

            currentPosition.value = newPoint;
            trackPoints.add(newPoint);
            mapController.move(newPoint, mapController.camera.zoom);
          }
        });
  }

  void togglePause() {
    isPaused.value = !isPaused.value;
  }

  void stopAndShowDialog(BuildContext context) {
    isRecording.value = false;
    isPaused.value = false;
    _timer?.cancel();
    _positionStream?.cancel();

    // Tampilkan Dialog Input Nama
    showSaveDialog(context);
  }

  void showSaveDialog(BuildContext context) {
    FunctionHelper.showDialog(
      context,
      height: 230,
      title: 'Simpan Jejak',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Jarak tempuh: ${(totalDistance.value / 1000).toStringAsFixed(2)} km",
          ),
          const SizedBox(height: 15),
          CustomTextComponent(
            controller: nameController,
            hint: 'Masukkan nama jejak',
          ),
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButtonComponent(
            onPressed: () => Get.back(),
            title: "Batal",
            gradient: ColorsHelper.dangerGradient,
          ),
          const SizedBox(width: 10),
          CustomButtonComponent(
            onPressed: () async {
              // Logika Simpan Data ke Database di sini
              print(
                "Menyimpan ${nameController.text} dengan ${trackPoints.length} titik",
              );

              final result = await LocalSyncDB.instance.insertQueue(
                SyncItem(
                  endpoint: "https://api.sinarku.id/toponim",
                  method: "POST",
                  payload: {'nama': nameController.text, 'titik': trackPoints},
                  type: SyncType.jejak,
                  createdAt: DateTime.now().toIso8601String(),
                ),
              );
              if (result != 0) {
                Get.back();
                ToastHelper.show(
                  context,
                  message: "Data berhasil disimpan",
                  icon: const Icon(Icons.check, color: Colors.green),
                );
              } else {
                ToastHelper.show(
                  context,
                  message: "Data gagal disimpan",
                  icon: const Icon(Icons.error, color: Colors.red),
                );
              }
              nameController.clear();
            },
            title: "Simpan",
          ),
        ],
      ),
    );
    // Get.dialog(
    //   AlertDialog(
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //     title: const Text("Simpan Jejak"),
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Text(
    //           "Jarak tempuh: ${(totalDistance.value / 1000).toStringAsFixed(2)} km",
    //         ),
    //         const SizedBox(height: 15),
    //         TextField(
    //           controller: nameController,
    //           decoration: const InputDecoration(
    //             hintText: "Masukkan nama jejak...",
    //             border: OutlineInputBorder(),
    //           ),
    //         ),
    //       ],
    //     ),
    //     actions: [
    //       TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
    //       ElevatedButton(
    //         onPressed: () {
    //           // Logika Simpan Data ke Database di sini
    //           print(
    //             "Menyimpan ${nameController.text} dengan ${trackPoints.length} titik",
    //           );
    //           Get.back();
    //           Get.snackbar("Sukses", "Jejak berhasil disimpan");
    //           nameController.clear();
    //         },
    //         child: const Text("Simpan"),
    //       ),
    //     ],
    //   ),
    //   barrierDismissible: false,
    // );
  }

  String get formattedTime {
    int minutes = remainingSeconds.value ~/ 60;
    int seconds = remainingSeconds.value % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
