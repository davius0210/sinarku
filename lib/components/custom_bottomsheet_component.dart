import 'package:flutter/material.dart';

class CustomBottomSheetManager extends StatefulWidget {
  final Widget child; // Konten utama (di belakang sheet)
  final Widget Function(VoidCallback closeSheet) builder; // Builder sheet
  final bool isVisible;
  final VoidCallback onDismiss;

  const CustomBottomSheetManager({
    super.key,
    required this.child,
    required this.builder,
    required this.isVisible,
    required this.onDismiss,
  });

  @override
  State<CustomBottomSheetManager> createState() =>
      _CustomBottomSheetManagerState();
}

class _CustomBottomSheetManagerState extends State<CustomBottomSheetManager>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant CustomBottomSheetManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeSheet() {
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Bottom Sheet Overlay
        if (widget.isVisible)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeSheet,
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),

        // Sliding Sheet
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.builder(_closeSheet),
          ),
        ),
      ],
    );
  }
}
