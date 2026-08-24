import 'dart:developer';

import 'package:fitness_app/core/constants/routes/route_tracker.dart';
import 'package:fitness_app/core/services/firebase/fa_services.dart';
import 'package:flutter/cupertino.dart';

extension NavContext on BuildContext {
  Future<T?> push<T extends Object?>(Widget name, {String? routeName}) {
    final target = routeName ?? name.runtimeType.toString();
    RouteTracker.currentRoute = target;

    log('Navigate to: [$target]');
    FAServices.instance.logScreenView(screenName: target);
    return Navigator.of(this).push<T>(
      CupertinoPageRoute(
        builder: (_) => name,
        settings: RouteSettings(name: target),
      ),
    );
  }

  Future<T?> pushName<T extends Object?>(String name, {Object? args}) {
    final current = RouteTracker.currentRoute;
    RouteTracker.currentRoute = name;

    if (current == name) {
      log('⚠️ Already on $name, navigation skipped.');
      return Future.value(null);
    }

    log('Navigate to: [$name]');
    FAServices.instance.logScreenView(screenName: name);
    return Navigator.of(this).pushNamed<T>(name, arguments: args);
  }

  Future<T?> pushReplacement<T extends Object?>(
    Widget name, {
    String? routeName,
  }) async {
    final target = routeName ?? name.runtimeType.toString();
    RouteTracker.currentRoute = target;

    log('Navigate to: [$target]');
    FAServices.instance.logScreenView(screenName: target);
    return Navigator.of(this).pushReplacement(
      CupertinoPageRoute(
        builder: (_) => name,
        settings: RouteSettings(name: target),
      ),
    );
  }

  Future<T?> pushReplacementName<T extends Object?, TO extends Object?>(
    String name, {
    Object? args,
    TO? result,
  }) {
    RouteTracker.currentRoute = name;

    FAServices.instance.logScreenView(screenName: name);
    return Navigator.of(
      this,
    ).pushReplacementNamed<T, TO>(name, arguments: args, result: result);
  }

  Future<T?> pushAndRemoveUntilName<T extends Object?, TO extends Object?>(
    String name, {
    Object? args,
    TO? result,
  }) async {
    RouteTracker.currentRoute = name;
    FAServices.instance.logScreenView(screenName: name);
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil<T>(name, (route) => false, arguments: args);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Widget name, {
    Object? args,
  }) async {
    RouteTracker.currentRoute = name.runtimeType.toString();
    FAServices.instance.logScreenView(screenName: name.runtimeType.toString());
    return Navigator.of(this).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (_) => name,
        settings: RouteSettings(name: name.runtimeType.toString()),
      ),
      (route) => false,
    );
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
}
