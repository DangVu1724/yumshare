import 'package:flutter/material.dart';
import 'dart:math';

class ShimmerCard extends StatefulWidget {
  const ShimmerCard({super.key});

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shimmerValue = (_controller.value * 2 * pi);
        final opacity = (0.5 + sin(shimmerValue) * 0.5).clamp(0.3, 0.8);

        return Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(opacity), borderRadius: BorderRadius.circular(12)),
        );
      },
    );
  }
}
