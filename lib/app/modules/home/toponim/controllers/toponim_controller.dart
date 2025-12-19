import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinarku/helper/custom_toast_helper.dart';
import 'package:sinarku/helper/function_helper.dart';
import 'package:sinarku/helper/loading_helper.dart';
import 'package:sinarku/helper/sync_helper.dart';

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

  Future<void> simpanData(BuildContext context) async {
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

    provinsi.value = provinsiController.text;
    kota.value = kabupatenController.text;
    kecamatan.value = kecamatanController.text;
    desa.value = desaController.text;

    // 2. Matikan mode editing
    isEditing.value = false;

    // 3. Konversi ke JSON
    Map<String, dynamic> dataJson = toJson();

    // Debugging untuk melihat hasil di console
    // print("Data JSON: ${dataJson.toString()}");

    final result = await LocalSyncDB.instance.insertQueue(
      SyncItem(
        endpoint: "https://api.sinarku.id/toponim",
        method: "POST",
        payload: dataJson,
        type: SyncType.toponim,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    await Future.delayed(const Duration(seconds: 5));

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

  @override
  void onInit() {
    super.onInit();
    initializeControllers(Get.arguments);
  }
}
