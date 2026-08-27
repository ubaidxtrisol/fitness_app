import 'package:drift/native.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/exercise_prefs_repository.dart';
import 'package:fitness_app/core/database/repositories/settings_repository.dart';
import 'package:fitness_app/core/database/repositories/user_profile_repository.dart';
import 'package:fitness_app/features/player/models/player_session.dart';
import 'package:fitness_app/features/player/widgets/video_backdrop.dart';
import 'package:fitness_app/features/profile/unit_conversion.dart';
import 'package:fitness_app/features/discover/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ExerciseModel _exercise(String id, {int seconds = 35}) => ExerciseModel(
  order: 1,
  exerciseId: id,
  title: 'Glute Bridge',
  description: '',
  durationSeconds: seconds,
  reps: 0,
  restSeconds: 0,
  thumbnailUrl: 'https://example.com/a.jpg',
  videoUrl: 'https://example.com/a.mp4',
  howToDo: const [],
  commonMistakes: const [],
  breathingTips: const [],
);

void main() {
  late AppDatabase db;
  late ExercisePrefsRepository prefs;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    AppDatabase.overrideInstance(db);
    await db.customSelect('SELECT 1').get();
    prefs = ExercisePrefsRepository(db);
  });

  tearDown(() async => db.close());

  test('an untouched exercise has no cached duration', () async {
    expect(await prefs.durationFor('ex_glute_bridge'), isNull);
    expect(await prefs.durationsFor(['ex_glute_bridge']), isEmpty);
  });

  test('the stepper value survives and overwrites cleanly', () async {
    await prefs.setDuration('ex_glute_bridge', 45);
    expect(await prefs.durationFor('ex_glute_bridge'), 45);

    await prefs.setDuration('ex_glute_bridge', 60);
    expect(
      await prefs.durationFor('ex_glute_bridge'),
      60,
      reason: 'a second visit replaces rather than duplicates',
    );

    await prefs.clear('ex_glute_bridge');
    expect(await prefs.durationFor('ex_glute_bridge'), isNull);
  });

  test('durations are clamped to a runnable range', () async {
    await prefs.setDuration('ex_a', 1);
    expect(await prefs.durationFor('ex_a'), ExercisePrefsRepository.minSeconds);

    await prefs.setDuration('ex_b', 99999);
    expect(await prefs.durationFor('ex_b'), ExercisePrefsRepository.maxSeconds);
  });

  test('the player reads every override for a session in one go', () async {
    await prefs.setDuration('ex_a', 45);
    await prefs.setDuration('ex_c', 90);

    final map = await prefs.durationsFor(['ex_a', 'ex_b', 'ex_c', '']);

    expect(map, {'ex_a': 45, 'ex_c': 90});
    expect(
      map.containsKey('ex_b'),
      isFalse,
      reason: 'untouched exercises fall back to their clip length',
    );
  });

  test('Start Now opens the same run on the tapped exercise', () {
    final session = PlayerSession(
      exercises: [_exercise('ex_a'), _exercise('ex_b'), _exercise('ex_c')],
      workoutTitle: 'Pilates Premier · Day 2',
      planId: 'p1',
      planTitle: 'Pilates Premier',
      dayId: 'd2',
      dayTitle: 'Day 2',
      dayLevel: 'Beginner',
      dayIndex: 1,
      totalDays: 3,
    );

    final jumped = session.startingAt(2);

    expect(jumped.startIndex, 2);
    expect(jumped.planId, 'p1', reason: 'still logs against the same plan');
    expect(jumped.dayLevel, 'Beginner');
    expect(jumped.length, 3);
    expect(
      session.startingAt(9).startIndex,
      2,
      reason: 'an out-of-range index clamps to the last exercise',
    );
  });

  test('workout settings decide playback volume', () async {
    final settings = SettingsRepository(db);

    await settings.update(volume: 0.25, soundEffectEnabled: true);
    var row = await settings.load();
    expect(row.soundEffectEnabled ? row.volume : 0.0, closeTo(0.25, 0.001));

    await settings.update(soundEffectEnabled: false);
    row = await settings.load();
    expect(
      row.soundEffectEnabled ? row.volume : 0.0,
      0.0,
      reason: 'muting the sound effect mutes the clip',
    );
    expect(row.volume, closeTo(0.25, 0.001), reason: 'the level is remembered');
  });

  test('the profile screen reads back what the info flow collected', () async {
    final profiles = UserProfileRepository(db);

    await profiles.saveAnswers({
      'height': 171,
      'weight': 64,
      'target_weight': 58,
    }, markComplete: true);

    final profile = await profiles.load();
    expect(profile.heightCm, 171);
    expect(profile.weightKg, 64);
    expect(profile.targetWeightKg, 58);
  });

  test('imperial display round-trips back to the stored metric value', () {
    for (final kg in [45, 58, 64, 75, 92, 120]) {
      expect(lbsToKg(kgToLbs(kg)), kg, reason: '$kg kg');
    }
    for (final cm in [150, 160, 165, 171, 183, 195]) {
      expect(inchesToCm(cmToInches(cm)), closeTo(cm, 1), reason: '$cm cm');
    }
    expect(feetInches(165), "5'5\"");
    expect(kgToLbs(64), 141);
  });

  testWidgets('the video banner keeps the clip ratio and caps its height', (
    tester,
  ) async {
    Future<Size> render({required double maxHeight}) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 361,
                child: VideoBanner(
                  controller: null,
                  isReady: false,
                  maxHeight: maxHeight,
                ),
              ),
            ),
          ),
        ),
      );
      return tester.getSize(find.byType(ClipRRect).first);
    }

    // 16:9 is the assumed ratio until a clip reports its own.
    final wide = await render(maxHeight: 320);
    expect(wide.width, closeTo(361, 0.5));
    expect(wide.height, closeTo(361 * 9 / 16, 0.5));

    // Capping the height narrows the banner rather than stretching the clip.
    final capped = await render(maxHeight: 100);
    expect(capped.height, closeTo(100, 0.5));
    expect(capped.width, closeTo(100 * 16 / 9, 0.5));
  });
}
