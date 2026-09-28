import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/challenges/services/challenge_progress.dart';
import 'package:fitness_app/features/workout/models/phase_definitions.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:fitness_app/features/workout/services/programs_progress.dart';
import 'package:fitness_app/features/workout/services/workout_repository.dart';
import 'package:fitness_app/features/workout/views/day_detail_screen.dart';
import 'package:fitness_app/features/workout/widgets/step_lock_dialog.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:fitness_app/features/workout/widgets/workout_hero_banner.dart';
import 'package:fitness_app/features/workout/widgets/workout_row_card.dart';
import 'package:flutter/material.dart';

/// The Phases program — Figma 10:509.
///
/// Hero banner (10:729, shared with `DayDetailScreen`'s), then 4 fixed
/// stages ([kPhaseDefinitions] — Figma 11:732/11:733, static text, not
/// data-driven), each with its own completion ring (11:763) and however
/// many days are actually loaded for that day range (`ProgramsProgress`
/// buckets the flat, API-loaded day list into them). Tapping a day opens
/// its exercise list directly (11:738, unchanged, via [DayDetailScreen]) —
/// a day's own exercises are already the "workout", no extra layer in
/// between.
///
/// Reached from the Home hero banner's default ("Keep Walking, Keep Going")
/// state; once a day is actually in progress the banner jumps straight to
/// it instead (see `NextUpService`/`HomeHeroBanner`).
class PhasesScreen extends StatefulWidget {
  const PhasesScreen({super.key});

  @override
  State<PhasesScreen> createState() => _PhasesScreenState();
}

class _PhasesScreenState extends State<PhasesScreen> {
  ProgramsProgress? _progress;
  bool _loaded = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final categories = await WorkoutRepository.loadPrograms();
    final progress = await ProgramsProgress.resolve(categories);
    if (!mounted) return;
    setState(() {
      _progress = progress;
      _loaded = true;
    });
  }

  Future<void> _openDay(int phaseIndex, int dayIndex) async {
    final progress = _progress!;
    final ref = progress.refAt(phaseIndex, dayIndex);

    if (!progress.isDayUnlocked(phaseIndex, dayIndex)) {
      showStepLockedDialog(
        context,
        currentPositionLabel: progress.currentPositionLabel,
        message: progress.currentPositionLabel.isEmpty
            ? "Finish the days before this one to unlock it."
            : "You're currently on ${progress.currentPositionLabel}. Complete "
                  "it before moving ahead — that's how the Phases program works.",
      );
      return;
    }

    final fields = progress.planFieldsFor(ref);
    await context.push(
      DayDetailScreen(
        day: DayModel.fromJson(ref.day.toJson()),
        programName: kPhasesProgramTitle,
        programId: fields.planId,
        dayIndex: fields.dayIndex,
        totalDays: fields.totalDays,
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _progress;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: WorkoutAppBar(
        isFavorite: _isFavorite,
        onFavoriteToggled: () => setState(() => _isFavorite = !_isFavorite),
      ),
      body: !_loaded || progress == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 11, 16, 28),
              physics: const BouncingScrollPhysics(),
              children: [
                // Hero banner (10:729) — "Pilates / Premier" over the shared
                // program artwork.
                WorkoutHeroBanner(
                  contentPadding: const EdgeInsets.only(left: 22, top: 46),
                  child: Text(
                    kPhasesProgramTitle.replaceFirst(' ', '\n'),
                    style: const TextStyle(
                      fontSize: 24,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                24.heightBox,
                ...List.generate(kPhaseDefinitions.length, (phaseIndex) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: phaseIndex == kPhaseDefinitions.length - 1
                          ? 0
                          : 24,
                    ),
                    child: _PhaseSection(
                      phaseIndex: phaseIndex,
                      progress: progress,
                      onDaySelected: (dayIndex) =>
                          _openDay(phaseIndex, dayIndex),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}

/// One static phase's heading (11:732 "Phase n" / 11:733 the phase name)
/// plus its completion ring (11:763) and whatever days are actually loaded
/// for its day range.
class _PhaseSection extends StatelessWidget {
  final int phaseIndex;
  final ProgramsProgress progress;
  final void Function(int dayIndex) onDaySelected;

  const _PhaseSection({
    required this.phaseIndex,
    required this.progress,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final phase = kPhaseDefinitions[phaseIndex];
    final days = progress.daysInPhase(phaseIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              phase.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFA32045),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                phase.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            _PhaseRing(percent: progress.percentForPhase(phaseIndex)),
          ],
        ),
        12.heightBox,
        if (days.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Coming soon',
              style: TextStyle(fontSize: 12, color: AppColors.textLight),
            ),
          )
        else
          ...List.generate(days.length, (dayIndex) {
            final ref = days[dayIndex];
            final status = progress.statusOf(phaseIndex, dayIndex);

            return Padding(
              padding: EdgeInsets.only(
                bottom: dayIndex == days.length - 1 ? 0 : 10,
              ),
              child: Opacity(
                opacity: status == ChallengeDayStatus.locked ? 0.6 : 1,
                child: WorkoutRowCard.day(
                  title: ref.day.title,
                  subtitle:
                      '${ref.day.durationMinutes} min . ${ref.day.exercises.length} Exercise',
                  thumbnailUrl: ref.day.thumbnailUrl,
                  badge: '${phase.startDay + dayIndex}'.padLeft(2, '0'),
                  isDone: status == ChallengeDayStatus.completed,
                  onTap: () => onDaySelected(dayIndex),
                ),
              ),
            );
          }),
      ],
    );
  }
}

/// Figma 11:763 — a thin ring with the phase's own percent centred inside.
class _PhaseRing extends StatelessWidget {
  final double percent;

  const _PhaseRing({required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percent,
            strokeWidth: 2.5,
            backgroundColor: AppColors.primaryLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          Text(
            '${(percent * 100).round()}%',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
