import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class TargetPainterWidget extends StatelessWidget {
  final ScoringSession session;

  const TargetPainterWidget({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDD8), // tan paper color
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: _TargetWithShotsPainter(session.shots),
          ),
        ),
      ),
    );
  }
}

class _TargetWithShotsPainter extends CustomPainter {
  final List<ShotResult> shots;

  _TargetWithShotsPainter(this.shots);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.width * 0.46;

    // Draw target rings
    const ringColors = [
      Color(0xFFF5EDD8), // 1-3
      Color(0xFFF5EDD8),
      Color(0xFFF5EDD8),
      Color(0xFFC8B89A), // 4-6
      Color(0xFFC8B89A),
      Color(0xFFC8B89A),
      Color(0xFF2A2A2A), // 7-10
      Color(0xFF2A2A2A),
      Color(0xFF2A2A2A),
      Color(0xFF111111), // bullseye 10
    ];

    final strokePaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (int i = 10; i >= 1; i--) {
      final r = maxR * i / 10;
      final fillPaint = Paint()
        ..color = ringColors[i - 1]
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, r, fillPaint);
      canvas.drawCircle(center, r, strokePaint);
    }

    // Score labels on rings
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 1; i <= 9; i++) {
      final r = maxR * i / 10;
      final label = '$i';
      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: i >= 7 ? Colors.white54 : Colors.black38,
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      canvas.save();
      canvas.translate(center.dx + r - 12, center.dy - textPainter.height / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    // Crosshair
    final crossPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset(center.dx, center.dy - maxR * 0.4),
        Offset(center.dx, center.dy + maxR * 0.4), crossPaint);
    canvas.drawLine(Offset(center.dx - maxR * 0.4, center.dy),
        Offset(center.dx + maxR * 0.4, center.dy), crossPaint);

    // Draw shots
    for (final shot in shots) {
      final sx = shot.x * size.width;
      final sy = shot.y * size.height;
      final shotOffset = Offset(sx, sy);

      // Bullet hole shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(shotOffset, 8, shadowPaint);

      // Bullet hole
      final holePaint = Paint()..color = const Color(0xFF1A0A00);
      canvas.drawCircle(shotOffset, 7, holePaint);

      // Score ring
      Color ringColor = _scoreColor(shot.score);
      final ringPaint = Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(shotOffset, 9, ringPaint);

      // Shot number
      textPainter.text = TextSpan(
        text: '${shot.shotNumber}',
        style: TextStyle(
          color: ringColor,
          fontSize: 7,
          fontWeight: FontWeight.w800,
        ),
      );
      textPainter.layout();
      canvas.drawCircle(shotOffset, 7, Paint()..color = const Color(0xFF1A0A00));
      textPainter.paint(
          canvas,
          Offset(shotOffset.dx - textPainter.width / 2,
              shotOffset.dy - textPainter.height / 2));
    }
  }

  Color _scoreColor(double score) {
    if (score >= 10.0) return const Color(0xFFE8A020);
    if (score >= 9.0) return const Color(0xFF22C55E);
    if (score >= 7.0) return Colors.white;
    return const Color(0xFFEF4444);
  }

  @override
  bool shouldRepaint(_TargetWithShotsPainter old) => old.shots != shots;
}
