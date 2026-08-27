import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:flutter/material.dart';

/// Confirmation for the history card's trash button — deleting a log is not
/// undoable, so both surfaces ask first.
Future<bool> confirmSessionDelete(BuildContext context, SessionLog log) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Delete this workout?',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      content: Text(
        '${log.planTitle} · ${log.dayTitle} will be removed from your '
        'history. Your streak and totals will update.',
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textLight,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancel',
            style: TextStyle(fontSize: 13, color: AppColors.textLight),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Delete',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    ),
  );

  return result ?? false;
}
