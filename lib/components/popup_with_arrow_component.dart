import 'package:flutter/material.dart';

class PopupWithArrow extends StatelessWidget {
  final Widget child;

  const PopupWithArrow({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: 230,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: child,
        ),
        CustomPaint(
          size: const Size(20, 10),
          painter: _TrianglePainter(color: Colors.white.withOpacity(0.9)),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
