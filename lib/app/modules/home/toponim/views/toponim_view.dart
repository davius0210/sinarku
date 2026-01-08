import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sinarku/components/api_search_dropdown_component.dart';
import 'package:sinarku/components/custom_button_component.dart';
import 'package:sinarku/components/custom_text_component.dart';
import 'package:sinarku/components/image_picker_grid_component.dart';
import 'package:sinarku/data/api_helper.dart';
import 'package:sinarku/data/apps_repository.dart';
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
                      },
                    ),
                    const SizedBox(height: 16),

                    // CustomTextComponent(
                    //   controller: controller.idRupabumi,
                    //   labelText: "ID Rupabumi *",
                    //   hint: "AL1RLF007JkmsSERLK",
                    // ),
                    // const SizedBox(height: 16),
                    // CustomTextComponent<String>(
                    //   labelText: "Jenis Unsur *",
                    //   type: InputComponentType.dropdown,

                    //   dropdownItems: [
                    //     DropdownMenuItem(value: "Pulau", child: Text("Pulau")),
                    //     DropdownMenuItem(
                    //       value: "Gunung",
                    //       child: Text("Gunung"),
                    //     ),
                    //   ],
                    //   onDropdownChanged: (value) =>
                    //       controller.jenisUnsur?.value = value ?? "",
                    // ),
                    // const SizedBox(height: 16),
                    Obx(
                      () => ApiSearchDropdown<dynamic>(
                        minQueryLength: 0,
                        labelText: "Element Generik *",
                        hint: "Pilih element generik",
                        isFetchFirst: true,
                        value: controller.selectElement.value,
                        onChanged: (val) =>
                            controller.selectElement.value = val!,
                        itemLabel: (c) => c['name'] ?? '',
                        fetchItems: (search) async {
                          return await controller.fetchElement(search);
                        },
                        validator: (val) => val == null
                            ? "Element Generik wajib dipilih"
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CustomTextComponent<String>(
                    //   labelText: "Elemen Spesifik *",
                    //   type: InputComponentType.dropdown,
                    //   icon: const Icon(Icons.location_city),

                    //   dropdownItems: [
                    //     DropdownMenuItem(value: "Timur", child: Text("Timur")),
                    //     DropdownMenuItem(value: "Barat", child: Text("Barat")),
                    //   ],
                    //   onDropdownChanged: (value) =>
                    //       controller.elemenSpesifik?.value = value ?? "",
                    // ),

                    // const SizedBox(height: 16),
                    CustomTextComponent(
                      controller: controller.mapName,
                      labelText: "Nama Spesifik",
                    ),
                    const SizedBox(height: 16),

                    CustomTextComponent(
                      controller: controller.otherName,
                      labelText: "Nama Lain",
                    ),
                    const SizedBox(height: 16),

                    CustomTextComponent(
                      controller: controller.localName,
                      labelText: "Nama Sebelumnya",
                    ),
                    const SizedBox(height: 16),

                    CustomTextComponent(
                      controller: controller.languageOrigin,
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
                onPressed: () async {
                  await controller.simpanData(context);
                },
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
          Obx(
            () => controller.isEditing.value
                ? ApiSearchDropdown<dynamic>(
                    labelText: "Provinsi",
                    hint: "Pilih provinsi",

                    value: controller.selectProvince.value,
                    onChanged: (val) => controller.selectProvince.value = val!,
                    itemLabel: (c) => c['name'] ?? '',
                    fetchItems: (search) async {
                      return await controller.fetchProvince(search, 'PROVINCE');
                    },
                    validator: (val) =>
                        val == null ? "Provinsi wajib dipilih" : null,
                  )
                : _buildLabel(
                    "Provinsi",
                    controller.selectProvince.value['name'] ?? '-',
                  ),
          ),
          Obx(
            () => controller.isEditing.value
                ? ApiSearchDropdown<dynamic>(
                    labelText: "Kabupaten/Kota",
                    hint: "Pilih kabupaten/kota",

                    value: controller.selectKabupaten.value,
                    onChanged: (val) => controller.selectKabupaten.value = val!,
                    itemLabel: (c) => c['name'] ?? '',
                    fetchItems: (search) async {
                      return await controller.fetchProvince(search, 'CITY');
                    },
                    validator: (val) =>
                        val == null ? "Kabupaten/Kota wajib dipilih" : null,
                  )
                : _buildLabel(
                    "Kabupaten/Kota",
                    controller.selectKabupaten.value['name'] ?? '-',
                  ),
          ),
          Obx(
            () => controller.isEditing.value
                ? ApiSearchDropdown<dynamic>(
                    labelText: "Kecamatan",
                    hint: "Pilih kecamatan",

                    value: controller.selectKecamatan.value,
                    onChanged: (val) => controller.selectKecamatan.value = val!,
                    itemLabel: (c) => c['name'] ?? '',
                    fetchItems: (search) async {
                      return await controller.fetchProvince(search, 'DISTRICT');
                    },
                    validator: (val) =>
                        val == null ? "Kecamatan wajib dipilih" : null,
                  )
                : _buildLabel(
                    "Kecamatan",
                    controller.selectKecamatan.value['name'] ?? '-',
                  ),
          ),
          Obx(
            () => controller.isEditing.value
                ? ApiSearchDropdown<dynamic>(
                    labelText: "Desa/Kelurahan",
                    hint: "Pilih desa/kelurahan",

                    value: controller.selectKelurahan.value,
                    onChanged: (val) => controller.selectKelurahan.value = val!,
                    itemLabel: (c) => c['name'] ?? '',
                    fetchItems: (search) async {
                      return await controller.fetchProvince(search, 'VILLAGE');
                    },
                    validator: (val) =>
                        val == null ? "Kecamatan wajib dipilih" : null,
                  )
                : _buildLabel(
                    "Desa/Kelurahan",
                    controller.selectKelurahan.value['name'] ?? '-',
                  ),
          ),

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

  Widget _buildLabel(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(value),
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
