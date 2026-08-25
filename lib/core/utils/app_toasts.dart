import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:fitness_app/core/utils/context.dart';
import 'package:flutter/material.dart';

class AppToast {
  static BuildContext? get _context => Ctx.context;

  static void success({
    required String title,
    required String description,
    BuildContext? context,
  }) {
    final ctx = context ?? _context;
    if (ctx == null) return;

    CherryToast.success(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Nexa',
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontFamily: 'Nexa',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
      autoDismiss: true,
      animationDuration: const Duration(milliseconds: 300),
      toastDuration: const Duration(seconds: 4),
      borderRadius: 12,
      shadowColor: const Color(0x17000000),
    ).show(ctx);
  }

  static void warning({
    required String title,
    required String description,
    BuildContext? context,
  }) {
    final ctx = context ?? _context;
    if (ctx == null) return;

    CherryToast.warning(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Nexa',
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontFamily: 'Nexa',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
      autoDismiss: true,
      animationDuration: const Duration(milliseconds: 300),
      toastDuration: const Duration(seconds: 4),
      borderRadius: 12,
      shadowColor: const Color(0x17000000),
    ).show(ctx);
  }

  static void info({
    required String title,
    required String description,
    BuildContext? context,
  }) {
    final ctx = context ?? _context;
    if (ctx == null) return;

    CherryToast.info(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Nexa',
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontFamily: 'Nexa',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
      autoDismiss: true,
      animationDuration: const Duration(milliseconds: 300),
      toastDuration: const Duration(seconds: 4),
      borderRadius: 12,
      shadowColor: const Color(0x17000000),
    ).show(ctx);
  }

  static void error({
    required String title,
    required String description,
    BuildContext? context,
  }) {
    final ctx = context ?? _context;
    if (ctx == null) return;

    CherryToast.error(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Nexa',
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontFamily: 'Nexa',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      toastPosition: Position.top,
      animationType: AnimationType.fromTop,
      autoDismiss: true,
      animationDuration: const Duration(milliseconds: 300),
      toastDuration: const Duration(seconds: 4),
      borderRadius: 12,
      shadowColor: const Color(0x17000000),
    ).show(ctx);
  }
}
