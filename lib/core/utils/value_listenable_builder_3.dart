import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A custom ValueListenableBuilder that listens to two ValueNotifiers
///
/// This utility widget allows listening to two separate ValueNotifiers
/// and rebuilds when either of them changes.
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  /// First ValueNotifier to listen to
  final ValueListenable<A> first;

  /// Second ValueNotifier to listen to
  final ValueListenable<B> second;

  /// Builder function that receives both values
  final Widget Function(BuildContext, A, B, Widget?) builder;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, firstValue, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, secondValue, _) {
            return builder(context, firstValue, secondValue, null);
          },
        );
      },
    );
  }
}

/// A custom ValueListenableBuilder that listens to two ValueNotifiers
///
/// This utility widget allows listening to two separate ValueNotifiers
/// and rebuilds when either of them changes.
class ValueListenableBuilder3<A, B, C> extends StatelessWidget {
  /// First ValueNotifier to listen to
  final ValueListenable<A> first;

  /// Second ValueNotifier to listen to
  final ValueListenable<B> second;

  /// Third ValueNotifier to listen to
  final ValueListenable<C> third;

  /// Builder function that receives both values
  final Widget Function(BuildContext, A, B, C, Widget?) builder;

  const ValueListenableBuilder3({
    super.key,
    required this.first,
    required this.second,
    required this.third,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, firstValue, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, secondValue, _) {
            return ValueListenableBuilder<C>(
              valueListenable: third,
              builder: (context, thirdValue, _) {
                return builder(
                  context,
                  firstValue,
                  secondValue,
                  thirdValue,
                  null,
                );
              },
            );
          },
        );
      },
    );
  }
}
