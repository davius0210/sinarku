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
                    Obx(() => _lokasiCard(address)),

                    const SizedBox(height: 16),
                    // _fotoPreview(),
                    ImagePickerGridComponent(
                      value: [],

                      onChanged: (value) {
                        controller.listImage.value = value;
                        print(value);
                      },
                    ),
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
                loadingText: "Please Wait ...",
                width: double.infinity,
                title: "Simpan Data",
                onPressed: () => controller.simpanData(context),
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
          Text(
            "Koordinat: ${address['lat']}, ${address['lon']}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("Arah Pengambilan Foto: ${address['heading']}°"),
          const Divider(),

          // Input Fields
          _buildEditableField("Provinsi", controller.provinsiController),
          _buildEditableField("Kabupaten/Kota", controller.kabupatenController),
          _buildEditableField("Kecamatan", controller.kecamatanController),
          _buildEditableField("Desa/Kelurahan", controller.desaController),

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.topRight,
            child: CustomButtonComponent(
              onPressed: () {
                controller.isEditing.value = !controller.isEditing.value;
                if (controller.isEditing.value) {
                  // Aksi Simpan: Di sini Anda bisa memproses data yang diedit
                  print("Data Disimpan: ${controller.provinsiController.text}");
                }
              },
              title: controller.isEditing.value ? "Simpan" : "Edit",
              icon: Icon(
                controller.isEditing.value ? Icons.save : Icons.edit,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk baris input
  Widget _buildEditableField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          controller.isEditing.value
              ? SizedBox(
                  height: 40,
                  child: TextField(
                    controller: ctrl,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                )
              : Text(
                  ctrl.text.isEmpty ? "-" : ctrl.text,
                  style: const TextStyle(fontSize: 14),
                ),
        ],
      ),
    );
  }
}
