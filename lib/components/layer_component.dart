import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LayerComponent extends StatelessWidget {
  final String title;
  final bool value;
  final double sliderValue;
  final Function(bool?) onChangedCheck;
  final Function(double) onChangedSlider;
  const LayerComponent({
    super.key,
    required this.title,
    required this.value,
    required this.sliderValue,
    required this.onChangedCheck,
    required this.onChangedSlider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(value: value, onChanged: onChangedCheck),
            Text(title),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text("Transparansi", style: TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 15),
          child: Row(
            children: [
              const Text("0", style: TextStyle(fontSize: 11)),
              Expanded(
                child: Slider(
                  value: sliderValue,
                  min: 0,
                  max: 100,
                  activeColor: value ? Colors.blue : Colors.grey,
                  inactiveColor: Colors.grey.shade300,
                  onChanged: value ? onChangedSlider : null,
                ),
              ),
              const Text("100", style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
