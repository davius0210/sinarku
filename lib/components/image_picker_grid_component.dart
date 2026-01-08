import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sinarku/helper/colors_helper.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImagePickerGridComponent extends StatefulWidget {
  final ValueChanged<String>? onValue; // ✅ semua path (url + lokal)
  final ValueChanged<List<String>>? onChanged; // ✅ trigger tiap ada perubahan
  final ValueChanged<int>? onDeleted; // ✅ callback khusus hapus url
  final bool isSingleFile;
  final List<String?>? value;

  const ImagePickerGridComponent({
    super.key,
    this.onValue,
    this.onChanged,
    this.onDeleted,
    this.isSingleFile = false,
    this.value,
  });

  @override
  State<ImagePickerGridComponent> createState() =>
      _ImagePickerGridComponentState();
}

class _ImagePickerGridComponentState extends State<ImagePickerGridComponent> {
  final picker = ImagePicker();
  List<File> _images = [];
  List<String?> _urls = [];

  @override
  void initState() {
    super.initState();
    _urls = widget.value ?? [];
    _emitChanges();
  }

  @override
  void didUpdateWidget(covariant ImagePickerGridComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        _urls = widget.value ?? [];
      });
      _emitChanges();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;

    File file = File(pickedFile.path);
    int fileSize = await file.length();

    if (fileSize > 5 * 1024 * 1024) {
      final compressedFile = await _compressImage(file);
      if (compressedFile != null) {
        file = compressedFile;
      } else {
        return; // Gagal kompresi
      }
    }

    setState(() {
      if (widget.isSingleFile) {
        _images
          ..clear()
          ..add(file);
      } else {
        _images.add(file);
      }
    });

    // ✅ Panggil onValue hanya untuk path file yang baru saja diambil
    widget.onValue?.call(file.path);

    // ✅ Tetap panggil emit untuk update onChanged (list keseluruhan)
    _emitChanges();
  }

  // Fungsi Helper untuk Kompresi
  Future<File?> _compressImage(File file) async {
    final tempDir = await path_provider.getTemporaryDirectory();
    final targetPath =
        '${tempDir.absolute.path}/temp_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50, // Menurunkan kualitas ke 70%
    );

    return result != null ? File(result.path) : null;
  }

  void _showPickOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _pickImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     final file = File(pickedFile.path);
  //     if (await file.length() <= 5 * 1024 * 1024) {
  //       setState(() {
  //         if (widget.isSingleFile) {
  //           _images
  //             ..clear()
  //             ..add(file);
  //         } else {
  //           _images.add(file);
  //         }
  //       });
  //       _emitChanges();
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Ukuran gambar maksimal 5MB')),
  //       );
  //     }
  //   }
  // }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    _emitChanges();
  }

  void _removeUrl(int index) {
    setState(() {
      _urls.removeAt(index);
    });
    widget.onDeleted?.call(index);
    _emitChanges();
  }

  void _emitChanges() {
    final allPaths = [
      ..._urls.whereType<String>(),
      ..._images.map((f) => f.path),
    ];

    widget.onChanged?.call(allPaths); // ✅ selalu kirim list<String>
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageWidgets = [
      // Tombol add
      if (!widget.isSingleFile || (_images.isEmpty && _urls.isEmpty))
        GestureDetector(
          onTap: _showPickOptions,
          child: Container(
            width: 78,
            height: 78,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.add, size: 30, color: Colors.grey),
            ),
          ),
        ),

      // File lokal
      ..._images.asMap().entries.map((entry) {
        int index = entry.key;
        File img = entry.value;
        return Stack(
          children: [
            Container(
              width: 78,
              height: 78,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: InkWell(
                onTap: () => _removeImage(index),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  child: Icon(
                    CupertinoIcons.delete,
                    size: 18,
                    color: ColorsHelper.border,
                  ),
                ),
              ),
            ),
          ],
        );
      }),

      // URL
      ..._urls
          .asMap()
          .entries
          .where((e) => e.value != null && e.value!.isNotEmpty)
          .map((entry) {
            int index = entry.key;
            String url = entry.value!;
            return Stack(
              children: [
                Container(
                  width: 78,
                  height: 78,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: url.startsWith('http')
                          ? NetworkImage(url)
                          : FileImage(File(url)) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: InkWell(
                    onTap: () => _removeUrl(index),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: Icon(
                        CupertinoIcons.delete,
                        size: 18,
                        color: ColorsHelper.border,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(spacing: 0, runSpacing: 0, children: imageWidgets),
        const SizedBox(height: 8),
        const Text(
          "*maksimum ukuran per gambar 5 mb",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
