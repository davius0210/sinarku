import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
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
}
