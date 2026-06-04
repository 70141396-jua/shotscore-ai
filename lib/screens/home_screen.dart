import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/bottom_nav.dart';
import 'scan_screen.dart';
import 'progress_screen.dart';
import 'badges_screen.dart';
import 'coach_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;
  final List<ScoringSession> _sessions = SampleData.getSessions();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navy,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeTab(sessions: _sessions, onScan: () => setState(() => _currentIndex = 1)),
          const ScanScreen(),
          ProgressScreen(sessions: _sessions),
          const BadgesScreen(),
          const CoachScreen(),
        ],
      ),
      bottomNavigationBar: ShotScoreBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final List<ScoringSession> sessions;
  final VoidCallback onScan;

  const _HomeTab({required this.sessions, required this.onScan});

  @override
  Widget build(BuildContext context) {
    final latest = sessions.first;
    final greeting = _getGreeting();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('$greeting ', style: GoogleFonts.outfit(color: AppTheme.gold, fontSize: 14)),
                              const Text('🎯'),
                            ],
                          ),
                          Text('Sabeer Ahmad',
                              style: GoogleFonts.outfit(
                                  color: AppTheme.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.gold,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text('SA',
                              style: GoogleFonts.outfit(
                                  color: AppTheme.navy,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Best score card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A2E4A), Color(0xFF0F1E35)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TODAY'S BEST SCORE",
                            style: GoogleFonts.outfit(
                                color: AppTheme.gold,
                                fontSize: 11,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              latest.totalScore.toStringAsFixed(1),
                              style: GoogleFonts.bebasNeue(
                                  color: AppTheme.gold, fontSize: 56, height: 1),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text('/100',
                                  style: GoogleFonts.outfit(
                                      color: AppTheme.textSecondary,
                                      fontSize: 18)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _StatChip('${latest.shotCount} Shots', AppTheme.textSecondary),
                            const SizedBox(width: 8),
                            _StatChip('${latest.bestShot} Best', AppTheme.green),
                            const SizedBox(width: 8),
                            _StatChip('+3.2 vs yesterday', AppTheme.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Score new target CTA
                  GestureDetector(
                    onTap: onScan,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.navyCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.gold.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.gold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                color: AppTheme.gold, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Score New Target',
                                  style: GoogleFonts.outfit(
                                      color: AppTheme.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              Text('Tap to open camera',
                                  style: GoogleFonts.outfit(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13)),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              color: AppTheme.gold, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick stats grid
                  Row(
                    children: [
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.trending_up_rounded,
                          label: 'Progress',
                          value: 'View graphs',
                          color: AppTheme.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickStatCard(
                          icon: Icons.emoji_events_rounded,
                          label: 'Badges',
                          value: '12 earned',
                          color: AppTheme.gold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Recent sessions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Sessions',
                          style: GoogleFonts.outfit(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      Text('See all',
                          style: GoogleFonts.outfit(
                              color: AppTheme.gold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: _SessionCard(session: sessions[i]),
              ),
              childCount: sessions.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

class _StatChip extends StatelessWidget {
  final String text;
  final Color color;

  const _StatChip(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: GoogleFonts.outfit(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.navyCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.outfit(
                  color: AppTheme.textSecondary, fontSize: 13)),
          Text(value,
              style: GoogleFonts.outfit(
                  color: color, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final ScoringSession session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final timeAgo = _timeAgo(session.timestamp);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.navyCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.track_changes_rounded,
                color: AppTheme.gold, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.sessionName,
                    style: GoogleFonts.outfit(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600)),
                Text(timeAgo,
                    style: GoogleFonts.outfit(
                        color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                session.totalScore.toStringAsFixed(1),
                style: GoogleFonts.bebasNeue(
                    color: AppTheme.gold, fontSize: 24),
              ),
              Text('${session.shotCount} shots',
                  style: GoogleFonts.outfit(
                      color: AppTheme.textSecondary, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inHours < 1) return 'Just now';
    if (diff.inHours < 24) return 'Today, ${_fmt(dt)}';
    if (diff.inDays == 1) return 'Yesterday, ${_fmt(dt)}';
    return '${diff.inDays} days ago';
  }

  String _fmt(DateTime dt) =>
      '${dt.hour % 12 == 0 ? 12 : dt.hour % 12}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';
}
