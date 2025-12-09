import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sinarku/app/routes/app_pages.dart';
import 'package:sinarku/components/card_list_menu_component.dart';
import 'package:sinarku/helper/colors_helper.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(color: ColorsHelper.primary),
            child: Column(
              children: [
                // Kembali

                // Foto Profil
                const Icon(Icons.account_circle, size: 90, color: Colors.white),

                // Nama & Role
                const SizedBox(height: 5),
                const Text(
                  "Jimmy Andrian Davius",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Surveyor", style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 5),

                // Masa aktif
                const Text(
                  "Aktif sampai: 31-12-2025",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 10),

                // Level Badge
                Container(
                  decoration: BoxDecoration(
                    color: ColorsHelper.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.suit_diamond,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Level Pengguna: Pengguna Umum",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              children: [
                const Text(
                  "Akun",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                CardListMenuComponent(
                  items: [
                    CardTileMenu(
                      title: const Text("Ubah Profil"),
                      prefix: const Icon(Icons.person_outline),
                      onPressed: () {},
                    ),
                    CardTileMenu(
                      title: const Text("Ganti Kata Sandi"),
                      prefix: const Icon(CupertinoIcons.shield),
                      onPressed: () {},
                    ),
                    CardTileMenu(
                      title: const Text("Tambah Usulan"),
                      prefix: const Icon(CupertinoIcons.plus_app),
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ---- INFO LAINNYA ----
                const Text(
                  "Info Lainnya",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                CardListMenuComponent(
                  items: [
                    CardTileMenu(
                      title: const Text("Kontak Kami"),
                      prefix: const Icon(Icons.phone_in_talk_outlined),
                      onPressed: () {},
                    ),
                    CardTileMenu(
                      title: const Text("Tentang Aplikasi"),
                      prefix: const Icon(CupertinoIcons.info),
                      onPressed: () {},
                    ),
                    CardTileMenu(
                      title: const Text("Panduan Pengguna"),
                      prefix: const Icon(Icons.menu_book_outlined),
                      onPressed: () {},
                    ),
                    CardTileMenu(
                      title: const Text(
                        "Keluar",
                        style: TextStyle(color: Colors.red),
                      ),
                      prefix: const Icon(Icons.logout),
                      onPressed: () {
                        Get.offAllNamed(Routes.LOGIN);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
