import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/features/progress/widgets/history_card.dart';
import 'package:flutter/material.dart';

/// A month of logged workouts inside one white panel — Figma 17:1628 on the
/// Progress screen and 17:1689 on the History screen.
///
/// [onSeeAll] renders the header's trailing link; the History screen passes
/// null because it is already the "see all" destination.
class HistoryMonthCard extends StatelessWidget {
  final String title;
  final List<SessionLog> sessions;
  final VoidCallback? onSeeAll;
  final void Function(SessionLog log)? onDelete;

  /// Shown instead of the rows when [sessions] is empty.
  final Widget? placeholder;

  const HistoryMonthCard({
    super.key,
    required this.title,
    required this.sessions,
    this.onSeeAll,
    this.onDelete,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 9, 13, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              ),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6C434C),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          16.heightBox,

          if (sessions.isEmpty)
            placeholder ?? const SizedBox.shrink()
          else
            for (var i = 0; i < sessions.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: i == sessions.length - 1 ? 0 : 11,
                ),
                child: HistoryCard(
                  log: sessions[i],
                  onDelete: onDelete == null
                      ? null
                      : () => onDelete!(sessions[i]),
                ),
              ),
        ],
      ),
    );
  }
}

/// Groups logs into month buckets, newest month first and newest log first
/// inside each. Shared by both history surfaces.
List<MapEntry<String, List<SessionLog>>> groupSessionsByMonth(
  List<SessionLog> sessions,
) {
  final buckets = <String, List<SessionLog>>{};

  for (final session in sessions) {
    buckets
        .putIfAbsent(SessionFormat.monthKey(session.completedAt), () => [])
        .add(session);
  }

  final keys = buckets.keys.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final key in keys)
      MapEntry(
        SessionFormat.monthTitle(buckets[key]!.first.completedAt),
        buckets[key]!
          ..sort((a, b) => b.completedAt.compareTo(a.completedAt)),
      ),
  ];
}
