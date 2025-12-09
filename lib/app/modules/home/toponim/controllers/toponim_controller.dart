import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToponimController extends GetxController {
  // 📍 Data lokasi
  RxString koordinat = "-7.12356, 120.22345".obs;
  RxString arahFoto = "67.21°".obs;
  RxString provinsi = "Jawa Barat".obs;
  RxString kota = "Bogor".obs;
  RxString kecamatan = "Cibinong".obs;
  RxString desa = "Pabuarang".obs;

  // 🎞 Foto
  RxString imagePreview = "https://picsum.photos/seed/picsum/200/300".obs;

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

  Future<void> simpanData() async {
    await Future.delayed(const Duration(seconds: 1));
    Get.snackbar("Sukses", "Data berhasil disimpan 🎉");
  }
}
