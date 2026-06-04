import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class ProgressScreen extends StatefulWidget {
  final List<ScoringSession> sessions;
  const ProgressScreen({super.key, required this.sessions});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _period = 0; // 0=Week, 1=Month, 2=Year

  @override
  Widget build(BuildContext context) {
    final weeklyScores = SampleData.getWeeklyScores();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with period selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Progress',
                          style: GoogleFonts.outfit(
                              color: AppTheme.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w700)),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.navyCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.cardBorder),
                        ),
                        child: Row(
                          children: ['Week', 'Month', 'Year']
                              .asMap()
                              .entries
                              .map((e) => GestureDetector(
                                    onTap: () =>
                                        setState(() => _period = e.key),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _period == e.key
                                            ? AppTheme.gold
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(e.value,
                                          style: GoogleFonts.outfit(
                                              color: _period == e.key
                                                  ? AppTheme.navy
                                                  : AppTheme.textSecondary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Average score
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF1A2E4A), Color(0xFF0F1E35)]),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.gold.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AVERAGE SCORE',
                            style: GoogleFonts.outfit(
                                color: AppTheme.gold,
                                fontSize: 11,
                                letterSpacing: 2)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('89.7',
                                style: GoogleFonts.bebasNeue(
                                    color: AppTheme.gold, fontSize: 48)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.trending_up,
                                      color: AppTheme.green, size: 14),
                                  const SizedBox(width: 4),
                                  Text('+4.2%',
                                      style: GoogleFonts.outfit(
                                          color: AppTheme.green,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Line chart
                        SizedBox(
                          height: 120,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (v) => FlLine(
                                  color: AppTheme.cardBorder,
                                  strokeWidth: 1,
                                ),
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (v, meta) => Text(
                                      days[v.toInt().clamp(0, 6)],
                                      style: GoogleFonts.outfit(
                                          color: AppTheme.textSecondary,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: weeklyScores
                                      .asMap()
                                      .entries
                                      .map((e) => FlSpot(
                                          e.key.toDouble(), e.value))
                                      .toList(),
                                  isCurved: true,
                                  color: AppTheme.gold,
                                  barWidth: 2.5,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter: (s, _, __, ___) =>
                                        FlDotCirclePainter(
                                            radius: 3,
                                            color: AppTheme.gold,
                                            strokeWidth: 0),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.gold.withOpacity(0.3),
                                        AppTheme.gold.withOpacity(0),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                              minY: 80,
                              maxY: 100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _StatCard('PERSONAL BEST', '96.8', 'April 14, 2026', AppTheme.gold),
                      _StatCard('SESSIONS', '48', 'This month', AppTheme.textPrimary),
                      _StatCard('SHOTS FIRED', '480', 'Total', AppTheme.textPrimary),
                      _StatCard('STREAK 🔥', '12', 'Days active', AppTheme.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;

  const _StatCard(this.label, this.value, this.sub, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.navyCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.outfit(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                  letterSpacing: 1.5)),
          Text(value,
              style: GoogleFonts.bebasNeue(color: color, fontSize: 30)),
          Text(sub,
              style: GoogleFonts.outfit(
                  color: AppTheme.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}
