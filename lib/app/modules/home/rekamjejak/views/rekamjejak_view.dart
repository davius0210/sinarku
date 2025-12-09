import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sinarku/components/empty_component.dart';

import '../controllers/rekamjejak_controller.dart';

class RekamjejakView extends GetView<RekamjejakController> {
  const RekamjejakView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rekam Jejak'), centerTitle: true),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade200,
              child: const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xff024A7E),
                indicatorWeight: 3,
                tabs: [
                  Tab(text: "Rekam Jejak"),
                  Tab(text: "Daftar Jejak"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: CustomEmptyWidget(title: 'Data Tidak Tersedia'),
                  ),
                  Center(
                    child: CustomEmptyWidget(title: 'Data Tidak Tersedia'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
