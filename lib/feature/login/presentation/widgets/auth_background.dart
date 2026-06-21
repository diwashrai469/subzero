import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/feature/login/presentation/constant/auth_constants.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.glowAlignment});

  final Alignment glowAlignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const _BackgroundGradient(),

        AnimatedAlign(
          duration: const Duration(milliseconds: 720),
          curve: Curves.easeOutCubic,
          alignment: glowAlignment,
          child: const _AmbientGlow(),
        ),
      ],
    );
  }
}

class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AuthPalette.bgTop, AuthPalette.bgMid, AuthPalette.bgBottom],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 360.w,
        height: 360.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AuthPalette.ice.withValues(alpha: 0.18),
              AuthPalette.ice.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}
