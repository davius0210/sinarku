import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sinarku/helper/colors_helper.dart';

class RippleLocationPin extends StatefulWidget {
  final double size;
  final Color color;
  final Widget? infoWidget; // ✅ Variable widget optional
  final Function()? onTapInfo;
  const RippleLocationPin({
    super.key,
    this.size = 12,
    this.color = Colors.blue,
    this.infoWidget, // Input widget dari luar
    this.onTapInfo,
  });

  @override
  State<RippleLocationPin> createState() => _RippleLocationPinState();
}

class _RippleLocationPinState extends State<RippleLocationPin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showInfo = false; // State untuk kontrol bubble

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
      width: 300, // Diperlebar agar bubble tidak terpotong
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // --- BUBBLE CHAT ---
          if (_showInfo && widget.infoWidget != null)
            Positioned(
              bottom: 155, // Posisi di atas pin
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildBubbleChat(),
                  Positioned(
                    top: -15,
                    right: -15,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onTapInfo,
                        child: Ink(
                          height: 33,
                          width: 33,
                          child: Icon(CupertinoIcons.info, color: Colors.white),
                          decoration: BoxDecoration(
                            gradient: ColorsHelper.infoGradient,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // --- PIN & RIPPLE ---
          GestureDetector(
            onTap: () {
              setState(() {
                _showInfo = !_showInfo;
              });
            },
            child: SizedBox(
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
                          border: Border.all(color: Colors.white, width: 2),
                          color: widget.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membangun bubble chat container
  Widget _buildBubbleChat() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            // Supaya text style default muncul
            color: Colors.transparent,
            child: widget.infoWidget,
          ),
        ),
        // Segitiga kecil di bawah bubble
        CustomPaint(
          size: const Size(15, 10),
          painter: _TrianglePainter(Colors.white),
        ),
      ],
    );
  }
}

// Painter untuk Segitiga Bubble
class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Painter Ripple tetap sama
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
