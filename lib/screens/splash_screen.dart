import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.elasticOut),
    );

    _fadeController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navy,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _pulseAnimation.value,
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: TargetPainter(
                        color: AppTheme.gold,
                        opacity: 0.6 + _pulseAnimation.value * 0.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'SHOTSCORE AI',
                  style: GoogleFonts.bebasNeue(
                    color: AppTheme.gold,
                    fontSize: 42,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'SCORE SMARTER. SHOOT BETTER.',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: 180,
                  child: LinearProgressIndicator(
                    backgroundColor: AppTheme.navyCard,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppTheme.gold),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Initializing CV Engine...',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TargetPainter extends CustomPainter {
  final Color color;
  final double opacity;

  TargetPainter({required this.color, this.opacity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    final rings = 7;

    for (int i = rings; i >= 1; i--) {
      final radius = (maxRadius / rings) * i;
      final paint = Paint()
        ..color = color.withOpacity(opacity * (0.15 + (rings - i) * 0.05))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(center, radius, paint);
    }

    // Bullseye
    final bullPaint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxRadius / rings, bullPaint);

    final innerPaint = Paint()
      ..color = AppTheme.navy
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxRadius / rings * 0.4, innerPaint);
  }

  @override
  bool shouldRepaint(TargetPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}
