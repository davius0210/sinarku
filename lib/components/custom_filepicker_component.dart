import 'package:flutter/material.dart';
import 'package:sinarku/helper/colors_helper.dart';
import 'package:file_picker/file_picker.dart';

class CustomFilePickerComponent extends StatefulWidget {
  final ValueChanged<PlatformFile?> onChange;
  final String initialLabelText;
  final List<String>? allowedExtensions;

  const CustomFilePickerComponent({
    Key? key,
    required this.onChange,
    this.initialLabelText = 'Pilih KMZ/KML, SHP, CSV',
    this.allowedExtensions,
  }) : super(key: key);

  @override
  _CustomFilePickerComponentState createState() =>
      _CustomFilePickerComponentState();
}

class _CustomFilePickerComponentState extends State<CustomFilePickerComponent> {
  String _currentLabelText = '';

  @override
  void initState() {
    super.initState();
    _currentLabelText = widget.initialLabelText;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.allowedExtensions,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _currentLabelText = file.name;
      });
      widget.onChange(file);
    } else {
      setState(() {
        _currentLabelText = widget.initialLabelText;
      });
      widget.onChange(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsHelper.border),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(_currentLabelText, overflow: TextOverflow.ellipsis),
            ),
            Icon(Icons.attach_file_outlined, color: ColorsHelper.primary),
          ],
        ),
      ),
    );
  }
}
