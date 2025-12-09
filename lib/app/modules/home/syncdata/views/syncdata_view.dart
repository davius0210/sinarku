import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sinarku/components/empty_component.dart';

import '../controllers/syncdata_controller.dart';

class SyncdataView extends GetView<SyncdataController> {
  const SyncdataView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Pendataan Nama Rupabumi'),
        centerTitle: true,
      ),
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
                  Tab(text: "Daftar Data"),
                  Tab(text: "Sebaran Data"),
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
