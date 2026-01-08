import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:get/get.dart';
import 'package:sinarku/app/routes/app_pages.dart';
import 'package:sinarku/components/custom_button_component.dart';
import 'package:sinarku/components/custom_signin_sosmed_component.dart';
import 'package:sinarku/components/custom_text_component.dart';
import 'package:sinarku/components/label_divider_component.dart';
import 'package:sinarku/components/label_syaratdanketentuan_component.dart';
import 'package:sinarku/helper/colors_helper.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: controller.formKey,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  children: [
                    Image(
                      image: AssetImage('assets/images/sinarku-logo-color.png'),
                      height: MediaQuery.of(context).size.width / 1.5,
                    ),
                    SizedBox(height: 10),
                    CustomTextComponent(
                      controller: controller.emailC,
                      hint: 'Email/Username',
                      icon: Icon(
                        CupertinoIcons.person,
                        color: ColorsHelper.hint,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Email wajib diisi';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    CustomTextComponent(
                      controller: controller.passwordC,
                      hint: 'Password',
                      isPassword: true,
                      icon: Icon(CupertinoIcons.lock, color: ColorsHelper.hint),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Password wajib diisi';
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomButtonComponent(
                      title: 'Masuk',
                      icon: Icon(Icons.login, color: Colors.white),
                      onPressed: () async => controller.login(),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Lupa kata kunci?'),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/forgotpassword');
                          },
                          child: Text(
                            'Klik Disini',
                            style: TextStyle(color: ColorsHelper.blue),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tidak Punya Akun?'),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/signup');
                          },
                          child: Text(
                            'Daftar Akun',
                            style: TextStyle(color: ColorsHelper.blue),
                          ),
                        ),
                      ],
                    ),
                    LabeledDivider(label: 'ATAU'),
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
      ),
    );
  }
}
