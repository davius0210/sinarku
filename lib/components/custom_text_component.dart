import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sinarku/helper/colors_helper.dart';

enum InputComponentType { text, dropdown }

class CustomTextComponent<T> extends StatefulWidget {
  final String? hint;
  final String? labelText; // New property for the label
  final Widget? icon;
  final Function(String)? onChange;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final InputComponentType type; // New property for input type
  final List<DropdownMenuItem<T>>? dropdownItems; // Items for dropdown
  final T? dropdownValue; // Currently selected dropdown value
  final Function(T?)? onDropdownChanged; // Callback for dropdown changes
  final bool? readOnly;
  const CustomTextComponent({
    super.key,
    this.controller,
    this.hint,
    this.labelText, // Initialize the new property
    this.icon,
    this.onChange,
    this.keyboardType,
    this.isPassword = false,
    this.type = InputComponentType.text, // Default to text
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.readOnly,
  });

  @override
  State<CustomTextComponent<T>> createState() => _CustomTextComponentState<T>();
}

class _CustomTextComponentState<T> extends State<CustomTextComponent<T>> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Widget inputWidget;

    if (widget.type == InputComponentType.dropdown) {
      inputWidget = DropdownButtonFormField<T>(
        value: widget.dropdownValue,
        items: widget.dropdownItems,
        onChanged: widget.onDropdownChanged,

        decoration: InputDecoration(
          enabled: widget.readOnly == true ? false : true,
          hintText: widget.hint,
          hintStyle: TextStyle(color: ColorsHelper.hint),
          prefixIcon: widget.icon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorsHelper.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorsHelper.border, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorsHelper.border),
          ),
        ),
      );
    } else {
      inputWidget = TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChange,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          enabled: widget.readOnly == true ? false : true,
          hintText: widget.hint,
          hintStyle: TextStyle(color: ColorsHelper.hint),
          prefixIcon: widget.icon,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: ColorsHelper.border,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorsHelper.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorsHelper.border, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorsHelper.border),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null && widget.labelText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.labelText!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        inputWidget,
      ],
    );
  }
}
