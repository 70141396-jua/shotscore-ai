import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/models.dart';

/// ShotScore AI — Computer Vision Scoring Engine
/// Simulates OpenCV Hough Circle Transform + contour detection
/// In production: replace processImage() with actual OpenCV FFI calls
class ScoringEngine {
  static final Random _random = Random();

  /// Main entry point — processes an image and returns scored shots
  /// Currently: generates realistic demo results
  /// Production: calls native OpenCV via dart:ffi or Python backend
  static Future<ScoringSession> processImage(Uint8List? imageBytes) async {
    // Simulate processing time (2.15s average as per project specs)
    await Future.delayed(const Duration(milliseconds: 2150));

    final shots = _generateRealisticShots();
    return ScoringSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      sessionName: _getSessionName(),
      shots: shots,
    );
  }

  static List<ShotResult> _generateRealisticShots() {
    // Simulate a competitive shooter — tight grouping near 9-10 zone
    final shots = <ShotResult>[];
    // Anchor point for tight grouping (simulates consistent hold)
    final groupX = 0.48 + (_random.nextDouble() - 0.5) * 0.08;
    final groupY = 0.50 + (_random.nextDouble() - 0.5) * 0.08;

    for (int i = 0; i < 10; i++) {
      // Distance from center determines score
      final spread = 0.06;
      final dx = (_random.nextGaussian()) * spread + (groupX - 0.5);
      final dy = (_random.nextGaussian()) * spread + (groupY - 0.5);
      final dist = sqrt(dx * dx + dy * dy);

      // ISSF scoring: distance maps to 10.9 (center) down to 0
      double score = _distanceToScore(dist);
      score = (score * 10).round() / 10.0;
      score = score.clamp(0.0, 10.9);

      shots.add(ShotResult(
        score: score,
        x: 0.5 + dx,
        y: 0.5 + dy,
        shotNumber: i + 1,
      ));
    }
    return shots;
  }

  static double _distanceToScore(double normalizedDist) {
    // Maps normalized distance (0=center, 0.5=edge) to ISSF score
    if (normalizedDist < 0.03) return 10.0 + _random.nextDouble() * 0.9;
    if (normalizedDist < 0.07) return 9.0 + _random.nextDouble();
    if (normalizedDist < 0.12) return 8.0 + _random.nextDouble();
    if (normalizedDist < 0.18) return 7.0 + _random.nextDouble();
    if (normalizedDist < 0.25) return 6.0 + _random.nextDouble();
    if (normalizedDist < 0.33) return 5.0 + _random.nextDouble();
    return 4.0 + _random.nextDouble() * 2;
  }

  static String _getSessionName() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning Practice';
    if (hour < 17) return 'Afternoon Training';
    return 'Evening Session';
  }
}

extension on Random {
  double nextGaussian() {
    // Box-Muller transform for Gaussian distribution
    double u1 = nextDouble();
    double u2 = nextDouble();
    if (u1 == 0) u1 = 0.0001;
    return sqrt(-2.0 * log(u1)) * cos(2.0 * pi * u2);
  }
}
