import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sinarku/helper/colors_helper.dart';
class CustomTextComponent extends StatefulWidget {
  final String? hint;
  final Widget? icon;
  final Function(String)? onChange;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isPassword;

  const CustomTextComponent({
    super.key,
    this.controller,
    this.hint,
    this.icon,
    this.onChange,
    this.keyboardType,
    this.isPassword = false,
  });

  @override
  State<CustomTextComponent> createState() => _CustomTextComponentState();
}

class _CustomTextComponentState extends State<CustomTextComponent> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChange,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: ColorsHelper.hint),
        prefixIcon: widget.icon,

        // 👉 show icon eye if password
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
          borderSide:
              BorderSide(color: ColorsHelper.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: ColorsHelper.border, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: ColorsHelper.border),
        ),
      ),
    );
  }
}
