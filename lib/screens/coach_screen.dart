import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class CoachScreen extends StatelessWidget {
  const CoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final athletes = SampleData.getAthletes();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Coach Portal',
                      style: GoogleFonts.outfit(
                          color: AppTheme.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700)),
                  Text('Mushtaq Ahmad • UoL Shooting Club',
                      style: GoogleFonts.outfit(
                          color: AppTheme.gold, fontSize: 14)),
                  const SizedBox(height: 20),

                  // Summary stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _CoachStat('${athletes.length}', 'ATHLETES', AppTheme.gold),
                      _CoachStat(
                        (athletes.fold(0.0, (s, a) => s + a.avgScore) /
                                athletes.length)
                            .toStringAsFixed(1),
                        'AVG SCORE',
                        AppTheme.gold,
                      ),
                      _CoachStat('24', 'SESSIONS', AppTheme.gold),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Athletes',
                          style: GoogleFonts.outfit(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.gold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppTheme.gold.withOpacity(0.3)),
                          ),
                          child: Text('+ Add',
                              style: GoogleFonts.outfit(
                                  color: AppTheme.gold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: _AthleteCard(athlete: athletes[i]),
              ),
              childCount: athletes.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class _CoachStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _CoachStat(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.bebasNeue(color: color, fontSize: 40)),
        Text(label,
            style: GoogleFonts.outfit(
                color: AppTheme.textSecondary,
                fontSize: 10,
                letterSpacing: 1.5)),
      ],
    );
  }
}

class _AthleteCard extends StatelessWidget {
  final Athlete athlete;

  const _AthleteCard({required this.athlete});

  @override
  Widget build(BuildContext context) {
    Color scoreColor = athlete.avgScore >= 90
        ? AppTheme.gold
        : athlete.avgScore >= 85
            ? AppTheme.green
            : AppTheme.textSecondary;

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
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(athlete.initials,
                  style: GoogleFonts.outfit(
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(athlete.name,
                    style: GoogleFonts.outfit(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                Text('${athlete.club} • ${athlete.sessions} sessions',
                    style: GoogleFonts.outfit(
                        color: AppTheme.textSecondary, fontSize: 12)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: athlete.avgScore / 100,
                    backgroundColor: AppTheme.cardBorder,
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Text(athlete.avgScore.toStringAsFixed(1),
              style: GoogleFonts.bebasNeue(color: scoreColor, fontSize: 28)),
        ],
      ),
    );
  }
}
