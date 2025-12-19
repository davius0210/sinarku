import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sinarku/app/routes/app_pages.dart';
import 'package:sinarku/components/custom_bottomsheet_component.dart';
import 'package:sinarku/components/custom_button_component.dart';
import 'package:sinarku/components/custom_filepicker_component.dart';
import 'package:sinarku/components/custom_middle_navbar_component.dart';
import 'package:sinarku/components/custom_text_component.dart';
import 'package:sinarku/components/label_divider_component.dart';
import 'package:sinarku/components/layer_component.dart';
import 'package:sinarku/components/popup_with_arrow_component.dart';
import 'package:sinarku/components/ripple_pin_location_component.dart';
import 'package:sinarku/components/status_indicator_component.dart';
import 'package:sinarku/helper/colors_helper.dart';
import 'package:sinarku/helper/constant_helper.dart';
import 'package:sinarku/helper/custom_toast_helper.dart';
import 'package:sinarku/helper/function_helper.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: Image(image: AssetImage('assets/images/logo.png')),
              foregroundColor: Colors.white,
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jimmy Andrian Davius',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Pengguna Umum',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Obx(
            () => StatusIndicator(
              size: 15,
              gradientColors: controller.isOnline.value
                  ? controller.isProses.value
                        ? ColorsHelper.warningGradient
                        : ColorsHelper.successGradient
                  : ColorsHelper.dangerGradient,
              duration: const Duration(seconds: 2),
              repeatCount: -1, // infinite glow
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                interactionOptions: InteractionOptions(
                  enableMultiFingerGestureRace: false,
                ),
                initialCenter: LatLng(-6.2088, 106.8456),
                initialZoom: 14,
                onMapEvent: (event) {
                  if (event is MapEventMoveEnd &&
                      controller.isRekamToponim.value) {
                    final center = controller.mapController.camera.center;
                    controller.currentCenter.value = center;
                    controller.fetchLocationInfo(center);
                  }
                },
                onPositionChanged: (position, hasGesture) {},
              ),
              children: [
                // TileLayer(
                //   urlTemplate:
                //       'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                //   maxZoom: 18,
                // ),
                TileLayer(
                  // Menggunakan CartoDB Positron (Light Mode)
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.sinarku.app',
                  maxZoom: 18,
                ),

                Obx(() {
                  return MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.currentLocation.value!,
                        width: 45,
                        height: 45,
                        // Gunakan bottomCenter agar koordinat GPS pas di titik PIN
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            // optional: drag marker pakai screen delta
                          },
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
                                  controller.CurrentHeading.value *
                                  (3.1415926535897932 / 180),
                              child: const Icon(
                                Icons
                                    .navigation, // Icon ini berbentuk panah arah
                                color: Colors.blue,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                Obx(() {
                  // Pastikan queueMap.value tidak kosong
                  if (controller.queueMap.value.isEmpty)
                    return const SizedBox();

                  return MarkerLayer(
                    markers: controller.queueMap.value.map((e) {
                      final _data = jsonDecode(e['payload'].toString());
                      final _address = _data['alamat'];
                      final coordinate = _data['koordinat'];
                      print(coordinate);
                      return Marker(
                        point: LatLng(coordinate['lat'], coordinate['lng']),
                        // --- TAMBAHKAN WIDTH DAN HEIGHT DISINI ---
                        width: 300,
                        height: 300,
                        alignment: Alignment.center,
                        child: RippleLocationPin(
                          infoWidget: Column(
                            mainAxisSize: MainAxisSize
                                .min, // Agar tidak overflow ke bawah
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Koordinat: ${coordinate['lat'].toStringAsFixed(2)}, ${coordinate['lng'].toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                              const Divider(height: 10),
                              Text(
                                "Provinsi: ${_address['provinsi'] ?? '-'}",
                                style: const TextStyle(fontSize: 10),
                              ),
                              Text(
                                "Kota/Kab: ${_address['kabupaten_kota'] ?? '-'}",
                                style: const TextStyle(fontSize: 10),
                              ),
                              Text(
                                "Kec: ${_address['kecamatan'] ?? '-'}",
                                style: const TextStyle(fontSize: 10),
                              ),
                              Text(
                                "Kel/Desa: ${_address['desa_kelurahan'] ?? '-'}",
                                style: const TextStyle(fontSize: 10),
                              ),
                              const SizedBox(height: 6),
                            ],
                          ),
                          size: 14,
                          color: Colors.red,
                          onTapInfo: () {
                            Get.toNamed(
                              Routes.DETAIL_TOPONIM,
                              arguments: _data,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                }),
                Obx(() {
                  if (!controller.isRekamToponim.value ||
                      controller.currentCenter.value == null) {
                    return const SizedBox();
                  }

                  return MarkerLayer(
                    markers: [
                      Marker(
                        point: controller.currentCenter.value!,
                        width: 80,
                        height: 80,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            // optional: drag marker pakai screen delta
                          },
                          child: const RippleLocationPin(
                            size: 14,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          Positioned(
            left: 10,
            bottom: 105,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorsHelper.primary.withOpacity(0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.satellite_alt, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          'Satellite',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.terrain, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          controller.currentPosition.value!.altitude
                                  .toStringAsFixed(2) +
                              ' m',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.speed, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          controller.currentPosition.value!.speed
                                  .toStringAsFixed(2) +
                              ' km/h',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.my_location, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          controller.currentPosition.value!.accuracy
                                  .toStringAsFixed(2) +
                              ' m',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 25, 10, 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: ColorsHelper.primary,
                // gradient: LinearGradient(
                //   colors: [ColorsHelper.primary, ColorsHelper.blue],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.SETTING);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.gear, color: Colors.white),
                          Text(
                            'Pengaturan',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.SYNCDATA);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.database,
                            color: Colors.white,
                          ),
                          Text(
                            'Daftar Data',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.REKAMJEJAK);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.walking, color: Colors.white),
                          Text(
                            'Rekam Jejak',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.PROFILE);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.user, color: Colors.white),
                          Text(
                            'User',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () {
                        controller.isRekamToponim.value =
                            !controller.isRekamToponim.value;
                        if (controller.isRekamToponim.value) {
                          ToastHelper.show(
                            context,
                            message:
                                'Anda berada di mode edit toponim. Silahkan geser pin untuk mengubah lokasi',
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Ink(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          // color: ColorsHelper.primary,
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            colors: [ColorsHelper.primary, ColorsHelper.blue],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black26,
                          //     blurRadius: 10,
                          //     offset: Offset(0, 5),
                          //   ),
                          // ],
                        ),
                        child: Center(
                          child: FaIcon(
                            Icons.pin_drop,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Rekam Toponim',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,

            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButtonComponent(
                  icon: Icon(
                    FontAwesomeIcons.compass,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(50),
                ),
                Row(
                  children: [
                    CustomButtonComponent(
                      borderRadius: BorderRadius.circular(50),
                      icon: Icon(Icons.upload, size: 30, color: Colors.white),
                      onPressed: () {
                        FunctionHelper.showDialog(
                          context,
                          title: 'Unggah Data Lain',
                          height: 200,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColorsHelper.border,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text('Pilih KMZ/KML, SHP, CSV'),
                                    ),
                                    Icon(
                                      Icons.attach_file_outlined,
                                      color: ColorsHelper.primary,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              CustomButtonComponent(
                                width: double.infinity,
                                title: 'Simpan',
                                icon: Icon(
                                  FontAwesomeIcons.save,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 10),
                    CustomButtonComponent(
                      icon: Icon(Icons.layers, size: 30, color: Colors.white),
                      onPressed: () {
                        FunctionHelper.showDialog(
                          context,
                          height: 400,
                          title: 'Layer',
                          content: Obx(
                            () => Column(
                              children: [
                                LayerComponent(
                                  title: "Toponim Sekitar",
                                  value: controller.toponimSekitar.value,
                                  sliderValue: controller.valSekitar.value,
                                  onChangedCheck: (v) =>
                                      controller.toponimSekitar.value = v!,
                                  onChangedSlider: (v) =>
                                      controller.valSekitar.value = v,
                                ),

                                LayerComponent(
                                  title: "Toponim Hasil Survei",
                                  value: controller.toponimHasil.value,
                                  sliderValue: controller.valHasil.value,
                                  onChangedCheck: (v) =>
                                      controller.toponimHasil.value = v!,
                                  onChangedSlider: (v) =>
                                      controller.valHasil.value = v,
                                ),

                                LayerComponent(
                                  title: "Service Peta Dasar",
                                  value: controller.serviceDasar.value,
                                  sliderValue: controller.valDasar.value,
                                  onChangedCheck: (v) =>
                                      controller.serviceDasar.value = v!,
                                  onChangedSlider: (v) =>
                                      controller.valDasar.value = v,
                                ),

                                Row(
                                  children: [
                                    Checkbox(
                                      value: controller.dataLain.value,
                                      onChanged: (v) =>
                                          controller.dataLain.value = v!,
                                    ),
                                    const Text(
                                      "Data Lain",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          footer: CustomButtonComponent(
                            width: double.infinity,
                            title: "Ok",
                            icon: Icon(Icons.check, color: Colors.white),
                            onPressed: () {},
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(50),
                    ),
                    SizedBox(width: 10),
                    CustomButtonComponent(
                      icon: Icon(Icons.map, size: 30, color: Colors.white),
                      onPressed: () {
                        controller.selectedBasemap.value = '';
                        FunctionHelper.showDialog(
                          context,
                          height: 400,
                          title: 'Basemap',
                          footer: Obx(() {
                            final selectedBasemap =
                                controller.selectedBasemap.value;
                            if (selectedBasemap == 'online') {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomButtonComponent(
                                        icon: Icon(
                                          Icons.save,
                                          color: Colors.white,
                                        ),
                                        title: 'Simpan',
                                        onPressed: () {},
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: CustomButtonComponent(
                                        icon: Icon(
                                          Icons.download,
                                          color: Colors.white,
                                        ),
                                        title: 'Unduh',
                                        onPressed: () {
                                          Get.toNamed(Routes.UNDUH_BASEMAP);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (selectedBasemap == 'offline') {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 20,
                                ),
                                child: CustomButtonComponent(
                                  width: double.infinity,

                                  icon: Icon(Icons.upload, color: Colors.white),
                                  title: 'Upload',
                                  onPressed: () {},
                                ),
                              );
                            }
                            return SizedBox();
                          }),
                          content: StatefulBuilder(
                            builder: (context, setState) {
                              return Obx(
                                () => Column(
                                  children: [
                                    CustomTextComponent(
                                      hint: 'Pilih Basemap',
                                      type: InputComponentType.dropdown,
                                      dropdownValue:
                                          controller.selectedBasemap.value == ''
                                          ? null
                                          : controller.selectedBasemap.value,
                                      dropdownItems: [
                                        DropdownMenuItem(
                                          value: 'online',
                                          child: Text('Online'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'offline',
                                          child: Text('Offline'),
                                        ),
                                      ],
                                      onDropdownChanged: (value) {
                                        controller.selectedBasemap.value =
                                            value!;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    if (controller.selectedBasemap.value ==
                                        'online')
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          LabeledDivider(
                                            label: 'Basemap Online',
                                          ),
                                          SizedBox(height: 10),

                                          CustomTextComponent(
                                            labelText: 'Basemap Type',
                                            hint: 'Pilih Basemap',
                                            type: InputComponentType.dropdown,

                                            dropdownItems: [
                                              DropdownMenuItem(
                                                value: 'esri',
                                                child: Text('Esri Imagery'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'bing',
                                                child: Text('Bing'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'foto_udara',
                                                child: Text('Foto Udara'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'citra_satelit',
                                                child: Text('Citra Satelit'),
                                              ),
                                            ],
                                            onDropdownChanged: (value) {},
                                          ),
                                          SizedBox(height: 10),
                                          CustomTextComponent(
                                            labelText: 'Unduh Basemap',
                                            hint: 'Unduh Basemap',
                                            type: InputComponentType.dropdown,

                                            dropdownItems: [
                                              DropdownMenuItem(
                                                value: 'aoi',
                                                child: Text('Area Of Interest'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'batas_wilayah',
                                                child: Text('Batas Wilayah'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'current_view',
                                                child: Text('Current View'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'data_kml',
                                                child: Text('Data KML/KMZ/SHP'),
                                              ),
                                            ],
                                            onDropdownChanged: (value) {},
                                          ),
                                        ],
                                      ),
                                    if (controller.selectedBasemap.value ==
                                        'offline')
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          LabeledDivider(
                                            label: 'Unggah Basemap Offline',
                                          ),
                                          SizedBox(height: 10),
                                          CustomFilePickerComponent(
                                            onChange: (val) {
                                              print(val);
                                            },
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            right: 10,
            child: CustomButtonComponent(
              icon: Icon(Icons.gps_fixed, size: 30, color: Colors.white),
              borderRadius: BorderRadius.circular(50),
              onPressed: () async {
                await controller.initLocation();
              },
            ),
          ),

          // Obx(
          //   () => (controller.isRekamToponim.value)
          //       ? Align(
          //           alignment: Alignment.center,
          //           child: Icon(
          //             FontAwesomeIcons.mapPin,
          //             color: Colors.amberAccent,
          //             size: 44,
          //           ),
          //         )
          //       : SizedBox.shrink(),
          // ),
          Obx(
            () => (controller.isRekamToponim.value)
                ? Positioned(
                    top: -260,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: infoPopup(), // lihat fungsi di bawah
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const Center(child: Text("Home Screen")),
      const Center(child: Text("Search Screen")),
      const Center(child: Text("Profile Screen")),
      const Center(child: Text("Profile Screen")),
      const Center(child: Text("Profile Screen")),
    ];
  }

  Widget infoPopup() {
    return Obx(() {
      if (controller.currentCenter.value == null) return const SizedBox();
      return PopupWithArrow(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Koordinat: "
                  "${controller.currentCenter.value!.latitude.toStringAsFixed(6)}, "
                  "${controller.currentCenter.value!.longitude.toStringAsFixed(6)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),

                // 🔄 Jika loading alamat
                if (controller.isLoadingAddress.value)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),

                // 📍 Menampilkan alamat jika sudah ada
                if (controller.address.value != null &&
                    !controller.isLoadingAddress.value) ...[
                  Text(
                    "Provinsi: ${controller.address.value!.provinsi ?? '-'}",
                  ),
                  Text("Kota/Kab: ${controller.address.value!.kota ?? '-'}"),
                  Text("Kec: ${controller.address.value!.kecamatan ?? '-'}"),
                  Text(
                    "Kel/Desa: ${controller.address.value!.kelurahan ?? '-'}",
                  ),
                ],

                const SizedBox(height: 6),
                CustomButtonComponent(
                  width: double.infinity,
                  onPressed: () async {
                    var result = await Get.toNamed(
                      Routes.TOPONIM,
                      arguments: {
                        'koordinat': {
                          'lat': controller.currentCenter.value!.latitude,
                          'lng': controller.currentCenter.value!.longitude,
                        },
                        'heading': controller.heading.value, // ambil snapshot
                        ...controller.dataMap,
                      },
                    );
                    if (result != null && result) {
                      controller.getAllQueue();
                    }
                  },
                  title: 'Lengkapi Data',
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
