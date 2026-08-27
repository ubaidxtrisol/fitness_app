import 'package:fitness_app/features/challenges/services/challenge_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// The bundled JSON authors every challenge with the same 4 weeks x 7 days
/// (28 days) regardless of its `days_label` ("14 Days", "60 Days", ...) —
/// [ChallengeRepository] re-chunks the authored days into the real week
/// layout that length implies: full 7-day weeks, remainder in the last one.
void main() {
  // rootBundle (challenges.json) needs the binding up.
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a 28-day challenge (already a clean multiple of 7) is unchanged', () async {
    final challenges = await ChallengeRepository.loadChallenges();
    final challenge = challenges.firstWhere((c) => c.id == 'chal_flat_belly');

    expect(challenge.weeks.length, 4);
    expect(challenge.weeks.map((w) => w.days.length).toList(), [7, 7, 7, 7]);
  });

  test('a 14-day challenge becomes two full weeks', () async {
    final challenges = await ChallengeRepository.loadChallenges();
    final challenge = challenges.firstWhere((c) => c.id == 'chal_wall_pilates');

    expect(challenge.weeks.length, 2);
    expect(challenge.weeks.map((w) => w.days.length).toList(), [7, 7]);
  });

  test('a 15-day challenge leaves a 1-day final week', () async {
    final challenges = await ChallengeRepository.loadChallenges();
    final challenge = challenges.firstWhere((c) => c.id == 'chal_barre_workout');

    expect(challenge.weeks.length, 3);
    expect(challenge.weeks.map((w) => w.days.length).toList(), [7, 7, 1]);
  });

  test('a 60-day challenge cycles the authored days to fill it out', () async {
    final challenges = await ChallengeRepository.loadChallenges();
    final challenge = challenges.firstWhere(
      (c) => c.id == 'chal_strength_training',
    );

    expect(challenge.weeks.length, 9);
    expect(
      challenge.weeks.map((w) => w.days.length).toList(),
      [7, 7, 7, 7, 7, 7, 7, 7, 4],
      reason: '60 = 8 full weeks of 7 plus a 4-day ninth week',
    );

    final totalDays = challenge.weeks.fold(0, (sum, w) => sum + w.days.length);
    expect(totalDays, 60);

    // Every generated day still carries real, resolved exercise content —
    // cycling through the authored pool must not produce empty days.
    for (final week in challenge.weeks) {
      for (final day in week.days) {
        expect(day.exercises, isNotEmpty);
      }
    }
  });

  test('day ids and titles reset per week regardless of the cycle', () async {
    final challenges = await ChallengeRepository.loadChallenges();
    final challenge = challenges.firstWhere(
      (c) => c.id == 'chal_strength_training',
    );

    for (final week in challenge.weeks) {
      expect(
        week.days.map((d) => d.id).toList(),
        List.generate(week.days.length, (i) => 'day_${i + 1}'),
      );
      expect(
        week.days.map((d) => d.title).toList(),
        List.generate(week.days.length, (i) => 'Day ${i + 1}'),
      );
    }
  });
}
