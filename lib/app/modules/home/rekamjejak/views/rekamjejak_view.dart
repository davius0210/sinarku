import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sinarku/components/empty_component.dart';

import '../controllers/rekamjejak_controller.dart';

class RekamjejakView extends GetView<RekamjejakController> {
  const RekamjejakView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rekam Jejak'), centerTitle: true),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade200,
              child: const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xff024A7E),
                indicatorWeight: 3,
                tabs: [
                  Tab(text: "Rekam Jejak"),
                  Tab(text: "Daftar Jejak"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [_pageRekamJejak(context), _pageDaftarJejak()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageDaftarJejak() {
    return Column(
      children: [
        _buildSummaryCards(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Activities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.filter_list, color: Colors.blueAccent),
            ],
          ),
        ),
        Expanded(child: _buildSyncTable()),
      ],
    );
  }

  Widget _pageRekamJejak(BuildContext context) {
    return Stack(
      children: [
        // MAP
        FlutterMap(
          mapController: controller.mapController,
          options: const MapOptions(
            initialCenter: LatLng(-6.2088, 106.8456),
            initialZoom: 17,
            initialRotation: 15,
          ),
          children: [
            TileLayer(
              // Menggunakan CartoDB Positron (Light Mode)
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.sinarku.app',
            ),

            // Layer Jejak Rekaman
            Obx(
              () => PolylineLayer(
                polylines: [
                  Polyline(
                    points: controller.trackPoints.toList(),
                    color: Colors
                        .blueAccent, // Warna biru lebih cocok di mode light
                    strokeWidth: 5,
                  ),
                ],
              ),
            ),

            // Marker User
            Obx(
              () => MarkerLayer(
                markers: [
                  Marker(
                    point: controller.currentPosition.value,
                    width: 45,
                    height: 45,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Transform.rotate(
                        // Rotasi berdasarkan heading dari GPS
                        angle:
                            controller.heading.value *
                            (3.1415926535897932 / 180),
                        child: const Icon(
                          Icons.navigation, // Icon ini berbentuk panah arah
                          color: Colors.blue,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // TOP PANEL
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _modernPanel(
                  child: Obx(
                    () => DropdownButton<int>(
                      value: controller.selectedDuration.value,
                      underline: const SizedBox(),
                      onChanged: controller.isRecording.value
                          ? null
                          : (v) => controller.selectedDuration.value = v!,
                      items: controller.timeOptions
                          .map(
                            (t) => DropdownMenuItem(
                              value: t,
                              child: Text("$t Menit"),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                Obx(
                  () => controller.isRecording.value
                      ? _modernPanel(
                          color: Colors.redAccent,
                          child: Text(
                            controller.formattedTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),

        // BOTTOM CONTROLS
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Obx(() {
              if (!controller.isRecording.value) {
                // TAMPILAN TOMBOL START (MERAH)
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "SIAP REKAM",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _controlButton(
                      icon: Icons.play_arrow_rounded,
                      activeColor: Colors.redAccent,
                      isActive: false,
                      onTap: () => controller.startRecording(context),
                    ),
                  ],
                );
              } else {
                // TAMPILAN SAAT MEREKAM (PAUSE & STOP)
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TOMBOL PAUSE / RESUME
                    _controlButton(
                      icon: controller.isPaused.value
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      activeColor: Colors.orangeAccent,
                      isActive: controller.isPaused.value,
                      onTap: controller.togglePause,
                    ),
                    const SizedBox(width: 30),
                    // TOMBOL STOP
                    _controlButton(
                      icon: Icons.stop_rounded,
                      activeColor: Colors.redAccent,
                      isActive: true, // Efek putih (Active style)
                      onTap: () => controller.stopAndShowDialog(context),
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      ],
    );
  }

  Widget _modernPanel({required Widget child, Color? color}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color ?? Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // Tombol Rekam dengan Animasi Pulse
  Widget _controlButton({
    required IconData icon,
    required Color activeColor,
    required VoidCallback onTap,
    required bool isActive,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isActive ? 80 : 70, // Sedikit membesar saat aktif
        width: isActive ? 80 : 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.white : activeColor,
          boxShadow: [
            BoxShadow(
              color: isActive ? Colors.black12 : activeColor.withOpacity(0.5),
              blurRadius: isActive ? 25 : 15,
              spreadRadius: isActive ? 5 : 2,
            ),
          ],
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Icon(
          icon,
          size: isActive ? 45 : 35,
          color: isActive ? activeColor : iconColor,
        ),
      ),
    );
  }

  // Header Summary (Statistik singkat)
  Widget _buildSummaryCards() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _infoCard("Total", "128", Colors.blueAccent),
          _infoCard("Pending", "12", Colors.orangeAccent),
          _infoCard("Synced", "116", Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _infoCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Main List / Table
  Widget _buildSyncTable() {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemBuilder: (context, index) {
        bool isSynced = index % 3 == 0; // Simulasi status
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Method
              Icon(FontAwesomeIcons.walking, color: Colors.blue),
              const SizedBox(width: 15),
              // Endpoint & Payload Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jejak $index",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Terdapat 10 Titik",
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ),
              // Status Badge
              _statusBadge(isSynced),
            ],
          ),
        );
      },
    );
  }

  Widget _statusBadge(bool synced) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: synced
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            synced ? Icons.check_circle : Icons.sync,
            size: 14,
            color: synced ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 5),
          Text(
            synced ? "Synced" : "Pending",
            style: TextStyle(
              color: synced ? Colors.green : Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
