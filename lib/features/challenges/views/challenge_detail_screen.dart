import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:fitness_app/features/challenges/services/challenge_progress.dart';
import 'package:fitness_app/features/challenges/views/challenge_day_screen.dart';
import 'package:fitness_app/features/challenges/widgets/challenge_hero_banner.dart';
import 'package:fitness_app/features/challenges/widgets/week_track.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:flutter/material.dart';

/// Challenge detail — Figma 11:1744.
///
/// Hero banner, then one [WeekTrack] per week, locked in the order the user
/// actually has to complete them.
class ChallengeDetailScreen extends StatefulWidget {
  final ChallengeProgramModel challenge;

  const ChallengeDetailScreen({super.key, required this.challenge});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  ChallengeProgress? _progress;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final progress = await ChallengeProgress.resolve(widget.challenge);
    if (!mounted) return;
    setState(() => _progress = progress);
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final progress = _progress;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: WorkoutAppBar(showFavorite: false, title: challenge.title),
      body: progress == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              physics: const BouncingScrollPhysics(),
              children: [
                // Hero (12:1854) — "28 Days" pill over the two-tone title.
                ChallengeHeroBanner(
                  contentPadding: const EdgeInsets.only(left: 16, top: 46),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Days pill (12:1891)
                      Container(
                        height: 17.23,
                        width: 59,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 9.572),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFEFD),
                          borderRadius: BorderRadius.circular(5.743),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40000000),
                              blurRadius: 0.957,
                            ),
                          ],
                        ),
                        child: Text(
                          challenge.daysLabel,
                          style: const TextStyle(
                            fontSize: 7.658,
                            height: 1,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      10.heightBox,

                      // Two-tone title (12:1872)
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: challenge.titleLead),
                            TextSpan(
                              text: challenge.titleAccent,
                              style: const TextStyle(color: AppColors.primary),
                            ),
                          ],
                        ),
                        style: const TextStyle(
                          fontSize: 24.98,
                          height: 1,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                28.heightBox,

                // Week tracks (12:2014), 22 apart
                ...List.generate(challenge.weeks.length, (index) {
                  final week = challenge.weeks[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == challenge.weeks.length - 1 ? 0 : 22,
                    ),
                    child: WeekTrack(
                      title: week.title,
                      subtitle: week.subtitle,
                      statuses: List.generate(
                        week.days.length,
                        (dayIndex) => progress.statusOf(index, dayIndex),
                      ),
                      onDaySelected: (dayIndex) async {
                        await context.push(
                          ChallengeDayScreen(
                            challenge: challenge,
                            week: week,
                            day: week.days[dayIndex],
                            weekNumber: index + 1,
                            isUnlocked: progress.isDayUnlocked(
                              index,
                              dayIndex,
                            ),
                            currentPositionLabel: progress
                                .currentPositionLabel,
                          ),
                        );
                        // A workout may have just finished — reflect it.
                        await _load();
                      },
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
