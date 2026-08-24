import 'package:flutter/material.dart';

class RouteTracker extends RouteObserver<PageRoute<dynamic>> {
  static String? currentRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _updateRoute(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _updateRoute(previousRoute);
    } else {
      currentRoute = null;
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _updateRoute(newRoute);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    if (previousRoute != null) {
      _updateRoute(previousRoute);
    }
  }

  void _updateRoute(Route route) {
    final name = route.settings.name;
    if (name != null && name.isNotEmpty) {
      currentRoute = name;
    } else if (route is PageRoute) {
      currentRoute = route.runtimeType.toString();
    }
  }
}
