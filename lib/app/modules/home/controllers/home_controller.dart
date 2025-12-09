import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class LocationAddress {
  final String? provinsi;
  final String? kota;
  final String? kecamatan;
  final String? kelurahan;

  LocationAddress({this.provinsi, this.kota, this.kecamatan, this.kelurahan});

  factory LocationAddress.fromJson(Map<String, dynamic> json) {
    return LocationAddress(
      provinsi: json["state"] ?? json["province"],
      kota:
          json["city"] ??
          json["town"] ??
          json["village"] ??
          json["municipality"],
      kecamatan: json["borough"] ?? json["county"] ?? json["district"],
      kelurahan: json["suburb"] ?? json["neighbourhood"] ?? json["residential"],
    );
  }
}

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  late PersistentTabController tabController;
  var selectedBasemap = ''.obs;
  MapController mapController = MapController();
  Rxn<LatLng> currentCenter = Rxn<LatLng>();
  var isRekamToponim = false.obs;
  var dataMap = {}.obs;
  var address = Rxn<LocationAddress>();
  var isLoadingAddress = false.obs;
  void updateCenterInfo() {
    currentCenter.value = mapController.camera.center;
  }

  Rx<bool> toponimSekitar = Rx(false);
  Rx<bool> toponimHasil = Rx(false);
  Rx<bool> serviceDasar = Rx(false);
  Rx<bool> dataLain = Rx(false);

  Rx<double> valSekitar = Rx(100);
  Rx<double> valHasil = Rx(100);
  Rx<double> valDasar = Rx(100);

  Future<void> fetchLocationInfo(LatLng latLng) async {
    isLoadingAddress.value = true;

    final url =
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}&addressdetails=1";

    final response = await Dio().get(url);
    final data = response.data["address"];

    address.value = LocationAddress.fromJson(data);
    isLoadingAddress.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    tabController = PersistentTabController(initialIndex: 0);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
