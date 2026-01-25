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
  late AnimationController _controller;
  late AnimationController _confettiController;

  late Animation<double> _textEntrance;
  late Animation<double> _progressBarValue;
  late Animation<double> _butlerBobbing;
  late Animation<double> _victorySpin;
  late Animation<double> _victoryJump;
  late Animation<double> _confettiScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _textEntrance = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.elasticOut),
    );

    _progressBarValue = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.85, curve: Curves.easeInOutCubic),
    );

    _butlerBobbing = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -15.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: -15.0, end: 0.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.85, curve: Curves.linear)),
    );

    _victorySpin = Tween<double>(begin: 0.0, end: 4 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.85, 0.98, curve: Curves.easeOutBack)),
    );

    _victoryJump = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -100.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: -100.0, end: 0.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.85, 1.0, curve: Curves.bounceOut)),
    );

    _confettiScale = CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOutBack,
    );

    _controller.addListener(() {
      if (_controller.value >= 0.85 && !_confettiController.isAnimating && _confettiController.status != AnimationStatus.completed) {
        _confettiController.forward();
      }
    });

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 5500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1500),
            pageBuilder: (context, anim, secAnim) => const LoginScreen(),
            transitionsBuilder: (context, anim, secAnim, child) {
              return FadeTransition(
                opacity: anim,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1.1, end: 1.0).animate(anim),
                  child: child,
                ),
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double barWidth = 650.0;

    return Scaffold(
      backgroundColor: kBackgroundWhite,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller, _confettiController]),
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: _textEntrance.value,
                  child: Transform.scale(
                    scale: 0.5 + (0.5 * _textEntrance.value),
                    child: const Text(
                      "BTLR",
                      style: TextStyle(
                        fontSize: 120, // MASSIVE SIZE
                        fontWeight: FontWeight.w700,
                        color: kPrimaryBlue,
                        letterSpacing: -6,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 180),
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // SAPPHIRE CONFETTI
                    if (_confettiController.value > 0)
                      ...List.generate(15, (index) {
                        final angle = (index * 24) * (math.pi / 180);
                        return Transform.translate(
                          offset: Offset(
                            math.cos(angle) * (200 * _confettiScale.value),
                            math.sin(angle) * (200 * _confettiScale.value) - 100,
                          ),
                          child: Opacity(
                            opacity: 1 - _confettiController.value,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(color: kPrimaryBlue, shape: BoxShape.circle),
                            ),
                          ),
                        );
                      }),
                    // SCALED PROGRESS BAR
                    SizedBox(
                      width: barWidth,
                      height: 12,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: kPrimaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Container(
                            width: barWidth * _progressBarValue.value,
                            decoration: BoxDecoration(
                              color: kPrimaryBlue,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [BoxShadow(color: kPrimaryBlue.withOpacity(0.4), blurRadius: 15)],
                            ),
                          ),
                          Positioned(
                            left: (barWidth * _progressBarValue.value) - 70,
                            top: -110 + (_controller.value < 0.85 ? _butlerBobbing.value : _victoryJump.value),
                            child: Transform.rotate(
                              angle: _victorySpin.value,
                              child: Image.asset(
                                'lib/assets/logo.png', //
                                width: 140, // LARGER BUTLER
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, size: 90, color: kPrimaryBlue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Text(
                  "${(_progressBarValue.value * 100).toInt()}%",
                  style: const TextStyle(color: kPrimaryBlue, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}