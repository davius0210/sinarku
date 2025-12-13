import 'package:flutter/material.dart';

class StatusIndicator extends StatefulWidget {
  final double size;
  final LinearGradient gradientColors; // warna gradient
  final Duration duration;
  final int repeatCount; // -1 = infinite
  final bool autoStart;

  const StatusIndicator({
    Key? key,
    this.size = 24,
    this.gradientColors = const LinearGradient(
      colors: [Color(0xFF00FF88), Color(0xFF0077FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.duration = const Duration(seconds: 2),
    this.repeatCount = -1,
    this.autoStart = true,
  }) : super(key: key);

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowOpacity;
  int _played = 0;
  bool _running = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Animasi glow (hanya opacity dan blur)
    _glowOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _played++;
        if (widget.repeatCount < 0 || _played < widget.repeatCount) {
          _controller.reset();
          _controller.forward();
        } else {
          _running = false;
        }
      }
    });

    if (widget.autoStart) start();
  }

  void start() {
    if (_running) return;
    _running = true;
    _played = 0;
    _controller.reset();
    _controller.forward();
  }

  void stop() {
    _controller.stop();
    _running = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowOpacity,
      builder: (context, child) {
        final glowStrength = 15 * _glowOpacity.value;
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: widget.gradientColors,
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.colors.last.withOpacity(
                  0.6 * _glowOpacity.value,
                ),
                blurRadius: glowStrength,
                spreadRadius: glowStrength / 4,
              ),
            ],
          ),
        );
      },
    );
  }
}
