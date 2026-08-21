import 'package:flutter/cupertino.dart';

class RightToLeftPageTransitionsBuilder extends PageTransitionsBuilder {
  const RightToLeftPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0), // Enters from right
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
