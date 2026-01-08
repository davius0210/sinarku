import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinarku/data/apps_repository.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final usernameC = TextEditingController();
  final emailC = TextEditingController();
  final whatsappC = TextEditingController();
  final organizationC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();

  final userType = RxnString();
  final userTypes = ['Pengguna Umum', 'Peserta Pelatihan'];

  @override
  void onClose() {
    nameC.dispose();
    usernameC.dispose();
    emailC.dispose();
    whatsappC.dispose();
    organizationC.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }

  var isLoading = false.obs; // Tambahkan loading state

  void registerHandler() async {
    if (!formKey.currentState!.validate()) return;

    if (userType.value == null) {
      Get.snackbar('Perhatian', 'Silakan pilih Jenis Pengguna');
      return;
    }

    try {
      isLoading.value = true;

      final response = await AppRepository().register(
        name: nameC.text,
        email: emailC.text,
        password: passwordC.text,
        passwordConfirmation: confirmPasswordC.text,
        phone: whatsappC.text,
        org_id: 1, // Pastikan ini sesuai kebutuhan backend
      );
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          'Sukses',
          'Pendaftaran berhasil, silakan login',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } on dio.DioException catch (e) {
      // Menangani Error 422 dan pesan dari server
      if (e.response?.statusCode == 422) {
        final Map<String, dynamic> errors = e.response?.data['errors'] ?? {};
        // Ambil pesan error pertama yang ada
        String errorMessage = errors.values.isNotEmpty
            ? errors.values.first[0]
            : "Data yang dimasukkan tidak valid";

        Get.snackbar(
          'Gagal Daftar',
          errorMessage,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', 'Terjadi kesalahan sistem: ${e.message}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan tidak terduga');
    } finally {
      isLoading.value = false;
    }
  }
}
