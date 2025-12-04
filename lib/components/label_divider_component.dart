import 'package:flutter/material.dart';
import 'package:sinarku/helper/colors_helper.dart';

class LabeledDivider extends StatelessWidget {
  final String label;
  final Color color;
  final double thickness;

  const LabeledDivider({
    super.key,
    required this.label,
    this.color = ColorsHelper.border,
    this.thickness = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color,
            thickness: thickness,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(label, style: TextStyle(color: ColorsHelper.blue)),
        ),
        Expanded(
          child: Divider(
            color: color,
            thickness: thickness,
          ),
        ),
      ],
    );
  }
}
