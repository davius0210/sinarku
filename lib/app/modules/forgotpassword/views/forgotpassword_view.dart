import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sinarku/components/custom_button_component.dart';
import 'package:sinarku/components/custom_text_component.dart';
import 'package:sinarku/components/label_syaratdanketentuan_component.dart';
import 'package:sinarku/helper/colors_helper.dart';

import '../controllers/forgotpassword_controller.dart';

class ForgotpasswordView extends GetView<ForgotpasswordController> {
  const ForgotpasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              children: [
                Image(
                  image: AssetImage('assets/images/sinarku-logo-color.png'),
                  height: MediaQuery.of(context).size.width / 1.5,
                ),
                SizedBox(height: 50),
                CustomTextComponent(
                  hint: 'Email',
                  icon: Icon(CupertinoIcons.person, color: ColorsHelper.hint),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Get.offNamed('/login');
                    },
                    child: Text(
                      '← Kembali ke Halaman Utama',
                      style: TextStyle(color: ColorsHelper.blue),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CustomButtonComponent(
                  title: 'Kirim',
                  onPressed: () async {
                    await Future.delayed(Duration(seconds: 10));
                  },
                ),
              ],
            ),
          ),
          LabelSyaratdanketentuanComponent(),
        ],
      ),
    );
  }
}
