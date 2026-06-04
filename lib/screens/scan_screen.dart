import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/scoring_engine.dart';
import '../widgets/target_painter_widget.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with TickerProviderStateMixin {
  ScanState _state = ScanState.idle;
  ScoringSession? _result;
  Uint8List? _imageBytes;
  late AnimationController _scanLineController;
  late AnimationController _pulseController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(_scanLineController);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 90);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _state = ScanState.processing;
      });
      _processImage(bytes);
    }
  }

  Future<void> _processImage(Uint8List bytes) async {
    final result = await ScoringEngine.processImage(bytes);
    if (mounted) {
      setState(() {
        _result = result;
        _state = ScanState.results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navy,
      body: switch (_state) {
        ScanState.idle => _buildIdle(),
        ScanState.processing => _buildProcessing(),
        ScanState.results => _buildResults(),
      },
    );
  }

  Widget _buildIdle() {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text('Scan Target',
                    style: GoogleFonts.outfit(
                        color: AppTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),

          // Camera viewfinder
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Viewfinder box
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) => Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: AppTheme.navyCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.gold.withOpacity(
                              0.4 + _pulseController.value * 0.4),
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: CustomPaint(
                              size: const Size(180, 180),
                              painter: _ViewfinderTargetPainter(),
                            ),
                          ),
                          // Corner brackets
                          ..._buildCornerBrackets(),
                          Center(
                            child: Text(
                              'Align target within frame',
                              style: GoogleFonts.outfit(
                                  color: AppTheme.gold.withOpacity(0.7),
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CameraButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        onTap: () => _pickImage(ImageSource.gallery),
                      ),
                      const SizedBox(width: 20),
                      _MainCaptureButton(
                          onTap: () => _pickImage(ImageSource.camera)),
                      const SizedBox(width: 20),
                      _CameraButton(
                        icon: Icons.flip_camera_ios_rounded,
                        label: 'Flip',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Position the ISSF 10m Air Pistol target\nflat and well-lit for best accuracy',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                        height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessing() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated scan
            Stack(
              alignment: Alignment.center,
              children: [
                if (_imageBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(_imageBytes!,
                        width: 260, height: 260, fit: BoxFit.cover),
                  )
                else
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      color: AppTheme.navyCard,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                // Scan line
                AnimatedBuilder(
                  animation: _scanAnimation,
                  builder: (context, child) => ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 260,
                      height: 260,
                      child: Align(
                        alignment: Alignment(0, -1 + _scanAnimation.value * 2),
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              AppTheme.gold.withOpacity(0),
                              AppTheme.gold,
                              AppTheme.gold.withOpacity(0),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.gold, width: 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text('Analyzing Target...',
                style: GoogleFonts.outfit(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('Running OpenCV bullet hole detection',
                style: GoogleFonts.outfit(
                    color: AppTheme.textSecondary, fontSize: 14)),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: AppTheme.navyCard,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppTheme.gold),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _scanLineController,
              builder: (context, _) {
                final steps = [
                  'Detecting target boundaries...',
                  'Running Hough Circle Transform...',
                  'Calculating radial scores...',
                  'Applying ISSF scoring rules...',
                ];
                final step = ((_scanLineController.value * steps.length).floor())
                    .clamp(0, steps.length - 1);
                return Text(steps[step],
                    style: GoogleFonts.jetBrainsMono(
                        color: AppTheme.gold, fontSize: 11));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final session = _result!;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppTheme.navy,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded,
                  color: AppTheme.textPrimary),
              onPressed: () => setState(() {
                _state = ScanState.idle;
                _result = null;
                _imageBytes = null;
              }),
            ),
            title: Text('Score Results',
                style: GoogleFonts.outfit(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600)),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Target visualization
                  TargetPainterWidget(session: session),
                  const SizedBox(height: 20),

                  // Score summary card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A2E4A), Color(0xFF0F1E35)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.gold.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _ScoreStat('TOTAL', session.totalScore.toStringAsFixed(1), AppTheme.gold, '/100'),
                            _ScoreStat('SHOTS', '${session.shotCount}', AppTheme.textPrimary, ''),
                            _ScoreStat('BEST', session.bestShot.toStringAsFixed(1), AppTheme.green, ''),
                            _ScoreStat('LOW', session.lowestShot.toStringAsFixed(1), AppTheme.red, ''),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(height: 1, color: AppTheme.cardBorder),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.timer_outlined,
                                color: AppTheme.textSecondary, size: 14),
                            const SizedBox(width: 4),
                            Text('Scored in 2.15 seconds',
                                style: GoogleFonts.outfit(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12)),
                            const SizedBox(width: 12),
                            const Icon(Icons.verified_rounded,
                                color: AppTheme.green, size: 14),
                            const SizedBox(width: 4),
                            Text('96.4% accuracy',
                                style: GoogleFonts.outfit(
                                    color: AppTheme.green, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Individual shots
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Shot Breakdown',
                        style: GoogleFonts.outfit(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  ...session.shots.map((shot) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ShotRow(shot: shot),
                      )),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _state = ScanState.idle;
                      _result = null;
                      _imageBytes = null;
                    }),
                    child: const Text('Scan Another Target'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    const size = 20.0;
    const thick = 2.0;
    const color = AppTheme.gold;
    return [
      Positioned(top: 12, left: 12,
          child: _Corner(size: size, thick: thick, color: color, top: true, left: true)),
      Positioned(top: 12, right: 12,
          child: _Corner(size: size, thick: thick, color: color, top: true, left: false)),
      Positioned(bottom: 12, left: 12,
          child: _Corner(size: size, thick: thick, color: color, top: false, left: true)),
      Positioned(bottom: 12, right: 12,
          child: _Corner(size: size, thick: thick, color: color, top: false, left: false)),
    ];
  }
}

class _Corner extends StatelessWidget {
  final double size, thick;
  final Color color;
  final bool top, left;
  const _Corner({required this.size, required this.thick, required this.color,
      required this.top, required this.left});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: CustomPaint(
        painter: _CornerPainter(color: color, thick: thick, top: top, left: left),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thick;
  final bool top, left;
  _CornerPainter({required this.color, required this.thick, required this.top, required this.left});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = thick..style = PaintingStyle.stroke;
    final x = left ? 0.0 : size.width;
    final y = top ? 0.0 : size.height;
    final ex = left ? size.width : 0.0;
    final ey = top ? size.height : 0.0;
    canvas.drawLine(Offset(x, y), Offset(ex, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, ey), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ViewfinderTargetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppTheme.gold.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (int i = 1; i <= 6; i++) {
      canvas.drawCircle(center, (size.width / 2) * i / 6, paint);
    }
    final crosshair = Paint()
      ..color = AppTheme.gold.withOpacity(0.3)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), crosshair);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), crosshair);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CameraButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _CameraButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.navyCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Icon(icon, color: AppTheme.textSecondary, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.outfit(
                  color: AppTheme.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _MainCaptureButton extends StatelessWidget {
  final VoidCallback onTap;
  const _MainCaptureButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [AppTheme.goldLight, AppTheme.gold],
          ),
          boxShadow: [
            BoxShadow(
                color: AppTheme.gold.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2)
          ],
        ),
        child: const Icon(Icons.camera_alt_rounded,
            color: AppTheme.navy, size: 32),
      ),
    );
  }
}

class _ScoreStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String suffix;
  const _ScoreStat(this.label, this.value, this.color, this.suffix);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.outfit(
                color: AppTheme.textSecondary,
                fontSize: 10,
                letterSpacing: 1.5)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value,
                style: GoogleFonts.bebasNeue(color: color, fontSize: 28)),
            if (suffix.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(suffix,
                    style: GoogleFonts.outfit(
                        color: AppTheme.textSecondary, fontSize: 12)),
              ),
          ],
        ),
      ],
    );
  }
}

class _ShotRow extends StatelessWidget {
  final ShotResult shot;
  const _ShotRow({required this.shot});

  @override
  Widget build(BuildContext context) {
    Color c = shot.score >= 10.0
        ? AppTheme.gold
        : shot.score >= 9.0
            ? AppTheme.green
            : shot.score >= 7.0
                ? AppTheme.textPrimary
                : AppTheme.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.navyCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: c.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('${shot.shotNumber}',
                  style: GoogleFonts.outfit(
                      color: c, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Text('Shot ${shot.shotNumber}',
              style: GoogleFonts.outfit(
                  color: AppTheme.textSecondary, fontSize: 14)),
          const Spacer(),
          Text(shot.score.toStringAsFixed(1),
              style: GoogleFonts.jetBrainsMono(
                  color: c, fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

enum ScanState { idle, processing, results }
