import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinarku/data/api_helper.dart';
import 'package:sinarku/data/apps_repository.dart';
import 'package:sinarku/data/dio_client.dart';

class SyncdataController extends GetxController {
  //TODO: Implement SyncdataController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Rx<List<Map<String, dynamic>>> dataToponym = Rx<List<Map<String, dynamic>>>(
    [],
  );
  fetchToponymData() async {
    final result = await DioClient().dio.get(
      ApiHelper.api['toponym'].toString(),
      queryParameters: {
        'search': '',
        'limit': 10,
        'offset': 0,
        'sort_by': 'created_at',
        'sort_order': 'desc',
      },
    );

    if (result.data['data'] != null) {
      // Casting dari List<dynamic> ke List<Map<String, dynamic>>
      dataToponym.value = List<Map<String, dynamic>>.from(result.data['data']);
    }
  }

  void increment() => count.value++;
}
