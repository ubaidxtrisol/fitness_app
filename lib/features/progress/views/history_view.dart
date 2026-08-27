import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/repositories/progress_repository.dart';
import 'package:fitness_app/features/progress/widgets/delete_session_dialog.dart';
import 'package:fitness_app/features/progress/widgets/history_month_card.dart';
import 'package:fitness_app/features/workout/widgets/workout_app_bar.dart';
import 'package:flutter/material.dart';

/// The "See All" destination — every logged workout, newest month first.
/// Figma 17:1688.
class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final ProgressRepository _progress = ProgressRepository();

  List<SessionLog> _sessions = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sessions = await _progress.recentSessions(limit: 500);
    if (!mounted) return;
    setState(() {
      _sessions = sessions;
      _loading = false;
    });
  }

  Future<void> _deleteSession(SessionLog log) async {
    final confirmed = await confirmSessionDelete(context, log);
    if (!confirmed) return;

    await _progress.deleteSession(log.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final months = groupSessionsByMonth(_sessions);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const WorkoutAppBar(showFavorite: false, title: 'History'),
      body: SafeArea(
        top: false,
        child: Builder(
          builder: (context) {
            if (_loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (months.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Nothing here yet.\n'
                    'Every workout you finish gets logged on this screen.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                      height: 1.5,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: months.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => HistoryMonthCard(
                title: months[index].key,
                sessions: months[index].value,
                onDelete: _deleteSession,
              ),
            );
          },
        ),
      ),
    );
  }
}
