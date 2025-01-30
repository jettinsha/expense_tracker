import 'package:flutter/material.dart';

class AppAnimations {
  static Widget fadeIn(Widget child, Duration duration) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
}
