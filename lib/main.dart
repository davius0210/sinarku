import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sinarku/helper/colors_helper.dart';
import 'package:sinarku/helper/constant_helper.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: ConstantHelper.title_apps,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
        primaryColorLight: ColorsHelper.primary
      ),
    ),
  );
}
