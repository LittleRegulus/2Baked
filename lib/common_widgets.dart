import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'models.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: borderColor ?? AppColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x28000000),
          blurRadius: 24,
          offset: Offset(0, 12),
        ),
      ],
    );
    if (onTap == null) {
      return Container(padding: padding, decoration: decoration, child: child);
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(padding: padding, decoration: decoration, child: child),
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/branding/2baked-leaf-mascot.png',
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        semanticLabel: '2Baked weed leaf mascot',
      ),
    );
  }
}

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.fontSize = 19});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      const TextSpan(
        children: [
          TextSpan(
            text: '2',
            style: TextStyle(color: AppColors.logoEye),
          ),
          TextSpan(
            text: 'BAKED',
            style: TextStyle(color: AppColors.logoLeaf),
          ),
        ],
      ),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.25,
        shadows: [
          Shadow(
            color: AppColors.logoLeaf.withValues(alpha: 0.16),
            blurRadius: 12,
          ),
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 5),
                Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.icon,
    required this.label,
    this.color = AppColors.muted,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimerDial extends StatelessWidget {
  const TimerDial({
    super.key,
    required this.phase,
    required this.progress,
    required this.seconds,
    required this.isPaused,
  });

  final TimerPhase phase;
  final double progress;
  final int seconds;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    final color = switch (phase) {
      TimerPhase.heating => AppColors.ember,
      TimerPhase.cooling => AppColors.ice,
      TimerPhase.ready => AppColors.lime,
      TimerPhase.idle => AppColors.muted,
    };
    final label = switch (phase) {
      TimerPhase.heating => isPaused ? 'HEAT PAUSED' : 'HEATING',
      TimerPhase.cooling => isPaused ? 'COOL PAUSED' : 'COOLING',
      TimerPhase.ready => 'READY',
      TimerPhase.idle => 'SET YOUR TIMER',
    };
    final icon = switch (phase) {
      TimerPhase.heating => Icons.local_fire_department_rounded,
      TimerPhase.cooling => Icons.ac_unit_rounded,
      TimerPhase.ready => Icons.bolt_rounded,
      TimerPhase.idle => Icons.timer_outlined,
    };

    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _TimerDialPainter(
          progress: phase == TimerPhase.idle ? 0 : progress,
          color: color,
          reverse: phase == TimerPhase.cooling,
          ready: phase == TimerPhase.ready,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 27),
              ),
              const SizedBox(height: 14),
              Text(
                formatDuration(seconds),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 58,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerDialPainter extends CustomPainter {
  const _TimerDialPainter({
    required this.progress,
    required this.color,
    required this.reverse,
    required this.ready,
  });

  final double progress;
  final Color color;
  final bool reverse;
  final bool ready;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 18;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const strokeWidth = 11.0;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.border.withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    final visibleProgress = ready ? 1.0 : progress;
    if (visibleProgress <= 0) return;
    final sweep = math.pi * 2 * visibleProgress * (reverse ? -1 : 1);
    final start = -math.pi / 2;

    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..color = color.withValues(alpha: 0.34)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 11),
    );
    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..shader = SweepGradient(
          startAngle: 0,
          endAngle: math.pi * 2,
          colors: [color.withValues(alpha: 0.6), color, color],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    for (var i = 0; i < 24; i++) {
      final angle = -math.pi / 2 + (math.pi * 2 * i / 24);
      final inner = Offset(
        center.dx + math.cos(angle) * (radius - 23),
        center.dy + math.sin(angle) * (radius - 23),
      );
      final outer = Offset(
        center.dx + math.cos(angle) * (radius - 19),
        center.dy + math.sin(angle) * (radius - 19),
      );
      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..color = AppColors.muted.withValues(alpha: 0.25)
          ..strokeWidth = 1.4,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TimerDialPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.reverse != reverse ||
      oldDelegate.ready != ready;
}

String formatDuration(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
