import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:get/get.dart';
import 'package:sinarku/components/custom_button_component.dart';
import 'package:sinarku/components/custom_signin_sosmed_component.dart';
import 'package:sinarku/components/custom_text_component.dart';
import 'package:sinarku/components/label_divider_component.dart';
import 'package:sinarku/helper/colors_helper.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: ListView(
        padding: EdgeInsets.fromLTRB(20,10,20,10),
        children: [
          Image(image: AssetImage('assets/images/sinarku-logo-color.png'),height: MediaQuery.of(context).size.width/1.5,),
          SizedBox(height: 10,),
          CustomTextComponent(
            hint: 'Email/Username',
            icon: Icon(CupertinoIcons.person, color: ColorsHelper.hint,),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10,),
          CustomTextComponent(
            hint: 'Password',
            isPassword: true,
            icon: Icon(CupertinoIcons.lock, color: ColorsHelper.hint,),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10,),
          CustomButtonComponent(
            title: 'Masuk',
            icon: Icon(Icons.login, color: Colors.white,),
            onPressed: ()async{
              await Future.delayed(Duration(seconds: 10));
            },
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lupa kata kunci?'),
              TextButton(onPressed: (){

              }, child: Text('Klik Disini', style: TextStyle(color: ColorsHelper.blue),))
            ],
          ),
          
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tidak Punya Akun?'),
              TextButton(onPressed: (){

              }, child: Text('Daftar Akun', style: TextStyle(color: ColorsHelper.blue),))
            ],
          ),
          LabeledDivider(label: 'ATAU',),
          SocialMediaButton(
            ButtonsSocialMedia.Apple,
            text: "Masuk dengan Apple",
            onPressed: () {},
          ),
          SizedBox(height: 10,),
          SocialMediaButton(
            ButtonsSocialMedia.Google,
            text: "Masuk dengan Google",
            onPressed: () {},
          ),
          SizedBox(height: 10,),
          SocialMediaButton(
            ButtonsSocialMedia.WhatsApp,
            text: "Masuk dengan Whatsapp",
            onPressed: () {},
          ),
          SizedBox(height: 30,),
          RichText(text: TextSpan(
            children: [
              TextSpan(text: 'Dengan mengklik lanjutan, Anda menyetujui '),
              TextSpan(text: 'Syarat Layanan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),recognizer: TapGestureRecognizer()..onTap=(){

              },),
              TextSpan(text: ' dan '),
              TextSpan(text: 'Kebijakan Privasi Kami.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),recognizer: TapGestureRecognizer()..onTap=(){
                print('tesssssss');
              },),
            ],
            style: TextStyle(color: ColorsHelper.hint),
            
            
          ),textAlign: TextAlign.center,)
         
        ],
      ),
    );
  }
}
