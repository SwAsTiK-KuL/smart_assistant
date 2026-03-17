import 'package:flutter/material.dart';

class ShimmerCard extends StatefulWidget {
  final double? height;
  final int delay;
  const ShimmerCard({super.key, this.height, this.delay = 0});

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
    _anim = Tween<double>(
      begin: 0.4,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _anim,
      builder:
          (_, __) => Container(
            height: widget.height,
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cs.surfaceVariant.withOpacity(_anim.value),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cs.onSurface.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: cs.onSurface.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 10,
                  width: 140,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
