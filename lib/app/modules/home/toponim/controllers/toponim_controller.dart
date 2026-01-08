import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinarku/data/api_helper.dart';
import 'package:sinarku/data/apps_repository.dart';
import 'package:sinarku/data/dio_client.dart';
import 'package:sinarku/helper/custom_toast_helper.dart';
import 'package:sinarku/helper/function_helper.dart';
import 'package:sinarku/helper/loading_helper.dart';
import 'package:sinarku/helper/sync_helper.dart';

class _LatLng {
  final double lat;
  final double lng;
  _LatLng(this.lat, this.lng);
}

_LatLng _parseKoordinat(String s) {
  // contoh: "-7.12356, 120.22345"
  final parts = s.split(',');
  if (parts.length < 2) return _LatLng(0, 0);

  final lat = double.tryParse(parts[0].trim()) ?? 0;
  final lng = double.tryParse(parts[1].trim()) ?? 0;
  return _LatLng(lat, lng);
}

String _formatDateYYYYMMDD(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return "$y-$m-$d";
}

class ToponimController extends GetxController {
  // 📍 Data lokasi
  RxString koordinat = "-7.12356, 120.22345".obs;
  RxString arahFoto = "67.21°".obs;
  RxString provinsi = "Jawa Barat".obs;
  RxString kota = "Bogor".obs;
  RxString kecamatan = "Cibinong".obs;
  RxString desa = "Pabuarang".obs;

  // 🎞 Foto
  Rx<List<String>> listImage = Rx<List<String>>([]);

  // 🔽 Dropdown Values
  RxString? jenisUnsur = RxString("");
  RxString? elemenGenerik = RxString("");
  RxString? elemenSpesifik = RxString("");

  // Controllers text
  TextEditingController idRupabumi = TextEditingController();
  TextEditingController namaSpesifik = TextEditingController();
  TextEditingController namaLain = TextEditingController();
  TextEditingController namaSebelumnya = TextEditingController();
  TextEditingController asalBahasa = TextEditingController();

  //
  final TextEditingController localName = TextEditingController();
  final TextEditingController mapName = TextEditingController();
  final TextEditingController otherName = TextEditingController();
  final TextEditingController languageOrigin = TextEditingController();
  final TextEditingController nameMeaning = TextEditingController();
  final TextEditingController nameHistory = TextEditingController();
  final TextEditingController pronounciation = TextEditingController();
  final TextEditingController spelling = TextEditingController();
  Rx<Map<String, dynamic>> selectElement = Rx<Map<String, dynamic>>({});
  // Element code (kalau dari dropdown: simpan ke RxString)
  RxString elementCode = "".obs;

  // Tanggal survey
  Rxn<DateTime> surveyAt = Rxn<DateTime>();

  // END
  Future<Map<String, dynamic>> toPayload() async {
    final provinceCode = selectProvince.value['id']?.toString();
    final regencyCode = selectKabupaten.value['id']?.toString();
    final districtCode = selectKecamatan.value['id']?.toString();
    final villageCode = selectKelurahan.value['id']?.toString();
    koordinat.value =
        "${Get.arguments['koordinat']['lat']}, ${Get.arguments['koordinat']['lng']}";
    final coords = _parseKoordinat(koordinat.value);
    // GeoJSON: [lng, lat]
    final geometry = {
      "type": "Point",
      "coordinates": [coords.lat, coords.lng],
    };

    // Gunakan Future.wait untuk menunggu semua proses async di dalam list

    List<Map<String, dynamic>> photos = [];
    for (var i = 0; i < listImage.value.length; i++) {
      try {
        final result = await AppRepository().uploadPhoto(listImage.value[i]);
        if (result.statusCode == 200) {
          print("Upload Success: ${result.data}");
          photos.add({
            "url": result.data['data']['url'],
            "filename": result.data['data']['filename'],
          });
        }
      } catch (e) {
        print("Error uploading ${listImage.value[i]}: $e");
      }
    }

    return {
      "local_name": localName.text.trim(),
      "map_name": mapName.text.trim(),
      "other_name": otherName.text.trim(),
      "language_origin": languageOrigin.text.trim(),
      "name_meaning": nameMeaning.text.trim(),
      "name_history": nameHistory.text.trim(),
      "pronounciation": pronounciation.text.trim(),
      "spelling": spelling.text.trim(),
      "element_id": selectElement.value['code'],
      "province_code": selectProvince.value['code'],
      // "province_data": selectProvince.value,
      "regency_code": selectKabupaten.value['code'],
      // "regency_data": selectKabupaten.value,
      "district_code": selectKecamatan.value['code'],
      // "district_data": selectKecamatan.value,
      "village_code": selectKelurahan.value['code'],
      // "village_data": selectKelurahan.value,
      "survey_at": _formatDateYYYYMMDD(surveyAt.value ?? DateTime.now()),
      "photos": photos,
      "geometry_type": "POINT",
      "geometry": geometry,
    };
  }

  Future<void> simpanData(BuildContext context) async {
    // Validasi minimal (sesuaikan kebutuhanmu)
    if (listImage.value.isEmpty) {
      ToastHelper.show(
        context,
        message: "Harap tambahkan gambar",
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return;
    }

    if (localName.text.trim().isEmpty) {
      ToastHelper.show(
        context,
        message: "Harap isi Local Name",
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return;
    }

    if (selectElement.value.isEmpty) {
      ToastHelper.show(
        context,
        message: "Harap pilih Element",
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return;
    }

    // // Pastikan dropdown wilayah sudah kepilih (code ada)
    // if ((selectProvince.value['id'] ?? "").toString().isEmpty ||
    //     (selectKabupaten.value['id'] ?? "").toString().isEmpty ||
    //     (selectKecamatan.value['id'] ?? "").toString().isEmpty) {
    //   ToastHelper.show(
    //     context,
    //     message: "Harap lengkapi wilayah (Prov/Kab/Kec/Kel)",
    //     icon: const Icon(Icons.error, color: Colors.red),
    //   );
    //   return;
    // }

    // Optional: update tampilan alamat (kalau masih dipakai di UI)
    provinsi.value = selectProvince.value['name']?.toString() ?? provinsi.value;
    kota.value = selectKabupaten.value['name']?.toString() ?? kota.value;
    kecamatan.value =
        selectKecamatan.value['name']?.toString() ?? kecamatan.value;
    desa.value = selectKelurahan.value['name']?.toString() ?? desa.value;

    isEditing.value = false;

    final dataJson = await toPayload();

    final result = await DioClient().dio.post(
      ApiHelper.api['toponym'].toString(),
      data: dataJson,
    );
    log(result.data.toString());
    // final result = await LocalSyncDB.instance.insertQueue(
    //   SyncItem(
    //     endpoint: ApiHelper.api['toponym'].toString(),
    //     method: "POST",
    //     payload: dataJson, // ✅ penting: simpan payload JSON
    //     type: SyncType.toponim,
    //     createdAt: DateTime.now().toIso8601String(),
    //   ),
    // );

    // await SyncService(DioClient().dio).syncPending();

    if (result.statusCode == 201) {
      Get.back(result: true);
      ToastHelper.show(
        context,
        message: "Data berhasil disimpan",
        icon: const Icon(Icons.check, color: Colors.green),
      );
    } else {
      print(result.statusCode);
      ToastHelper.show(
        context,
        message: "Data gagal disimpan",
        icon: const Icon(Icons.error, color: Colors.red),
      );
    }
  }

  final RxBool isEditing = false.obs;
  final TextEditingController provinsiController = TextEditingController();
  final TextEditingController kabupatenController = TextEditingController();
  final TextEditingController kecamatanController = TextEditingController();
  final TextEditingController desaController = TextEditingController();
  Map<String, dynamic> toJson() {
    return {
      "koordinat": Get.arguments['koordinat'],
      "arah_foto": arahFoto.value,
      "alamat": {
        "provinsi": provinsi.value,
        "kabupaten_kota": kota.value,
        "kecamatan": kecamatan.value,
        "desa_kelurahan": desa.value,
      },
      "unsur": {
        "jenis_unsur": jenisUnsur?.value,
        "elemen_generik": elemenGenerik?.value,
        "elemen_spesifik": elemenSpesifik?.value,
      },
      "data_rupabumi": {
        "id_rupabumi": idRupabumi.text,
        "nama_spesifik": namaSpesifik.text,
        "nama_lain": namaLain.text,
        "nama_sebelumnya": namaSebelumnya.text,
        "asal_bahasa": asalBahasa.text,
      },
      "images": listImage.value, // List path gambar
    };
  }

  Future<void> saveData(BuildContext context) async {
    // await LocalSyncDB.instance.deleteAllQueue();
    // return;
    // 1. Update RxString dari Controller Text (Inputan User)
    if (listImage.value.isEmpty) {
      ToastHelper.show(
        context,
        message: "Harap tambahkan gambar",
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return;
    }
    if (idRupabumi.text.isEmpty) {
      ToastHelper.show(
        context,
        message: "Harap tambahkan ID Rupabumi",
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return;
    }
    if (jenisUnsur!.value.isEmpty) {
      ToastHelper.show(
        context,
        message: "Harap tambahkan Jenis Unsur",
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return;
    }
    if (elemenGenerik!.value.isEmpty) {
      ToastHelper.show(
        context,
        message: "Harap tambahkan Elemen Generik",
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return;
    }
    if (elemenSpesifik!.value.isEmpty) {
      ToastHelper.show(
        context,
        message: "Harap tambahkan Elemen Spesifik",
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return;
    }

    provinsi.value = selectProvince.value['name'];
    kota.value = selectKabupaten.value['name'];
    kecamatan.value = selectKecamatan.value['name'];
    desa.value = selectKelurahan.value['name'];

    // 2. Matikan mode editing
    isEditing.value = false;

    // 3. Konversi ke JSON
    Map<String, dynamic> dataJson = toJson();

    // Debugging untuk melihat hasil di console
    // print("Data JSON: ${dataJson.toString()}");

    final result = await LocalSyncDB.instance.insertQueue(
      SyncItem(
        endpoint: ApiHelper.api['toponym'].toString(),
        method: "POST",
        payload: dataJson,
        type: SyncType.toponim,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    await SyncService(DioClient().dio).syncPending();

    if (result != 0) {
      Get.back(result: true);
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
  }

  void initializeControllers(var address) {
    koordinat.value =
        "${address['koordinat']['lat']}, ${address['koordinat']['lng']}";
    provinsiController.text =
        (address['address']['province'] ?? address['address']['state']) ?? '';
    kabupatenController.text =
        (address['address']['city'] ??
            address['address']['town'] ??
            address['address']['village'] ??
            address['address']['municipality']) ??
        '';
    kecamatanController.text =
        (address['address']['borough'] ??
            address['address']['county'] ??
            address['address']['district']) ??
        '';
    desaController.text =
        (address['address']['suburb'] ??
            address['address']['neighbourhood'] ??
            address['address']['residential']) ??
        '';
  }

  Rx<Map<String, dynamic>> selectProvince = Rx<Map<String, dynamic>>({});
  Rx<Map<String, dynamic>> selectKabupaten = Rx<Map<String, dynamic>>({});
  Rx<Map<String, dynamic>> selectKecamatan = Rx<Map<String, dynamic>>({});
  Rx<Map<String, dynamic>> selectKelurahan = Rx<Map<String, dynamic>>({});
  Future<List<dynamic>> fetchProvince(String search, String level) async {
    final response = await DioClient().dio.get(
      ApiHelper.api['region'].toString(),
      queryParameters: {
        'level': level,
        'search': search,
        'sort_by': 'created_at',
        'sort_order': 'asc',
        'limit': 10,
        'parent': 1,
      },
    );
    print(response.data);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];

      return data;
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<List<dynamic>> fetchElement(String search) async {
    final response = await DioClient().dio.get(
      ApiHelper.api['toponym-classification-element'].toString(),
      queryParameters: {
        'search': search,
        'sort_by': 'created_at',
        'sort_order': 'asc',
        'limit': 10,
      },
    );
    print(response.data);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];

      return data;
    } else {
      throw Exception('Failed to load customers');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // initializeControllers(Get.arguments);
  }
}
