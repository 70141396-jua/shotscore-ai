import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = SampleData.getBadges();
    final earned = badges.where((b) => b.earned).toList();
    final locked = badges.where((b) => !b.earned).toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Achievements',
                      style: GoogleFonts.outfit(
                          color: AppTheme.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),

                  // Streak banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.green.withOpacity(0.2),
                          AppTheme.green.withOpacity(0.05)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppTheme.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CURRENT STREAK',
                                style: GoogleFonts.outfit(
                                    color: AppTheme.green,
                                    fontSize: 11,
                                    letterSpacing: 2)),
                            Text('12 DAYS',
                                style: GoogleFonts.bebasNeue(
                                    color: AppTheme.textPrimary,
                                    fontSize: 32)),
                            Text('Keep shooting daily!',
                                style: GoogleFonts.outfit(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text('Badges (${earned.length} / ${badges.length})',
                      style: GoogleFonts.outfit(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _BadgeTile(
                    badge: i < earned.length
                        ? earned[i]
                        : locked[i - earned.length]),
                childCount: badges.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final Badge badge;
  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: badge.earned
            ? AppTheme.navyCard
            : AppTheme.navyCard.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: badge.earned
              ? AppTheme.gold.withOpacity(0.3)
              : AppTheme.cardBorder.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            badge.earned ? badge.emoji : '🔒',
            style: TextStyle(
              fontSize: 28,
              color: badge.earned ? null : Colors.white24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            badge.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: badge.earned
                  ? AppTheme.textPrimary
                  : AppTheme.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            badge.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: AppTheme.textMuted,
              fontSize: 9,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
