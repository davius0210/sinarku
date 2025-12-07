import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sinarku/app/routes/app_pages.dart';
import 'package:sinarku/components/custom_bottomsheet_component.dart';
import 'package:sinarku/components/custom_button_component.dart';
import 'package:sinarku/components/custom_filepicker_component.dart';
import 'package:sinarku/components/custom_middle_navbar_component.dart';
import 'package:sinarku/components/custom_text_component.dart';
import 'package:sinarku/components/label_divider_component.dart';
import 'package:sinarku/helper/colors_helper.dart';
import 'package:sinarku/helper/constant_helper.dart';
import 'package:sinarku/helper/function_helper.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: Image(image: AssetImage('assets/images/logo.png')),
              foregroundColor: Colors.white,
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jimmy Andrian Davius',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Pengguna Umum',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: FlutterMap(
              mapController: MapController(),
              options: MapOptions(),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  maxZoom: 18,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: const LatLng(51.5, -0.09),
                      width: 80,
                      height: 80,
                      child: const FlutterLogo(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 25, 10, 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: ColorsHelper.primary,
                // gradient: LinearGradient(
                //   colors: [ColorsHelper.primary, ColorsHelper.blue],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.SETTING);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.gear, color: Colors.white),
                          Text(
                            'Pengaturan',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.SYNCDATA);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.database,
                            color: Colors.white,
                          ),
                          Text(
                            'Daftar Data',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.REKAMJEJAK);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.walking, color: Colors.white),
                          Text(
                            'Rekam Jejak',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.PROFILE);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.user, color: Colors.white),
                          Text(
                            'User',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(50),
                      child: Ink(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            colors: [ColorsHelper.primary, ColorsHelper.blue],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: FaIcon(
                            Icons.pin_drop,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Rekam Toponim',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,

            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButtonComponent(
                  icon: Icon(
                    FontAwesomeIcons.compass,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(50),
                ),
                Row(
                  children: [
                    CustomButtonComponent(
                      borderRadius: BorderRadius.circular(50),
                      icon: Icon(Icons.upload, size: 30, color: Colors.white),
                      onPressed: () {
                        FunctionHelper.showDialog(
                          context,
                          title: 'Unggah Data Lain',
                          height: 200,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColorsHelper.border,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text('Pilih KMZ/KML, SHP, CSV'),
                                    ),
                                    Icon(
                                      Icons.attach_file_outlined,
                                      color: ColorsHelper.primary,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              CustomButtonComponent(
                                width: double.infinity,
                                title: 'Simpan',
                                icon: Icon(
                                  FontAwesomeIcons.save,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 10),
                    CustomButtonComponent(
                      icon: Icon(Icons.layers, size: 30, color: Colors.white),
                      onPressed: () {},
                      borderRadius: BorderRadius.circular(50),
                    ),
                    SizedBox(width: 10),
                    CustomButtonComponent(
                      icon: Icon(Icons.map, size: 30, color: Colors.white),
                      onPressed: () {
                        controller.selectedBasemap.value = '';
                        FunctionHelper.showDialog(
                          context,
                          height: 400,
                          title: 'Basemap',
                          footer: Obx(() {
                            final selectedBasemap =
                                controller.selectedBasemap.value;
                            if (selectedBasemap == 'online') {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomButtonComponent(
                                        icon: Icon(
                                          Icons.save,
                                          color: Colors.white,
                                        ),
                                        title: 'Simpan',
                                        onPressed: () {},
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: CustomButtonComponent(
                                        icon: Icon(
                                          Icons.download,
                                          color: Colors.white,
                                        ),
                                        title: 'Unduh',
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (selectedBasemap == 'offline') {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 20,
                                ),
                                child: CustomButtonComponent(
                                  width: double.infinity,

                                  icon: Icon(Icons.upload, color: Colors.white),
                                  title: 'Upload',
                                  onPressed: () {},
                                ),
                              );
                            }
                            return SizedBox();
                          }),
                          content: StatefulBuilder(
                            builder: (context, setState) {
                              return Obx(
                                () => Column(
                                  children: [
                                    CustomTextComponent(
                                      hint: 'Pilih Basemap',
                                      type: InputComponentType.dropdown,
                                      dropdownValue:
                                          controller.selectedBasemap.value == ''
                                          ? null
                                          : controller.selectedBasemap.value,
                                      dropdownItems: [
                                        DropdownMenuItem(
                                          value: 'online',
                                          child: Text('Online'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'offline',
                                          child: Text('Offline'),
                                        ),
                                      ],
                                      onDropdownChanged: (value) {
                                        controller.selectedBasemap.value =
                                            value!;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    if (controller.selectedBasemap.value ==
                                        'online')
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          LabeledDivider(
                                            label: 'Basemap Online',
                                          ),
                                          SizedBox(height: 10),

                                          CustomTextComponent(
                                            labelText: 'Basemap Type',
                                            hint: 'Pilih Basemap',
                                            type: InputComponentType.dropdown,

                                            dropdownItems: [
                                              DropdownMenuItem(
                                                value: 'esri',
                                                child: Text('Esri Imagery'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'bing',
                                                child: Text('Bing'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'foto_udara',
                                                child: Text('Foto Udara'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'citra_satelit',
                                                child: Text('Citra Satelit'),
                                              ),
                                            ],
                                            onDropdownChanged: (value) {},
                                          ),
                                          SizedBox(height: 10),
                                          CustomTextComponent(
                                            labelText: 'Unduh Basemap',
                                            hint: 'Unduh Basemap',
                                            type: InputComponentType.dropdown,

                                            dropdownItems: [
                                              DropdownMenuItem(
                                                value: 'esri',
                                                child: Text('Esri Imagery'),
                                              ),
                                            ],
                                            onDropdownChanged: (value) {},
                                          ),
                                        ],
                                      ),
                                    if (controller.selectedBasemap.value ==
                                        'offline')
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          LabeledDivider(
                                            label: 'Unggah Basemap Offline',
                                          ),
                                          SizedBox(height: 10),
                                          CustomFilePickerComponent(
                                            onChange: (val) {
                                              print(val);
                                            },
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            right: 10,
            child: CustomButtonComponent(
              icon: Icon(Icons.gps_fixed, size: 30, color: Colors.white),
              borderRadius: BorderRadius.circular(50),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const Center(child: Text("Home Screen")),
      const Center(child: Text("Search Screen")),
      const Center(child: Text("Profile Screen")),
      const Center(child: Text("Profile Screen")),
      const Center(child: Text("Profile Screen")),
    ];
  }
}
