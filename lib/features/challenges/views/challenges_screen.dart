import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/core/database/repositories/joined_challenges_repository.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:fitness_app/features/challenges/services/challenge_progress.dart';
import 'package:fitness_app/features/challenges/services/challenge_repository.dart';
import 'package:fitness_app/features/challenges/views/challenge_detail_screen.dart';
import 'package:fitness_app/features/home/models/home_models.dart';
import 'package:fitness_app/features/home/widgets/challenge_card_widget.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:flutter/material.dart';

/// Challenges grid — Figma 11:1397.
///
/// Two columns of the shared [ChallengeCardWidget] at [ChallengeCardWidget
/// .gridScale]; 16.7 between columns, 12.2 between rows. Joined challenges
/// show their real completion percentage instead of the Join pill; the pill
/// itself now actually joins (rather than just opening the detail screen).
class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  final JoinedChallengesRepository _joinedRepo = JoinedChallengesRepository();

  /// Null while the first load is in flight.
  List<ChallengeProgramModel>? _challenges;
  Map<String, ChallengeModel> _cards = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final challenges = await ChallengeRepository.loadChallenges();
    final joinedIds = (await _joinedRepo.all()).map((r) => r.challengeId).toSet();

    final cards = <String, ChallengeModel>{};
    for (final challenge in challenges) {
      if (!joinedIds.contains(challenge.id)) {
        cards[challenge.id] = challenge.card();
        continue;
      }
      final progress = await ChallengeProgress.resolve(challenge);
      cards[challenge.id] = challenge.card(
        isJoined: true,
        percentComplete: progress.percentComplete,
        isCompleted: progress.isComplete,
      );
    }

    if (!mounted) return;
    setState(() {
      _challenges = challenges;
      _cards = cards;
    });
  }

  Future<void> _join(ChallengeProgramModel challenge) async {
    await _joinedRepo.join(challenge.id);
    await _load();
  }

  Future<void> _open(ChallengeProgramModel challenge) async {
    await context.push(ChallengeDetailScreen(challenge: challenge));
    // Progress (or a Join tapped on the detail screen) may have changed.
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final challenges = _challenges;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: WorkoutAppBar(showFavorite: false, title: 'Challenges'),
      body: challenges == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : challenges.isEmpty
          ? const Center(child: Text('No challenges yet'))
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: challenges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.7,
                mainAxisSpacing: 12.2,
                // 172.256 x 216.463 — the card's own aspect at grid scale.
                childAspectRatio: 172.256 / 216.463,
              ),
              itemBuilder: (context, index) {
                final challenge = challenges[index];

                return Align(
                  alignment: Alignment.topLeft,
                  child: ChallengeCardWidget(
                    challenge: _cards[challenge.id] ?? challenge.card(),
                    scale: ChallengeCardWidget.gridScale,
                    onTap: () => _open(challenge),
                    onJoin: () => _join(challenge),
                  ),
                );
              },
            ),
    );
  }
}
