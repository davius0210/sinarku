import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sinarku/helper/custom_toast_helper.dart';
import 'package:sinarku/helper/network_helper.dart';

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
  final networkHelper = NetworkHelper();
  final RxDouble heading = 0.0.obs;
  StreamSubscription? _compassSub;
  final isOnline = false.obs;
  final isProses = false.obs;
  final count = 0.obs;
  late PersistentTabController tabController;
  var selectedBasemap = ''.obs;
  MapController mapController = MapController();
  Rxn<LatLng> currentCenter = Rxn<LatLng>();
  Rxn<LatLng> currentLocation = Rxn<LatLng>();
  final RxBool isLoadingLocation = true.obs;
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
    final dio = Dio(
      BaseOptions(
        headers: {'User-Agent': 'MyFlutterApp/1.0 (contact: your@email.com)'},
      ),
    );

    final response = await dio.get(url);
    final data = response.data["address"];

    address.value = LocationAddress.fromJson(data);
    dataMap.value = response.data;
    isLoadingAddress.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    tabController = PersistentTabController(initialIndex: 0);
    _compassSub = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        heading.value = event.heading!;
      }
    });
    networkHelper.startMonitoring((status) {
      isOnline.value = status;
      print('📡 Status koneksi: ${status ? 'Online' : 'Offline'}');
    });
    initLocation();
  }

  Future<void> initLocation() async {
    isLoadingLocation.value = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLoadingLocation.value = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      isLoadingLocation.value = false;
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentCenter.value = LatLng(position.latitude, position.longitude);
    currentLocation.value = LatLng(position.latitude, position.longitude);

    mapController.move(currentCenter.value!, 17);

    isLoadingLocation.value = false;
    fetchLocationInfo(currentCenter.value!);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _compassSub?.cancel();
    super.onClose();
  }

  void increment() => count.value++;
}
