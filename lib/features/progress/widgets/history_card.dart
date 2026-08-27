import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_extension.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Date/time formatting shared by the Progress screen and the History screen.
class SessionFormat {
  SessionFormat._();

  static const List<String> _shortMonths = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  static const List<String> _longMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String two(int value) => value.toString().padLeft(2, '0');

  /// "04:13 PM" — Figma 17:1634.
  static String clock(DateTime at) {
    final hour = at.hour % 12 == 0 ? 12 : at.hour % 12;
    final suffix = at.hour < 12 ? 'AM' : 'PM';
    return '${two(hour)}:${two(at.minute)} $suffix';
  }

  /// "AUG 12" — Figma 17:1642.
  static String shortDate(DateTime at) =>
      '${_shortMonths[at.month - 1]} ${at.day}';

  /// "04:13" — Figma 17:1647.
  static String duration(int seconds) =>
      '${two(seconds ~/ 60)}:${two(seconds % 60)}';

  /// "August 2026" — the section header, Figma 17:1626.
  static String monthTitle(DateTime at) =>
      '${_longMonths[at.month - 1]} ${at.year}';

  /// Sort/group key so two Augusts a year apart stay separate.
  static String monthKey(DateTime at) => '${at.year}-${two(at.month)}';
}

/// One logged workout — Figma 17:1630.
///
/// 336x68, r15, hairline #F5F5F5 border, artwork tile flush to the left edge,
/// three stat columns split by 21pt rules and a trash button on the right.
class HistoryCard extends StatelessWidget {
  final SessionLog log;
  final VoidCallback? onDelete;

  const HistoryCard({super.key, required this.log, this.onDelete});

  /// "Day 2. Beginner" — the level is dropped when the log predates it or the
  /// flow never had one.
  String get _title =>
      log.dayLevel.isEmpty ? log.dayTitle : '${log.dayTitle}. ${log.dayLevel}';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF5F5F5), width: 0.4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise artwork (17:1631) — grey until the image resolves.
          SessionThumbnail(url: log.thumbnailUrl),

          const SizedBox(width: 4.6),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6.6, right: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    log.planTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    _title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  8.heightBox,

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _stat(
                        SessionFormat.clock(log.completedAt),
                        SessionFormat.shortDate(log.completedAt),
                      ),
                      _divider,
                      _stat(
                        SessionFormat.duration(log.durationSeconds),
                        'Duration',
                      ),
                      _divider,
                      _stat('${log.calories}', 'Kcal'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Trash button (17:1652) — 16pt glyph, centred against the 68pt row.
          GestureDetector(
            onTap: onDelete,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 26.6, 5.4, 6),
              child: SvgPicture.asset(
                'assets/svgs/trash.svg',
                width: 13.01,
                height: 14.34,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const Widget _divider = Padding(
    padding: EdgeInsets.symmetric(horizontal: 3),
    child: SizedBox(
      width: 0.6,
      height: 21,
      child: ColoredBox(color: AppColors.textLight),
    ),
  );

  Widget _stat(String value, String label) {
    return SizedBox(
      width: 41,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: AppColors.textLight,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w300,
              color: Color(0xFFCECECE),
            ),
          ),
        ],
      ),
    );
  }
}

/// The 68pt r11.7 artwork tile (Figma 17:1631). Falls back to the designed
/// grey while the image loads and if it never does.
class SessionThumbnail extends StatelessWidget {
  final String url;
  final double size;

  const SessionThumbnail({super.key, required this.url, this.size = 68.42});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(11.704),
      ),
      child: url.isEmpty
          ? null
          : Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : const SizedBox.shrink(),
            ),
    );
  }
}
