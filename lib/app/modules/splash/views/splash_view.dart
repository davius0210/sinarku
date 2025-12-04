import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (_){
      return Scaffold(
        backgroundColor: Colors.white,
        body:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image(image: AssetImage('assets/images/sinarku-logo-color.png'), width: MediaQuery.of(context).size.width/2,),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  CircularProgressIndicator(),
                  SizedBox(width: 10,),
                  Text('Please Wait ...')
                ],
              )
            ],
          ),
        ),
      );
    });
    
  }
}
