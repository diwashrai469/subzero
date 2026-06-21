import 'package:flutter/material.dart';

class LoginAnimations {
  LoginAnimations({required AnimationController controller})
    : markFade = CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
      markSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: controller,
              curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
            ),
          ),
      titleFade = CurvedAnimation(
        parent: controller,
        curve: const Interval(0.25, 0.70, curve: Curves.easeOut),
      ),
      titleSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: controller,
              curve: const Interval(0.25, 0.70, curve: Curves.easeOutCubic),
            ),
          ),
      panelFade = CurvedAnimation(
        parent: controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
      panelSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: controller,
              curve: const Interval(0.45, 0.8, curve: Curves.linearToEaseOut),
            ),
          );

  final Animation<double> markFade;
  final Animation<Offset> markSlide;

  final Animation<double> titleFade;
  final Animation<Offset> titleSlide;

  final Animation<double> panelFade;
  final Animation<Offset> panelSlide;
}
