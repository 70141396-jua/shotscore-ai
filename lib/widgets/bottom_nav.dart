import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ShotScoreBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ShotScoreBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(Icons.home_rounded, Icons.home_outlined, 'Home'),
      _NavItem(Icons.camera_alt_rounded, Icons.camera_alt_outlined, 'Score'),
      _NavItem(Icons.trending_up_rounded, Icons.trending_up_outlined, 'Progress'),
      _NavItem(Icons.emoji_events_rounded, Icons.emoji_events_outlined, 'Badges'),
      _NavItem(Icons.people_rounded, Icons.people_outline_rounded, 'Coach'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.navyLight,
        border: Border(top: BorderSide(color: AppTheme.cardBorder, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((e) {
              final isActive = currentIndex == e.key;
              return GestureDetector(
                onTap: () => onTap(e.key),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.gold.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? e.value.activeIcon : e.value.icon,
                        color: isActive ? AppTheme.gold : AppTheme.textMuted,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        e.value.label,
                        style: GoogleFonts.outfit(
                          color: isActive ? AppTheme.gold : AppTheme.textMuted,
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isActive ? 4 : 0,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppTheme.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  const _NavItem(this.activeIcon, this.icon, this.label);
}
