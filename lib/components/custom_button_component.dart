import 'package:flutter/material.dart';
import 'package:sinarku/helper/colors_helper.dart';

class CustomButtonComponent extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final String title;
  final Widget? icon;

  const CustomButtonComponent({
    super.key, 
    this.icon, 
    this.onPressed, 
    required this.title
  });

  @override
  State<CustomButtonComponent> createState() => _CustomButtonComponentState();
}

class _CustomButtonComponentState extends State<CustomButtonComponent> {
  bool isLoading = false;

  Future<void> handleClick() async {
    if (isLoading || widget.onPressed == null) return;

    setState(() => isLoading = true);

    try {
      await widget.onPressed!();
    } catch (e) {
      debugPrint("Error in CustomButtonComponent: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed == null ? null : handleClick,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.onPressed == null ? Colors.grey : ColorsHelper.primary,
        ),
        child: SizedBox(
          height: 22, // biar stabil, tidak berubah
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          widget.icon!,
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
