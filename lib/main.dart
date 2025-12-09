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
        primaryColorLight: ColorsHelper.primary,
        primaryColor: ColorsHelper.blue,
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStatePropertyAll(Colors.white),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return ColorsHelper.primary; // track saat ON
            }
            return Colors.white; // track saat OFF
          }),
          side: BorderSide(color: ColorsHelper.border),

          overlayColor: WidgetStateProperty.all(Colors.white),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return ColorsHelper.primary; // track saat ON
            }
            return ColorsHelper.disable; // track saat OFF
          }),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorsHelper.primary,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
    ),
  );
}
