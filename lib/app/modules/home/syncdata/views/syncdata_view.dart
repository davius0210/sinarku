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
        title: const Text('Daftar Data Toponim'),
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
                  _pageDaftarData(),
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

  Widget _pageDaftarData() {
    return Column(
      children: [
        _buildSummaryCards(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Activities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.filter_list, color: Colors.blueAccent),
            ],
          ),
        ),
        Expanded(child: _buildSyncTable()),
      ],
    );
  }

  // Header Summary (Statistik singkat)
  Widget _buildSummaryCards() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _infoCard("Total", "128", Colors.blueAccent),
          _infoCard("Pending", "12", Colors.orangeAccent),
          _infoCard("Synced", "116", Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _infoCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Main List / Table
  Widget _buildSyncTable() {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemBuilder: (context, index) {
        bool isSynced = index % 3 == 0; // Simulasi status
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Method
              Icon(Icons.location_on, color: Colors.blue),
              const SizedBox(width: 15),
              // Endpoint & Payload Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Data Toponim $index",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Type: LocationData • 12 Dec, 14:20",
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ),
              ),
              // Status Badge
              _statusBadge(isSynced),
            ],
          ),
        );
      },
    );
  }

  Widget _statusBadge(bool synced) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: synced
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            synced ? Icons.check_circle : Icons.sync,
            size: 14,
            color: synced ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 5),
          Text(
            synced ? "Synced" : "Pending",
            style: TextStyle(
              color: synced ? Colors.green : Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
