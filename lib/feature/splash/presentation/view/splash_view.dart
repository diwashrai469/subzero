// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:subzero/common/constant/app_image.dart';
// import 'package:subzero/core/app_routers/app_routers.dart';
// import 'package:subzero/core/app_routers/app_routers.gr.dart';
// import 'package:subzero/core/injection/injection_service.dart';
// import 'package:subzero/feature/login/presentation/constant/auth_constants.dart';

// /// Shared with LoginView's palette. If you've already promoted
// /// `_LoginPalette` to a top-level `AppColors` class, delete this block and
// /// import that instead — every name below maps 1:1.
// class _SplashPalette {
//   static const bgTop = Color(0xFF0A0E16);
//   static const bgMid = Color(0xFF0D1420);
//   static const bgBottom = Color(0xFF06080C);

//   static const ice = Color(0xFF6FE3FF);

//   static const glassFill = Color(0x14FFFFFF);
//   static const glassStroke = Color(0x29FFFFFF);

//   static const textPrimary = Color(0xFFF3F6FA);
//   static const textSecondary = Color(0xFF8C99AC);
// }

// @RoutePage()
// class SplashView extends StatefulWidget {
//   const SplashView({super.key});

//   @override
//   State<SplashView> createState() => _SplashViewState();
// }

// class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
//   final appRoutes = locator<AppRouters>();
//   // final isFirstLoad = locator<LocalStorageService>().read(
//   //   LocalStorageKeys.isFirstLoad,
//   // );

//   late final AnimationController _controller;

//   late final Animation<double> _markScale;
//   late final Animation<double> _markFade;
//   late final Animation<double> _glowFade;
//   late final Animation<double> _wordmarkFade;
//   late final Animation<Offset> _wordmarkSlide;
//   late final Animation<double> _taglineFade;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1600),
//       vsync: this,
//     );

//     // Mark: settles in with a gentle overshoot, no elastic jiggle.
//     _markScale = Tween<double>(begin: 0.82, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
//       ),
//     );
//     _markFade = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
//     );
//     _glowFade = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
//     );

//     // Wordmark follows the mark in, slides up slightly.
//     _wordmarkFade = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
//     );
//     _wordmarkSlide =
//         Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
//           CurvedAnimation(
//             parent: _controller,
//             curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
//           ),
//         );

//     // Tagline trails last, quiet and brief.
//     _taglineFade = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
//     );

//     _controller.forward().whenComplete(() {
//       Future.delayed(const Duration(milliseconds: 700), () {
//         if (!mounted) return;
//         appRoutes.pushAndPopUntil(
//           const LoginView(),
//           predicate: (route) => false,
//         );
//         // isFirstLoad == "true" || isFirstLoad == null
//         //     ? appRoutes.pushAndPopUntil(
//         //         const OnboardingView(),
//         //         predicate: (route) => false,
//         //       )
//         //     : appRoutes.pushAndPopUntil(
//         //         const DashboardView(),
//         //         predicate: (route) => false,
//         //       );
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _SplashPalette.bgBottom,
//       body: SizedBox.expand(
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             const _BackgroundGradient(),

//             FadeTransition(
//               opacity: _glowFade,
//               child: const Align(
//                 alignment: Alignment(0, -0.08),
//                 child: _AmbientGlow(),
//               ),
//             ),

//             Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   FadeTransition(
//                     opacity: _markFade,
//                     child: ScaleTransition(
//                       scale: _markScale,
//                       child: const _SplashMark(),
//                     ),
//                   ),
//                   SizedBox(height: 26.h),
//                   FadeTransition(
//                     opacity: _wordmarkFade,
//                     child: SlideTransition(
//                       position: _wordmarkSlide,
//                       child: Text(
//                         'Subzero',
//                         style: TextStyle(
//                           fontSize: 28.sp,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 0.6,
//                           color: _SplashPalette.textPrimary,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   FadeTransition(
//                     opacity: _taglineFade,
//                     child: Text(
//                       LoginCopy.tagline,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         fontWeight: FontWeight.w400,
//                         letterSpacing: 0.3,
//                         color: _SplashPalette.textSecondary,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Quiet loading hint, anchored low so it never competes with
//             // the mark for attention.
//             Align(
//               alignment: const Alignment(0, 0.88),
//               child: FadeTransition(
//                 opacity: _taglineFade,
//                 child: _PulsingDots(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _BackgroundGradient extends StatelessWidget {
//   const _BackgroundGradient();

//   @override
//   Widget build(BuildContext context) {
//     return const DecoratedBox(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             _SplashPalette.bgTop,
//             _SplashPalette.bgMid,
//             _SplashPalette.bgBottom,
//           ],
//           stops: [0.0, 0.55, 1.0],
//         ),
//       ),
//     );
//   }
// }

// class _AmbientGlow extends StatelessWidget {
//   const _AmbientGlow();

//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       child: Container(
//         width: 360.w,
//         height: 360.w,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: RadialGradient(
//             colors: [
//               _SplashPalette.ice.withValues(alpha: 0.18),
//               _SplashPalette.ice.withValues(alpha: 0.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Same frosted-glass squircle treatment as the login screen's app mark,
// /// so the two screens read as one continuous brand moment.
// class _SplashMark extends StatelessWidget {
//   const _SplashMark();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 112.w,
//       height: 112.w,
//       padding: EdgeInsets.all(5.w),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(32.r),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.white.withValues(alpha: 0.40),
//             Colors.white.withValues(alpha: 0.10),
//             Colors.white.withValues(alpha: 0.04),
//           ],
//           stops: const [0.0, 0.55, 1.0],
//         ),
//         border: Border.all(
//           color: Colors.white.withValues(alpha: 0.30),
//           width: 1.2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.28),
//             blurRadius: 14,
//             spreadRadius: -6,
//             offset: const Offset(0, 8),
//           ),
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.20),
//             blurRadius: 36,
//             spreadRadius: -10,
//             offset: const Offset(0, 22),
//           ),
//           BoxShadow(
//             color: _SplashPalette.ice.withValues(alpha: 0.22),
//             blurRadius: 54,
//             spreadRadius: -16,
//             offset: const Offset(0, 14),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(27.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.18),
//                   blurRadius: 18,
//                   spreadRadius: -6,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(26.r),
//               child: Image.asset(AppImage.appIcon, fit: BoxFit.cover),
//             ),
//           ),
//           Positioned(
//             top: 0,
//             left: 14.w,
//             right: 14.w,
//             child: Container(
//               height: 1.4,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(2.r),
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.white.withValues(alpha: 0.0),
//                     Colors.white.withValues(alpha: 0.55),
//                     Colors.white.withValues(alpha: 0.0),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Three small dots with a slow, staggered pulse — reads as "loading" without
// /// a literal spinner, and stays quiet enough not to fight the mark for focus.
// class _PulsingDots extends StatefulWidget {
//   const _PulsingDots();

//   @override
//   State<_PulsingDots> createState() => _PulsingDotsState();
// }

// class _PulsingDotsState extends State<_PulsingDots>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: List.generate(3, (i) {
//             final t = (_controller.value - i * 0.18) % 1.0;
//             final opacity =
//                 0.25 + 0.55 * (1 - (2 * t - 1).abs()).clamp(0.0, 1.0);
//             return Padding(
//               padding: EdgeInsets.symmetric(horizontal: 4.w),
//               child: Container(
//                 width: 6.w,
//                 height: 6.w,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _SplashPalette.ice.withValues(alpha: opacity),
//                 ),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
// }
