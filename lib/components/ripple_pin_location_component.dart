import 'dart:math';
import 'package:flutter/material.dart';

class RippleLocationPin extends StatefulWidget {
  final double size;
  final Color color;

  const RippleLocationPin({
    super.key,
    this.size = 12,
    this.color = Colors.blue,
  });

  @override
  State<RippleLocationPin> createState() => _RippleLocationPinState();
}

class _RippleLocationPinState extends State<RippleLocationPin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _RipplePainter(
              progress: _controller.value,
              color: widget.color,
            ),
            child: Center(
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  _RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final rippleProgress = (progress + i / 3) % 1.0;
      final radius = rippleProgress * maxRadius;

      final paint = Paint()
        ..color = color.withOpacity(1 - rippleProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
