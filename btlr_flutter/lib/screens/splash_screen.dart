// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import 'login_screen.dart';

// // --- BRAND CONSTANTS ---
// const Color kPrimaryBlue = Color(0xFF274B7F);
// const Color kBackgroundWhite = Color(0xFFFFFFFF);

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late AnimationController _confettiController;

//   late Animation<double> _textEntrance;
//   late Animation<double> _progressBarValue;
//   late Animation<double> _butlerBobbing;
//   late Animation<double> _victorySpin;
//   late Animation<double> _victoryJump;
//   late Animation<double> _confettiScale;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 5000),
//     );

//     _confettiController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );

//     _textEntrance = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.0, 0.25, curve: Curves.elasticOut),
//     );

//     _progressBarValue = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.25, 0.85, curve: Curves.easeInOutCubic),
//     );

//     _butlerBobbing = TweenSequence([
//       TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -15.0), weight: 50),
//       TweenSequenceItem(tween: Tween<double>(begin: -15.0, end: 0.0), weight: 50),
//     ]).animate(
//       CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.85, curve: Curves.linear)),
//     );

//     _victorySpin = Tween<double>(begin: 0.0, end: 4 * math.pi).animate(
//       CurvedAnimation(parent: _controller, curve: const Interval(0.85, 0.98, curve: Curves.easeOutBack)),
//     );

//     _victoryJump = TweenSequence([
//       TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -100.0), weight: 50),
//       TweenSequenceItem(tween: Tween<double>(begin: -100.0, end: 0.0), weight: 50),
//     ]).animate(
//       CurvedAnimation(parent: _controller, curve: const Interval(0.85, 1.0, curve: Curves.bounceOut)),
//     );

//     _confettiScale = CurvedAnimation(
//       parent: _confettiController,
//       curve: Curves.easeOutBack,
//     );

//     _controller.addListener(() {
//       if (_controller.value >= 0.85 && !_confettiController.isAnimating && _confettiController.status != AnimationStatus.completed) {
//         _confettiController.forward();
//       }
//     });

//     _controller.forward();

//     Future.delayed(const Duration(milliseconds: 5500), () {
//       if (mounted) {
//         Navigator.of(context).pushReplacement(
//           PageRouteBuilder(
//             transitionDuration: const Duration(milliseconds: 1500),
//             pageBuilder: (context, anim, secAnim) => const LoginScreen(),
//             transitionsBuilder: (context, anim, secAnim, child) {
//               return FadeTransition(
//                 opacity: anim,
//                 child: ScaleTransition(
//                   scale: Tween<double>(begin: 1.1, end: 1.0).animate(anim),
//                   child: child,
//                 ),
//               );
//             },
//           ),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _confettiController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const double barWidth = 650.0;

//     return Scaffold(
//       backgroundColor: kBackgroundWhite,
//       body: Center(
//         child: AnimatedBuilder(
//           animation: Listenable.merge([_controller, _confettiController]),
//           builder: (context, child) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Opacity(
//                   opacity: _textEntrance.value,
//                   child: Transform.scale(
//                     scale: 0.5 + (0.5 * _textEntrance.value),
//                     child: const Text(
//                       "BTLR",
//                       style: TextStyle(
//                         fontSize: 120, // MASSIVE SIZE
//                         fontWeight: FontWeight.w700,
//                         color: kPrimaryBlue,
//                         letterSpacing: -6,
//                         height: 1.0,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 180),
//                 Stack(
//                   alignment: Alignment.center,
//                   clipBehavior: Clip.none,
//                   children: [
//                     // SAPPHIRE CONFETTI
//                     if (_confettiController.value > 0)
//                       ...List.generate(15, (index) {
//                         final angle = (index * 24) * (math.pi / 180);
//                         return Transform.translate(
//                           offset: Offset(
//                             math.cos(angle) * (200 * _confettiScale.value),
//                             math.sin(angle) * (200 * _confettiScale.value) - 100,
//                           ),
//                           child: Opacity(
//                             opacity: 1 - _confettiController.value,
//                             child: Container(
//                               width: 12,
//                               height: 12,
//                               decoration: const BoxDecoration(color: kPrimaryBlue, shape: BoxShape.circle),
//                             ),
//                           ),
//                         );
//                       }),
//                     // SCALED PROGRESS BAR
//                     SizedBox(
//                       width: barWidth,
//                       height: 12,
//                       child: Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               color: kPrimaryBlue.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           Container(
//                             width: barWidth * _progressBarValue.value,
//                             decoration: BoxDecoration(
//                               color: kPrimaryBlue,
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [BoxShadow(color: kPrimaryBlue.withOpacity(0.4), blurRadius: 15)],
//                             ),
//                           ),
//                           Positioned(
//                             left: (barWidth * _progressBarValue.value) - 70,
//                             top: -110 + (_controller.value < 0.85 ? _butlerBobbing.value : _victoryJump.value),
//                             child: Transform.rotate(
//                               angle: _victorySpin.value,
//                               child: Image.asset(
//                                 'lib/assets/logo.png', //
//                                 width: 140, // LARGER BUTLER
//                                 errorBuilder: (context, error, stackTrace) =>
//                                 const Icon(Icons.person, size: 90, color: kPrimaryBlue),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 50),
//                 Text(
//                   "${(_progressBarValue.value * 100).toInt()}%",
//                   style: const TextStyle(color: kPrimaryBlue, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



































import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'login_screen.dart';

// --- BRAND CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF274B7F);
const Color kBackgroundWhite = Color(0xFFFFFFFF);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _confettiController;

  late final Animation<double> _textEntrance;
  late final Animation<double> _progress;
  late final Animation<double> _bobbing;
  late final Animation<double> _spin;
  late final Animation<double> _jump;
  late final Animation<double> _confettiScale;
  late final Animation<double> _percentageFade;

  // Exit sequence animations
  late final Animation<double> _exitFade;
  late final Animation<double> _finalLogoScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _confettiController = AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _textEntrance = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.15, curve: Curves.easeIn),
    );

    _progress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.80, curve: Curves.easeInOutCubic),
    );

    _percentageFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.35, curve: Curves.easeIn),
    );

    _bobbing = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -20), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: -20, end: 0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.80, curve: Curves.linear)),
    );

    _spin = Tween<double>(begin: 0, end: 4 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.80, 0.95, curve: Curves.easeOutBack)),
    );

    _jump = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -120), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: -120, end: 0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.80, 1.0, curve: Curves.bounceOut)),
    );

    // COORDINATION: Final scale-up and fade out
    _finalLogoScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.90, 1.0, curve: Curves.easeInCirc)),
    );

    _exitFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.95, 1.0, curve: Curves.easeIn),
    );

    _confettiScale = CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOutBack,
    );

    _controller.addListener(() {
      if (_controller.value > 0.80 &&
          !_confettiController.isAnimating &&
          _confettiController.status != AnimationStatus.completed) {
        _confettiController.forward();
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToLogin();
      }
    });

    _controller.forward();
  }

  void _navigateToLogin() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Cross-fade the Login page in as the Splash scales away
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= 0) return const SizedBox.shrink();

          final barWidth = constraints.maxWidth * 0.55;
          const logoSize = 180.0;

          return AnimatedBuilder(
            animation: Listenable.merge([_controller, _confettiController]),
            builder: (context, _) {
              final progressWidth = (barWidth * _progress.value).clamp(0.0, barWidth);

              return Opacity(
                opacity: (1.0 - _exitFade.value).clamp(0.0, 1.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TEXT LOGO
                      Opacity(
                        opacity: _textEntrance.value,
                        child: const Text(
                          'BTLR',
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.w900,
                            color: kPrimaryBlue,
                            letterSpacing: -5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 140),

                      // PROGRESS AREA
                      SizedBox(
                        width: barWidth,
                        height: 12,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Track
                            Container(
                              width: barWidth,
                              height: 12,
                              decoration: BoxDecoration(
                                color: kPrimaryBlue.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),

                            // Fill
                            Container(
                              width: progressWidth,
                              height: 12,
                              decoration: BoxDecoration(
                                color: kPrimaryBlue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),

                            // CHARACTER
                            Positioned(
                              left: progressWidth - (logoSize / 2),
                              bottom: -20 + (_controller.value < 0.80 ? _bobbing.value : _jump.value),
                              child: Transform.rotate(
                                angle: _spin.value,
                                child: Transform.scale(
                                  scale: _finalLogoScale.value,
                                  child: SizedBox(
                                    width: logoSize,
                                    height: logoSize,
                                    child: Image.asset(
                                      'lib/assets/logo.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (ctx, _, __) => const Icon(
                                        Icons.face_retouching_natural,
                                        size: 100,
                                        color: kPrimaryBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // CONFETTI
                            if (_confettiController.value > 0)
                              Positioned(
                                left: barWidth / 2,
                                top: 0,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: List.generate(12, (i) {
                                    final angle = i * math.pi / 6;
                                    return Transform.translate(
                                      offset: Offset(
                                        math.cos(angle) * 160 * _confettiScale.value,
                                        math.sin(angle) * 160 * _confettiScale.value - 40,
                                      ),
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: kPrimaryBlue,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 80),

                      // PERCENTAGE
                      Opacity(
                        opacity: (_percentageFade.value - _exitFade.value).clamp(0.0, 1.0),
                        child: Text(
                          '${(_progress.value * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryBlue,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}