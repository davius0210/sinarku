import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sinarku/components/custom_button_component.dart';
import 'package:sinarku/components/custom_signin_sosmed_component.dart';
import 'package:sinarku/components/custom_text_component.dart';
import 'package:sinarku/components/label_divider_component.dart';
import 'package:sinarku/components/label_syaratdanketentuan_component.dart';
import 'package:sinarku/helper/colors_helper.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Akun')),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: controller.formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                children: [
                  Image(
                    image: const AssetImage(
                      'assets/images/sinarku-logo-color.png',
                    ),
                    height:
                        MediaQuery.of(context).size.width /
                        3.5, // Reduced height as per focus on form
                  ),
                  const SizedBox(height: 20),
                  // Dropdown: Pilih Jenis Pengguna
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.userType.value,
                      items: controller.userTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        controller.userType.value = newValue;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jenis pengguna harus dipilih';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Pilih Jenis Pengguna',
                        hintStyle: TextStyle(color: ColorsHelper.hint),
                        prefixIcon: Icon(Icons.list, color: ColorsHelper.hint),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: ColorsHelper.border,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: ColorsHelper.border,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: ColorsHelper.border),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: ColorsHelper.hint,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nama *
                  CustomTextComponent(
                    controller: controller.nameC,
                    hint: 'Nama *',
                    icon: Icon(CupertinoIcons.person, color: ColorsHelper.hint),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Nama wajib diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Username *
                  CustomTextComponent(
                    controller: controller.usernameC,
                    hint: 'Username *',
                    icon: Icon(CupertinoIcons.person, color: ColorsHelper.hint),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Username wajib diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Email *
                  CustomTextComponent(
                    controller: controller.emailC,
                    hint: 'Email *',
                    icon: Icon(CupertinoIcons.mail, color: ColorsHelper.hint),
                    keyboardType: TextInputType.emailAddress,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!value.contains('@')) {
                        return 'Format email salah';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Nomor WhatsApp *
                  CustomTextComponent(
                    controller: controller.whatsappC,
                    hint: 'Nomor WhatsApp *',
                    icon: Icon(CupertinoIcons.phone, color: ColorsHelper.hint),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor WhatsApp tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Nama Organisasi
                  CustomTextComponent(
                    controller: controller.organizationC,
                    hint: 'Nama Organisasi',
                    icon: Icon(CupertinoIcons.group, color: ColorsHelper.hint),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),

                  // Kata Sandi *
                  CustomTextComponent(
                    controller: controller.passwordC,
                    hint: 'Kata Sandi *',
                    isPassword: true,
                    icon: Icon(CupertinoIcons.lock, color: ColorsHelper.hint),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.length < 8)
                        return 'Password minimal 8 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Konfirmasi Kata Sandi * (Assuming no prefix icon based on image observation)
                  CustomTextComponent(
                    controller: controller.confirmPasswordC,
                    hint: 'Konfirmasi Kata Sandi *',
                    isPassword: true,

                    icon: null,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value != controller.passwordC.text)
                        return 'Konfirmasi password tidak cocok';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomButtonComponent(
                    title: 'Daftar',
                    icon: const Icon(Icons.person_add, color: Colors.white),
                    onPressed: () async {
                      controller.registerHandler();
                    },
                  ),
                  SizedBox(height: 20),
                  LabeledDivider(label: 'ATAU'),
                  SizedBox(height: 10),
                  if (Platform.isIOS)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: SocialMediaButton(
                        ButtonsSocialMedia.Apple,
                        text: "Masuk dengan Apple",
                        onPressed: () {},
                      ),
                    ),

                  SocialMediaButton(
                    ButtonsSocialMedia.Google,
                    text: "Masuk dengan Google",
                    onPressed: () {},
                  ),
                  SizedBox(height: 10),
                  SocialMediaButton(
                    ButtonsSocialMedia.Facebook,
                    text: "Masuk dengan Facebook",
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          LabelSyaratdanketentuanComponent(),
        ],
      ),
    );
  }
}
