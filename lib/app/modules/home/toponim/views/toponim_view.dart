import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sinarku/components/custom_button_component.dart';
import 'package:sinarku/components/custom_text_component.dart';
import 'package:sinarku/components/image_picker_grid_component.dart';
import 'package:sinarku/helper/colors_helper.dart';

import '../controllers/toponim_controller.dart';

class ToponimView extends GetView<ToponimController> {
  const ToponimView({super.key});
  @override
  Widget build(BuildContext context) {
    final address = Get.arguments;
    print(address);
    return Scaffold(
      appBar: AppBar(title: Text('Rincian Data Nama Rupabumi')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _lokasiCard(address),

                    const SizedBox(height: 16),
                    // _fotoPreview(),
                    ImagePickerGridComponent(),
                    const SizedBox(height: 16),
                    CustomTextComponent(
                      controller: controller.idRupabumi,
                      labelText: "ID Rupabumi *",
                      hint: "AL1RLF007JkmsSERLK",
                    ),
                    const SizedBox(height: 16),

                    CustomTextComponent<String>(
                      labelText: "Jenis Unsur *",
                      type: InputComponentType.dropdown,

                      dropdownItems: [
                        DropdownMenuItem(value: "Pulau", child: Text("Pulau")),
                        DropdownMenuItem(
                          value: "Gunung",
                          child: Text("Gunung"),
                        ),
                      ],
                      onDropdownChanged: (value) =>
                          controller.jenisUnsur?.value = value ?? "",
                    ),
                    const SizedBox(height: 16),

                    CustomTextComponent<String>(
                      labelText: "Elemen Generik *",
                      type: InputComponentType.dropdown,

                      dropdownItems: [
                        DropdownMenuItem(
                          value: "Pantai",
                          child: Text("Pantai"),
                        ),
                        DropdownMenuItem(value: "Danau", child: Text("Danau")),
                      ],
                      onDropdownChanged: (value) =>
                          controller.elemenGenerik?.value = value ?? "",
                    ),
                    const SizedBox(height: 16),

                    CustomTextComponent<String>(
                      labelText: "Elemen Spesifik *",
                      type: InputComponentType.dropdown,
                      icon: const Icon(Icons.location_city),

                      dropdownItems: [
                        DropdownMenuItem(value: "Timur", child: Text("Timur")),
                        DropdownMenuItem(value: "Barat", child: Text("Barat")),
                      ],
                      onDropdownChanged: (value) =>
                          controller.elemenSpesifik?.value = value ?? "",
                    ),

                    const SizedBox(height: 16),
                    CustomTextComponent(
                      controller: controller.namaSpesifik,
                      labelText: "Nama Spesifik",
                    ),
                    const SizedBox(height: 16),

                    CustomTextComponent(
                      controller: controller.namaLain,
                      labelText: "Nama Lain",
                    ),
                    const SizedBox(height: 16),

                    CustomTextComponent(
                      controller: controller.namaSebelumnya,
                      labelText: "Nama Sebelumnya",
                    ),
                    const SizedBox(height: 16),

                    CustomTextComponent(
                      controller: controller.asalBahasa,
                      labelText: "Asal Bahasa",
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButtonComponent(
                width: double.infinity,
                title: "Simpan Data",
                onPressed: () => controller.simpanData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== COMPONENTS ==================== //

  Widget _lokasiCard(var address) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorsHelper.third,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Koordinat: ${address['lat']}, ${address['lon']}"),
          Text("Arah Pengambilan Foto: ${address['heading']} "),
          const SizedBox(height: 4),
          Text(
            "Provinsi: ${(address['address']['province'] ?? address['address']['state']) ?? '-'}",
          ),
          Text(
            "Kabupaten/Kota: ${(address['address']['city'] ?? address['address']['town'] ?? address['address']['village'] ?? address['address']['municipality']) ?? '-'}",
          ),
          Text(
            "Kecamatan: ${(address['address']['borough'] ?? address['address']['county'] ?? address['address']['district']) ?? '-'}",
          ),
          Text(
            "Desa/Kelurahan: ${(address['address']['suburb'] ?? address['address']['neighbourhood'] ?? address['address']['residential']) ?? '-'}",
          ),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Edit"),
                  SizedBox(width: 4),
                  Icon(Icons.edit, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fotoPreview() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Foto *", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              controller.imagePreview.value,
              height: 200,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
