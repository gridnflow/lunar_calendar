import 'dart:math';

import 'package:flutter/material.dart';

import 'app_theme.dart';

/// 밤하늘 배경: 그라데이션 + 별밭 + (옵션) 초승달.
/// 로그인 화면 배경과 운세 히어로 카드에서 재사용.
class NightSky extends StatelessWidget {
  final Widget? child;
  final bool showMoon;
  final BorderRadius borderRadius;

  const NightSky({
    super.key,
    this.child,
    this.showMoon = true,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: AppTheme.nightSkyGradient),
        child: CustomPaint(
          painter: _NightSkyPainter(showMoon: showMoon),
          child: child,
        ),
      ),
    );
  }
}

class _NightSkyPainter extends CustomPainter {
  final bool showMoon;

  _NightSkyPainter({required this.showMoon});

  static const _moonColor = Color(0xFFF2D98D);

  @override
  void paint(Canvas canvas, Size size) {
    // 시드 고정 → 리빌드마다 별 배치가 흔들리지 않음
    final rand = Random(42);
    final starPaint = Paint();

    final starCount = (size.width * size.height / 6000).clamp(30, 140).toInt();
    for (var i = 0; i < starCount; i++) {
      final dx = rand.nextDouble() * size.width;
      final dy = rand.nextDouble() * size.height;
      final radius = rand.nextDouble() * 1.3 + 0.4;
      starPaint.color =
          Colors.white.withValues(alpha: rand.nextDouble() * 0.5 + 0.15);
      canvas.drawCircle(Offset(dx, dy), radius, starPaint);
    }

    // 조금 큰 반짝임 몇 개 (십자 광채)
    final twinklePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 4; i++) {
      final dx = rand.nextDouble() * size.width;
      final dy = rand.nextDouble() * size.height * 0.7;
      final len = rand.nextDouble() * 3 + 3;
      canvas.drawLine(Offset(dx - len, dy), Offset(dx + len, dy), twinklePaint);
      canvas.drawLine(Offset(dx, dy - len), Offset(dx, dy + len), twinklePaint);
    }

    if (!showMoon) return;

    final cx = size.width * 0.80;
    final cy = size.height * 0.17;
    final r = (min(size.width, size.height) * 0.10 + 14).clamp(22.0, 46.0);

    // 달무리 (은은한 글로우)
    canvas.drawCircle(
      Offset(cx, cy),
      r * 1.9,
      Paint()
        ..color = _moonColor.withValues(alpha: 0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );

    // 초승달: 원에서 살짝 비껴간 원을 빼서 만든다
    final moon = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    final bite = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(cx - r * 0.42, cy - r * 0.22), radius: r * 0.94));
    final crescent = Path.combine(PathOperation.difference, moon, bite);
    canvas.drawPath(crescent, Paint()..color = _moonColor);
  }

  @override
  bool shouldRepaint(covariant _NightSkyPainter oldDelegate) =>
      oldDelegate.showMoon != showMoon;
}
