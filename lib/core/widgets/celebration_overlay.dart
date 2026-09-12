import 'dart:math';

import 'package:flutter/material.dart';

class CelebrationOverlay {
  static void show(BuildContext context, Offset origin) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) =>
          _CelebrationBurst(origin: origin, onCompleted: () => entry.remove()),
    );

    overlay.insert(entry);
  }
}

class _CelebrationBurst extends StatefulWidget {
  final Offset origin;
  final VoidCallback onCompleted;

  const _CelebrationBurst({required this.origin, required this.onCompleted});

  @override
  State<_CelebrationBurst> createState() => _CelebrationBurstState();
}

class _CelebrationBurstState extends State<_CelebrationBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  static const _particleCount = 14;
  static const _colors = [
    Color(0xFFE6A200),
    Color(0xFFFFD966),
    Color(0xFFFF8A65),
    Color(0xFF81C784),
    Color(0xFF64B5F6),
  ];

  @override
  void initState() {
    super.initState();
    final random = Random();
    _particles = List.generate(_particleCount, (i) {
      final angle = (2 * pi / _particleCount) * i + random.nextDouble() * 0.4;
      final distance = 50 + random.nextDouble() * 40;
      return _Particle(
        angle: angle,
        distance: distance,
        color: _colors[random.nextInt(_colors.length)],
        size: 6 + random.nextDouble() * 6,
      );
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward().whenComplete(widget.onCompleted);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _controller.value;
          final fade = 1 - progress;
          return Stack(
            children: [
              for (final p in _particles)
                Positioned(
                  left:
                      widget.origin.dx +
                      cos(p.angle) * p.distance * progress -
                      p.size / 2,
                  top:
                      widget.origin.dy +
                      sin(p.angle) * p.distance * progress -
                      p.size / 2,
                  child: Opacity(
                    opacity: fade.clamp(0, 1),
                    child: Container(
                      width: p.size,
                      height: p.size,
                      decoration: BoxDecoration(
                        color: p.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Particle {
  final double angle;
  final double distance;
  final Color color;
  final double size;

  _Particle({
    required this.angle,
    required this.distance,
    required this.color,
    required this.size,
  });
}
