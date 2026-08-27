import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/workout/models/program_model.dart';
import 'package:fitness_app/features/workout/views/day_detail_screen.dart';
import 'package:fitness_app/features/workout/widgets/phase_header.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:fitness_app/features/workout/widgets/workout_hero_banner.dart';
import 'package:fitness_app/features/workout/widgets/workout_row_card.dart';
import 'package:flutter/material.dart';

/// Program overview — Figma `Home` 10:509.
///
/// Hero banner, then one block per phase: a header with the completion pill
/// followed by the phase's day rows.
class ProgramDetailScreen extends StatefulWidget {
  final ProgramModel program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  State<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final program = widget.program;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: WorkoutAppBar(
        isFavorite: _isFavorite,
        onFavoriteToggled: () => setState(() => _isFavorite = !_isFavorite),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 11, 16, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // Hero banner (10:729) with the two-line program title (11:847/11:848).
          WorkoutHeroBanner(
            contentPadding: const EdgeInsets.only(left: 19, top: 61),
            child: Text(
              '${program.title}\n${program.subtitle}',
              style: const TextStyle(
                fontSize: 16,
                height: 1.15,
                fontWeight: FontWeight.w700,
                color: Color(0xFFA32045),
              ),
            ),
          ),
          14.heightBox,

          // One block per phase, 14 apart (13:2593).
          ...List.generate(program.phases.length, (phaseIndex) {
            final phase = program.phases[phaseIndex];

            return Padding(
              padding: EdgeInsets.only(
                bottom: phaseIndex == program.phases.length - 1 ? 0 : 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhaseHeader(
                    title: phase.title,
                    subtitle: phase.subtitle,
                    // Only the first phase carries the pill in the design.
                    progressPercent: phaseIndex == 0
                        ? phase.progressPercent
                        : null,
                  ),
                  14.heightBox,
                  ...List.generate(phase.days.length, (dayIndex) {
                    final day = phase.days[dayIndex];

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: dayIndex == phase.days.length - 1 ? 0 : 11,
                      ),
                      child: WorkoutRowCard.day(
                        title: day.title,
                        subtitle: day.summaryLabel,
                        thumbnailUrl: day.thumbnailUrl,
                        badge: (dayIndex + 1).toString().padLeft(2, '0'),
                        onTap: () => context.push(
                          DayDetailScreen(
                            day: day,
                            phase: phase,
                            programName: '${program.title} ${program.subtitle}',
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
