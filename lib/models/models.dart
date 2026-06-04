import 'dart:math';

class ShotResult {
  final double score;
  final double x; // normalized 0-1
  final double y; // normalized 0-1
  final int shotNumber;

  ShotResult({
    required this.score,
    required this.x,
    required this.y,
    required this.shotNumber,
  });

  String get scoreColor {
    if (score >= 10.0) return 'gold';
    if (score >= 9.0) return 'green';
    if (score >= 7.0) return 'normal';
    return 'red';
  }
}

class ScoringSession {
  final String id;
  final DateTime timestamp;
  final List<ShotResult> shots;
  final String sessionName;

  ScoringSession({
    required this.id,
    required this.timestamp,
    required this.shots,
    required this.sessionName,
  });

  double get totalScore => shots.fold(0, (sum, s) => sum + s.score);
  double get averageScore => shots.isEmpty ? 0 : totalScore / shots.length;
  double get bestShot => shots.isEmpty ? 0 : shots.map((s) => s.score).reduce(max);
  double get lowestShot => shots.isEmpty ? 0 : shots.map((s) => s.score).reduce(min);
  int get shotCount => shots.length;
}

class Athlete {
  final String id;
  final String name;
  final String initials;
  final String club;
  final int sessions;
  final double avgScore;

  Athlete({
    required this.id,
    required this.name,
    required this.initials,
    required this.club,
    required this.sessions,
    required this.avgScore,
  });
}

class Badge {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final bool earned;

  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.earned,
  });
}

// Sample data
class SampleData {
  static List<ScoringSession> getSessions() {
    final random = Random(42);
    return [
      ScoringSession(
        id: '1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        sessionName: 'Morning Practice',
        shots: List.generate(10, (i) {
          double base = 8.5 + random.nextDouble() * 1.5;
          double angle = random.nextDouble() * 2 * pi;
          double radius = (10.5 - base) / 10.5 * 0.35;
          return ShotResult(
            score: double.parse(base.toStringAsFixed(1)),
            x: 0.5 + cos(angle) * radius + (random.nextDouble() - 0.5) * 0.05,
            y: 0.5 + sin(angle) * radius + (random.nextDouble() - 0.5) * 0.05,
            shotNumber: i + 1,
          );
        }),
      ),
      ScoringSession(
        id: '2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        sessionName: 'Evening Training',
        shots: List.generate(10, (i) {
          double base = 8.0 + random.nextDouble() * 2.0;
          double angle = random.nextDouble() * 2 * pi;
          double radius = (10.5 - base) / 10.5 * 0.35;
          return ShotResult(
            score: double.parse(base.toStringAsFixed(1)),
            x: 0.5 + cos(angle) * radius + (random.nextDouble() - 0.5) * 0.05,
            y: 0.5 + sin(angle) * radius + (random.nextDouble() - 0.5) * 0.05,
            shotNumber: i + 1,
          );
        }),
      ),
      ScoringSession(
        id: '3',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        sessionName: 'Club Session',
        shots: List.generate(10, (i) {
          double base = 7.5 + random.nextDouble() * 2.5;
          double angle = random.nextDouble() * 2 * pi;
          double radius = (10.5 - base) / 10.5 * 0.35;
          return ShotResult(
            score: double.parse(base.toStringAsFixed(1)),
            x: 0.5 + cos(angle) * radius + (random.nextDouble() - 0.5) * 0.05,
            y: 0.5 + sin(angle) * radius + (random.nextDouble() - 0.5) * 0.05,
            shotNumber: i + 1,
          );
        }),
      ),
    ];
  }

  static List<double> getWeeklyScores() => [85.2, 87.1, 86.8, 89.3, 91.0, 92.4, 90.1];

  static List<Athlete> getAthletes() => [
        Athlete(id: '1', name: 'Sabeer Ahmad', initials: 'SA', club: 'UoL & HEC Shooter', sessions: 48, avgScore: 92.4),
        Athlete(id: '2', name: 'Reena Alam', initials: 'RA', club: 'UoL, HEC & HUFC Coach', sessions: 36, avgScore: 88.1),
        Athlete(id: '3', name: 'Simran B. Akbar', initials: 'SB', club: 'LGU & HEC Shooter', sessions: 29, avgScore: 84.5),
        Athlete(id: '4', name: 'Sajila Karim', initials: 'SK', club: 'UoL Shooter', sessions: 22, avgScore: 81.2),
      ];

  static List<Badge> getBadges() => [
        Badge(id: '1', title: 'First Shot', description: 'Score your first target', emoji: '🎯', earned: true),
        Badge(id: '2', title: 'Perfectionist', description: 'Score 90+ in a session', emoji: '⭐', earned: true),
        Badge(id: '3', title: 'On Fire', description: '7-day streak', emoji: '🔥', earned: true),
        Badge(id: '4', title: 'Consistent', description: '10 sessions done', emoji: '🏅', earned: true),
        Badge(id: '5', title: 'Diamond Shot', description: 'Score 10.0 on a shot', emoji: '💎', earned: true),
        Badge(id: '6', title: 'Improver', description: '+5 points in a week', emoji: '📈', earned: true),
        Badge(id: '7', title: 'Century', description: '100 sessions', emoji: '👑', earned: false),
        Badge(id: '8', title: 'Legend', description: 'Top 1% accuracy', emoji: '🌟', earned: false),
        Badge(id: '9', title: 'Rocket', description: '50% improvement', emoji: '🚀', earned: false),
      ];
}
