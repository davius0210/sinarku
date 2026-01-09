import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinarku/app/routes/app_pages.dart';
import 'package:sinarku/data/api_helper.dart';
import 'package:sinarku/data/dio_client.dart';
import 'package:sinarku/data/models/user_model.dart';
import 'package:sinarku/helper/custom_toast_helper.dart';
import 'package:sinarku/helper/network_helper.dart';
import 'package:sinarku/helper/sync_helper.dart';

class LocationAddress {
  final String? provinsi;
  final String? kota;
  final String? kecamatan;
  final String? kelurahan;

  LocationAddress({this.provinsi, this.kota, this.kecamatan, this.kelurahan});

  factory LocationAddress.fromJson(Map<String, dynamic> json) {
    return LocationAddress(
      // Tambahkan .toString() atau pengecekan tipe data
      provinsi: (json['region'] is List)
          ? (json['region'] as List).join(", ") // Jika List, gabung jadi String
          : json['region']?.toString() ??
                json["state"]?.toString() ??
                json["province"]?.toString(),

      kota:
          json["city"]?.toString() ??
          json["town"]?.toString() ??
          json["village"]?.toString() ??
          json["municipality"]?.toString(),

      kecamatan:
          json["borough"]?.toString() ??
          json["county"]?.toString() ??
          json["district"]?.toString(),

      kelurahan:
          json["suburb"]?.toString() ??
          json["neighbourhood"]?.toString() ??
          json["residential"]?.toString(),
    );
  }
}

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final networkHelper = NetworkHelper();
  final RxDouble heading = 0.0.obs;
  final RxDouble CurrentHeading = 0.0.obs;
  StreamSubscription? _compassSub;
  final isOnline = false.obs;
  final isProses = false.obs;
  final count = 0.obs;
  late PersistentTabController tabController;
  var selectedBasemap = ''.obs;
  MapController mapController = MapController();
  Rxn<LatLng> currentCenter = Rxn<LatLng>();
  Rxn<LatLng> currentLocation = Rxn<LatLng>();
  Rxn<LatLng> currentToponym = Rxn<LatLng>();
  Rxn<Position> currentPosition = Rxn<Position>();
  final RxBool isLoadingLocation = true.obs;
  var isRekamToponim = false.obs;
  var dataMap = {}.obs;
  var address = Rxn<LocationAddress>();
  var isLoadingAddress = false.obs;
  Rxn<UserModel> user = Rxn();
  Rx<List<Map<String, dynamic>>> queueMap = Rx([]);
  void updateCenterInfo() {
    currentCenter.value = mapController.camera.center;
  }

  void getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('session');
    log(userJson.toString());
    if (userJson != null) {
      user.value = UserModel.fromJson(json.decode(userJson));
    }
    print('user ${user.value}');
  }

  void logout() async {
    try {
      // 1. (Opsional) Panggil API Logout ke server
      // await AppRepository().logout();

      // 2. Hapus token dari memori HP
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('session');

      // 3. Kembali ke login dan hapus semua history route
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout');
    }
  }

  getAllQueue() async {
    // final result = await LocalSyncDB.instance.getAllQueue(SyncType.toponim);
    // for (var element in result) {
    //   log(element['payload'].toString());
    // }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    final result = await DioClient().dio.get(
      ApiHelper.api['toponym/nearby'].toString(),
      queryParameters: {
        'lat': position.latitude,
        'lng': position.longitude,
        'radius': 500000,
      },
    );
    log(result.data.toString());
    if (result.data['data'] != null) {
      // Casting dari List<dynamic> ke List<Map<String, dynamic>>
      queueMap.value = (result.data['data']['results'] as List)
          .cast<Map<String, dynamic>>();
    }
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
    // Check dari server
    if (data != null) {
      final responseServer = await DioClient().dio.get(
        ApiHelper.api['region'].toString(),
        queryParameters: {
          'level': 'CITY',
          'search': data['city'],
          'sort_by': 'created_at',
          'sort_order': 'asc',
          'limit': 10,
          'parent': 1,
        },
      );
      if (responseServer.data['data'].isNotEmpty) {}
    }
    print(data);
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
    print('tesssssss');
    initLocation();
    getAllQueue();
    getUser();
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
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    currentCenter.value = LatLng(position.latitude, position.longitude);
    currentLocation.value = LatLng(position.latitude, position.longitude);
    currentPosition.value = position;

    isLoadingLocation.value = false;
    fetchLocationInfo(currentCenter.value!);
    getAllQueue();
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      ),
    ).listen((Position position) {
      CurrentHeading.value = position.heading;
      currentCenter.value = LatLng(position.latitude, position.longitude);
      currentLocation.value = LatLng(position.latitude, position.longitude);
      currentPosition.value = position;
    });
    mapController.move(currentCenter.value!, 17);
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
