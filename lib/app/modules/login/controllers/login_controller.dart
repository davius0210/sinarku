import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinarku/data/apps_repository.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  final isLoading = false.obs;

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        final response = await AppRepository().login(
          emailC.text,
          passwordC.text,
        );

        if (response.statusCode == 200) {
          print(response.data);
          // 1. Ambil token dari response (Sesuaikan dengan struktur API Anda)
          String token = response.data['token'];
          // 2. Simpan token ke storage permanen
          final sharedPreferences = await SharedPreferences.getInstance();
          await sharedPreferences.setString('token', token);
          await sharedPreferences.setString(
            'session',
            json.encode(response.data['data']),
          );
          Get.offAllNamed('/home');
          Get.snackbar(
            'Sukses',
            'Selamat Datang!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } on dio.DioException catch (e) {
        if (e.response?.statusCode == 401) {
          Get.snackbar(
            'Gagal',
            'Username/Password salah',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          List<String> allMessages = [];
          e.response?.data['data']['errors'].forEach((field, messages) {
            if (messages is List) {
              allMessages.add(messages.join(', '));
            }
          });
          Get.snackbar('Error', allMessages.join(', '));
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
