import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/routes/nav_extension.dart';
import 'package:fitness_app/features/challenges/models/challenge_program_model.dart';
import 'package:fitness_app/features/challenges/services/challenge_repository.dart';
import 'package:fitness_app/features/challenges/views/challenge_detail_screen.dart';
import 'package:fitness_app/features/home/widgets/challenge_card_widget.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:flutter/material.dart';

/// Challenges grid — Figma 11:1397.
///
/// Two columns of the shared [ChallengeCardWidget] at [ChallengeCardWidget
/// .gridScale]; 16.7 between columns, 12.2 between rows.
class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  late Future<List<ChallengeProgramModel>> _challengesFuture;

  @override
  void initState() {
    super.initState();
    _challengesFuture = ChallengeRepository.loadChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: WorkoutAppBar(showFavorite: false, title: 'Challenges'),
      body: FutureBuilder<List<ChallengeProgramModel>>(
        future: _challengesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final challenges = snapshot.data ?? const <ChallengeProgramModel>[];
          if (challenges.isEmpty) {
            return const Center(child: Text('No challenges yet'));
          }

          return GridView.builder(
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
                  challenge: challenge.card,
                  scale: ChallengeCardWidget.gridScale,
                  onTap: () =>
                      context.push(ChallengeDetailScreen(challenge: challenge)),
                  onJoin: () =>
                      context.push(ChallengeDetailScreen(challenge: challenge)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
