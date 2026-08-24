import 'package:flutter/material.dart';

class Ctx {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static NavigatorState? get navigator => navigatorKey.currentState;

  static BuildContext? get context => navigator?.overlay?.context;
}
