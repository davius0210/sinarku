import 'package:flutter/material.dart';
import 'package:sinarku/helper/colors_helper.dart';

class CustomButtonComponent extends StatefulWidget {
  final Function()? onPressed;
  final String? title;
  final Widget? icon;
  final BorderRadius? borderRadius;
  final double? width;
  final Gradient? gradient; // New optional gradient
  final Color? color; // New optional color

  const CustomButtonComponent({
    super.key,
    this.icon,
    this.onPressed,
    this.title,
    this.borderRadius,
    this.width,
    this.gradient, // Add to constructor
    this.color, // Add to constructor
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
    return Container(
      width: widget.width ?? null,
      child: Material(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
        child: InkWell(
          onTap: widget.onPressed == null ? null : handleClick,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          child: Ink(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              gradient: widget.onPressed == null
                  ? null
                  : (widget.gradient ??
                        LinearGradient(
                          colors: [ColorsHelper.blue, ColorsHelper.primary],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )),
              color: widget.onPressed == null
                  ? Colors.grey
                  : (widget.color ?? null), // Use widget.color if provided
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isLoading
                  ? Container(
                      height: 24,
                      width: 24,
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
                          if (widget.title != null) const SizedBox(width: 8),
                        ],
                        if (widget.title != null)
                          Text(
                            widget.title!,
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
